//
//  SwipeToDismissDelegate.swift
//  BirdNerd
//
//  Created by Chris Hawkins on 22/11/18.
//  Copyright © 2018 Chris Hawkins. All rights reserved.
//

import Foundation

protocol SwipeToDismissManagerDelegate: class {
    
    // Callback on a successful swipe to dismiss
    func didSwipeToDismiss(view: UIView)
    
    // Callback on a cancelling of a swipe to dismiss
    func didBringSwipeToRest(view: UIView)
    
    // Callback on a beginign swiping to dismiss
    func didBeginSwiping(view: UIView)
    
}

extension SwipeToDismissConfiguration {
    
    func didSwipeToDismiss(view: UIView) {
        
    }
    
    func didBringSwipeToRest(view: UIView) {
        
    }
    
    func didBeginSwiping(view: UIView) {
        
    }
    
}
