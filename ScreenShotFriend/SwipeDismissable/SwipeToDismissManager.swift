//
//  Swipable.swift
//  BirdNerd
//
//  Created by Chris Hawkins on 23/10/18.
//  Copyright © 2018 Chris Hawkins. All rights reserved.
//

import UIKit

class SwipeToDismissManager {
    var targetView: UIView
    weak var delegate: SwipeToDismissManagerDelegate?
    
    var startLocation: CGPoint!
    var lastLocation: CGPoint?
    var lastVelocity: CGPoint?
    
    var direction: SwipeDirection
    var appearanceConfiguration: SwipeToDismissConfiguration
    
    init(targetView: UIView, direction: SwipeDirection, delegate: SwipeToDismissManagerDelegate?, appearanceConfiguration: SwipeToDismissConfiguration = SwipeToDismissConfiguration()) {
        self.targetView = targetView
        self.delegate = delegate
        self.direction = direction
        self.appearanceConfiguration = appearanceConfiguration
    }
    
    func start() {
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
        targetView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc
    func handlePan(_ gestureRecognizer:UIPanGestureRecognizer) {
        let location = gestureRecognizer.location(in: nil)
        let velocity = gestureRecognizer.velocity(in: nil)
        var diff: CGFloat {
            return location[keyPath: direction.pointKeyPath] - startLocation[keyPath: direction.pointKeyPath]
        }
        
        func snapBack() {
            UIView.animate(withDuration: appearanceConfiguration.snapBackDuration, delay: 0.0, usingSpringWithDamping: appearanceConfiguration.snapBackSpringDampening, initialSpringVelocity: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                self.targetView.transform = .identity
            }) { (_) in
                self.delegate?.didBringSwipeToRest(view: self.targetView)
            }
        }
        
        func escape() {
            // Move a whole screen away at the current velocity
            let distance = direction.value(of: UIScreen.main.bounds.size)
            let dirVelocity = direction.value(of: velocity)
            let endPosition = diff + distance
            let duration =  TimeInterval(distance / dirVelocity)
            
            UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
                var transform = CGAffineTransform.identity
                transform[keyPath: self.direction.transformKeyPath] = endPosition
                self.targetView.transform = transform
            }) { (_) in
                self.delegate?.didSwipeToDismiss(view: self.targetView)
            }
        }
        
        switch gestureRecognizer.state {
        case .possible:
            break
        case .began:
            self.delegate?.didBeginSwiping(view: targetView)
            startLocation = location
        case .changed:
            var movement: CGFloat
            if (diff * direction.directionModifier) < 0 {
                var proporion = (-diff) / appearanceConfiguration.maxBackSwipe
                if proporion > 1.0 {
                    proporion = 1.0
                }
                else if proporion < 0.0 {
                    proporion = 0.0
                }
                var adjustedProportion = -proporion * (proporion - 2)
                adjustedProportion *= (1.0 - appearanceConfiguration.backSwipeFriction)
                movement = adjustedProportion * appearanceConfiguration.maxBackSwipe * -direction.directionModifier
            }
            else {
                movement = diff
            }
            var transform = CGAffineTransform.identity
            transform[keyPath: direction.transformKeyPath] = movement
            
            self.targetView.transform = transform
        case .cancelled: fallthrough
        case .failed: fallthrough
        case .ended:
            if (diff * direction.directionModifier) < 0 {
                snapBack()
            }
            else {
                let extrapolatedPosition = diff * direction.directionModifier + velocity[keyPath: direction.pointKeyPath] * direction.directionModifier * appearanceConfiguration.swipeExtrapolationDuration
                if extrapolatedPosition < appearanceConfiguration.snapbackWindow {
                    snapBack()
                }
                else {
                    escape()
                }
            }
        }
        
        lastLocation = location
        lastVelocity = velocity
    }
}
