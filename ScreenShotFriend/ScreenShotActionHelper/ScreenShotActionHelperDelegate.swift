//
//  ScreenShotActionHelperDelegate.swift
//  BirdNerd
//
//  Created by Chris Hawkins on 22/11/18.
//  Copyright © 2018 Chris Hawkins. All rights reserved.
//

import Foundation

public protocol ScreenShotActionHelperDelegate: class {
    
    /// The title to display on the screen shot action card, required
    var titleForScreenshotActionCard: String { get }
    
    /// The subtitle to display on the screen shot action card, optional
    var subtitleForScreenshotCard: String? { get }
    
    /// The action to perform on the user seleciton the screen shot action card
    func didSelectScreenshotAction(image: UIImage)
    
    /// The view to host the screen shot card presentation
    /// Defaults to the applications key window
    var hostingViewForScreenshotCard: UIView { get }
    
    /// The appearance of screenshot card
    /// The default value of this uses the configuration options expsed by the default initalizer for ScreenShotActionCardConfiguration
    var appearanceConfiguration: ScreenShotActionCardConfiguration { get }
}

public extension ScreenShotActionHelperDelegate {
    
    var subtitleForScreenshotCard: String? {
        return nil
    }
    
    var hostingViewForScreenshotCard: UIView {
        return UIApplication.shared.keyWindow!
    }
    
    var appearanceConfiguration: ScreenShotActionCardConfiguration {
        return ScreenShotActionCardConfiguration()
    }
}
