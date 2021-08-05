//
//  AnimationManager.swift
//  twilight_timer
//
//  Created by Justin Majetich on 7/28/21.
//  Copyright © 2021 Justin Majetich. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class AnimationManager {
    let animation = Animation.named("TwilightAnimation")
    var animationView = AnimationView()
    
    // Time of upcoming sunset.
    var sunset: Date?
    
    
    // Enum used to track the current state of playback.
    private enum PlaybackState {
        case None
        case Progress
        case Twilight
    }
    private var currentPlayState = PlaybackState.None
    
    var refreshTask: DispatchWorkItem?

    init(wrapper animationWrapper: UIView) {

        // Observe sunset time updates.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didUpdateSunset),
            name: K.didUpdateSunset,
            object: nil
        )
        
        // Layout animation view in wrapper.
        animationView.contentMode = .scaleAspectFit
        animationWrapper.addSubview(animationView)
        SetLayoutConstraints(wrapper: animationWrapper)
        
        animationView.animation = animation
        showAnimation()
    }
    
    // This function drives the animation, selecting appropriate segments
    // for playback and controlling transitions between state.
    func showAnimation() {
        
        // UI affecting tasks should be performed async on the main thread.
        DispatchQueue.main.async {

            let now = Date()
            
            // If a sunset time has been registered...
            if self.sunset != nil {
                
                // If the current time is before sunset/twilight, play progress segment of animation.
                if now < self.sunset! {
                    
                    // If it's before twilight, but currentPlaybackState is Twilight (i.e. today's twilight has recently ended)
                    // smoothly transition from the current frame to end of animation and change playback state to Progress.
                    // The transition out of the twilight segement of animation will land on a frame
                    // which matches the opening frame of the progress segment.
                    if (self.currentPlayState == PlaybackState.Twilight) {

                        self.animationView.play(
                            fromFrame: self.animationView.realtimeAnimationFrame,
                            toFrame: 1200.0,
                            loopMode: .playOnce) { _ in
                                self.currentPlayState = PlaybackState.Progress
                        }
                    
                    // If it's before twilight and currentPlaybackState accurately reflects this,
                    // continue playing progress animation segement.
                    } else {
                    
                        self.animationView.play(
                            fromFrame: 0.0,
                            toFrame: self.getAnimationProgress(),
                            loopMode: .playOnce,
                            completion: nil
                        )
                        self.currentPlayState = PlaybackState.Progress
                    }

                // If the current time is during twilight, play twilight segment of animation.
                } else {

                    // If currentPlaybackState accurately reflects twilight, conitnue looping segement.
                    if (self.currentPlayState == PlaybackState.Twilight) {
                        self.animationView.play(
                            fromFrame: CGFloat(K.animationTwilightLoopStart),
                            toFrame: CGFloat(K.animationTwilightLoopEnd),
                            loopMode: .loop,
                            completion: nil
                        )
                        
                    // If currentPlaybackState does not accurately reflect Twilight,
                    // play the transitions between progress and twilight segments. When transition
                    // playback is completed, recall this method to show twilight loop.
                    } else {
                        self.animationView.play(
                            fromFrame: CGFloat(K.animationProgressEndFrame),
                            toFrame: CGFloat(K.animationTwilightLoopEnd),
                            loopMode: .playOnce) { _ in
                                self.showAnimation()
                        }
                    }
                    self.currentPlayState = PlaybackState.Twilight
                }
                
            // If no sunset time has been registered, display opening frame of animation.
            } else {
                self.animationView.animation = self.animation
                self.animationView.currentProgress = 0.0
            }
        }
        
        // Define and dispatch a task to refresh the animation at given intervals.
        refreshTask = DispatchWorkItem(block: {
            self.refreshTask?.cancel()
            self.showAnimation()
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + K.animationRefreshInterval, execute: refreshTask!)
    }
    
    // Calculates the current frame of animation according to the current progress in time
    // between the end of the previous twilight and the beginning of the upcoming twilight.
    private func getAnimationProgress() -> CGFloat {
              
        let secondsInDayMinusTwilight = K.dayDuration - K.twilightDuration
        
        let sunsetProgress = (secondsInDayMinusTwilight - sunset!.timeIntervalSinceNow) / secondsInDayMinusTwilight
                
        return CGFloat(K.animationProgressEndFrame * sunsetProgress)
    }
}


//MARK: - Notification Observance

extension AnimationManager {
    
    // Update sunset time with newest data.
    @objc func didUpdateSunset(_ notification: Notification) {
        
        if let data = notification.userInfo as? [String: Date] {
        
            sunset = data["nextSunset"]!
            showAnimation()
        }
    }
}


//MARK: - Animation Layout

extension AnimationManager {
    
    // Set up layout constraints for animation view and its wrapper.
    private func SetLayoutConstraints(wrapper animationWrapper: UIView) {
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        animationWrapper.addConstraint(NSLayoutConstraint(item: animationView, attribute: .leading, relatedBy: .equal, toItem: animationWrapper, attribute: .leading, multiplier: 1, constant: 1))
        animationWrapper.addConstraint(NSLayoutConstraint(item: animationView, attribute: .trailing, relatedBy: .equal, toItem: animationWrapper, attribute: .trailing, multiplier: 1, constant: 1))
        animationWrapper.addConstraint(NSLayoutConstraint(item: animationView, attribute: .top, relatedBy: .equal, toItem: animationWrapper, attribute:.top, multiplier: 1, constant: 1))
        animationWrapper.addConstraint(NSLayoutConstraint(item: animationView, attribute: .bottom, relatedBy: .equal, toItem: animationWrapper, attribute: .bottom, multiplier: 1, constant: 1))
    }
    
}
