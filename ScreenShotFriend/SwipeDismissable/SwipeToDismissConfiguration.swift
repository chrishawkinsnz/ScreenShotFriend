//
//  SwipeToDismissConfiguration.swift
//  BirdNerd
//
//  Created by Chris Hawkins on 22/11/18.
//  Copyright © 2018 Chris Hawkins. All rights reserved.
//

import Foundation

class SwipeToDismissConfiguration {
    /// The maximum distance in the reverse direction the view can be backswiped
    var maxBackSwipe: CGFloat = 100
    
    /// The friction constant that slows down back swiping relative to normal swiping
    var backSwipeFriction: CGFloat = 0.9
    
    /// The duration of the animation that snaps the view back to place
    var snapBackDuration: TimeInterval = 0.3
    
    /// The spring dampening that powers the animation that snaps the view back to place
    var snapBackSpringDampening: CGFloat = 0.9
    
    /// The length of time the manager will extrapolate movement when deciding whether to snap back or dismiss
    var swipeExtrapolationDuration: CGFloat = 0.5
    
    /// The window of space that the view will snap back to its resting position in
    /// This considers extrapolation forward of the views position based on it's current velocity and the swipeExtrapolationDuration proprety
    var snapbackWindow: CGFloat = 300
}
