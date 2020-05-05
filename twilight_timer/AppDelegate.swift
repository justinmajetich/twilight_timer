//
//  AppDelegate.swift
//  twilight_timer
//
//  Created by Asiya on 2/22/20.
//  Copyright © 2020 Justin Majetich. All rights reserved.
//

import UIKit
import CoreLocation
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Initialize managers
    var locationManager = CLLocationManager()
    var userNotificationManager = UserNotificationManager()
    var storageManager = StorageManager()
    var sunsetManager = SunsetManager()

    let sunsetViewController: ViewController? = window
    
    var currentSunset: SunsetModel?
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if let storedSunset: SunsetModel? = storageManager.load(from: K.storedSunsetFilename) {
            currentSunset = storedSunset
        } else {
//            currentSunset = SunsetModel()
        }
        
        sunsetManager.delegate = self
        
        // Start location services
        setupLocationManager()
        
        // Successfully updated location will trigger weather fetch
        locationManager.requestLocation()
        
        // Register background weather fetch
        BGTaskScheduler.shared.register(forTaskWithIdentifier: K.bgWeatherRefreshID, using: nil) { task in
            self.manageBackgroundWeatherRefresh(task as! BGAppRefreshTask)
        }
        
        // Authorize local notifications
        userNotificationManager.authorize()
        
        print("Did Finish Launching With Options")
        
        return true
    }


    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
    //MARK: - BackgroundTasks
      
    func manageBackgroundWeatherRefresh(_ task: BGAppRefreshTask) {
          
        let queue = OperationQueue()
        
        let operation = BackgroundSunsetRefresh()
        
        // Clean-up if task expires
        task.expirationHandler = {
            queue.cancelAllOperations()
        }
        
        // Inform system that task is complete when operation completes successfully
        operation.completionBlock = {
            task.setTaskCompleted(success: !operation.isCancelled)
        }
        
        // Start operation
        queue.addOperation(operation)
    }
    
    func scheduleBackgroundRefresh() {
        
    }
}

//MARK: - CLLocationManagerDelegate

extension AppDelegate: CLLocationManagerDelegate {
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("Location Updated: \(locations)")
        
        if let safeLocation = locations.last{
            let latitude = String(safeLocation.coordinate.latitude)
            let longitude = String(safeLocation.coordinate.longitude)
            sunsetManager.fetchSunsetData(lat: latitude, lon: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("Location Services Authorized When In Use")
        } else {
            print("Location Services Not Authorized")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Error: \(error)")
    }
    
}

//MARK: - SunsetManagerDelegate

extension AppDelegate: SunsetManagerDelegate {
    
    func didUpdateSunset(manager: SunsetManager, _ sunset: SunsetModel) {

        storageManager.save(sunset, to: K.storedSunsetFilename)
        
        
        // format date with current timezone
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss, MM/dd/yyyy z"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let localTime = dateFormatter.string(from: sunset.sunsetTime)
        let locationName = sunset.placeName

        print("Today's sunset in \(String(describing: locationName)) is at \(localTime).")

        // Clear scheduled notification and set new
        userNotificationManager.clear()
        let testNotif = userNotificationManager.create(title: "Test Sunset Alert",
                                                   body: "This is a test of the sunset notification system.")
        userNotificationManager.schedule(for: sunset.sunsetTime, content: testNotif)

    }
    
    func didFailUpdateWithError(error: Error) {
        print("Sunset Update Failed: \(error)")
    }
    
}
