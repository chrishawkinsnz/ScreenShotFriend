//
//  SwipeDirection.swift
//  BirdNerd
//
//  Created by Chris Hawkins on 22/11/18.
//  Copyright © 2018 Chris Hawkins. All rights reserved.
//

import Foundation

/// The Direction an element must be swiped to dismiss
@objc
public enum SwipeDirection: Int {
    case right
    case left
    case up
    case down
}

/// Below are a colleciton of helpers for abstractly dealing with directions
internal extension SwipeDirection {
    var axis: Axis {
        switch self {
        case .right:    return .Vertical
        case .left:     return .Vertical
        case .up:       return .horizontal
        case .down:     return .horizontal
        }
    }
    
    var pointKeyPath: KeyPath<CGPoint, CGFloat> {
        return axis.pointKeyPath
    }
    
    var sizeKeyPath: KeyPath<CGSize, CGFloat> {
        return axis.sizeKeyPath
    }
    
    var directionModifier: CGFloat {
        switch self {
        case .right:    return 1
        case .left:     return -1
        case .up:       return -1
        case .down:     return 1
        }
    }
    
    var transformKeyPath: WritableKeyPath<CGAffineTransform, CGFloat> {
        return axis.transformKeyPath
    }
    
    func value(of point: CGPoint) -> CGFloat {
        return point[keyPath: pointKeyPath] * directionModifier
    }
    
    func value(of size: CGSize) -> CGFloat {
        return size[keyPath: sizeKeyPath] * directionModifier
    }
}

internal
enum Axis {
    case horizontal
    case Vertical
    
    var pointKeyPath: KeyPath<CGPoint, CGFloat> {
        switch self {
        case .horizontal:  return \.y
        case .Vertical:    return \.x
        }
    }
    
    var sizeKeyPath: KeyPath<CGSize, CGFloat> {
        switch self {
        case .horizontal:  return \.height
        case .Vertical:    return \.width
        }
    }
    
    var transformKeyPath: WritableKeyPath<CGAffineTransform, CGFloat> {
        switch self {
        case .horizontal:  return \.ty
        case .Vertical:    return \.tx
        }
    }
}
