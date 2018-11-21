//
//  ScreenShotActionCardConfiguration.swift
//  BirdNerd
//
//  Created by Chris Hawkins on 22/11/18.
//  Copyright © 2018 Chris Hawkins. All rights reserved.
//

import Foundation

/// A class that exposes all points of configuration for the presentaiotn of a ScreenShotActionCard
public class ScreenShotActionCardConfiguration {
    /// The time of inaction before the screen shot action card disappears
    var disappearDelayTime: TimeInterval = 5.65
    
    /// The duration of the card disappearance animation
    var disappearAnimationDuration: TimeInterval = 0.36
    
    /// The corner radius of the card
    var cardCornerRadius: CGFloat = 4
    
    /// The tilt angle of the card in radians
    var imageTiltAngle: CGFloat = -0.14
    
    /// The delay before the imageView fades in
    var imageViewFadeInDelay: TimeInterval = 0.5
    
    /// The delay before the title fades in
    var titleLabelFadeInDelay: TimeInterval = 0.62
    
    /// The delay before the detail fades in
    var detailLabelFadeInDelay: TimeInterval = 0.62
    
    /// The delay before the disclosure icon fades in
    var disclosureIconFadeInDelay: TimeInterval = 0.72
    
    /// The duration of all (image view, title label, detail label and disclosure icon) fade aniamtions
    var fadeInElementDuration: TimeInterval = 1.0
    
    /// The duration of the highlight animation
    var highlightAniamtionDuration: TimeInterval = 0.1
    
    /// The highlighted color for the card
    var highlightedColor: UIColor = UIColor(white: 0.9, alpha: 1.0)
    
    /// The unhighlighted color for the card
    var backgroundColor: UIColor = UIColor(white: 1.0, alpha: 1.0)
    
    /// The duration of the overall card fade in animation
    var cardAppearanceAnimationDuration: TimeInterval = 0.3
    
    /// The factor which the card begins scaled up before shrinking down on appearance
    var cardAppearanceScaleUpFactor: CGFloat = 1.1
    
    /// The amount the card begins horizontally offset as a fraciton of its hosting view
    var cardAppearanceFractionalHorizontalOffset: CGFloat = -0.015
    
    /// The amount the card begins vertically offset as a fraciton of its hosting view
    var cardAppearanceFractionalVerticalOffset: CGFloat = -0.03
    
    /// The duration of the animation that settles the card into place in the bottom right
    var cardAppearanceSettlingAnimationDuration: TimeInterval = 0.8
    
    /// The tint color for colored elements
    /// Defaults to the standard tint color
    var tintColor: UIColor? = nil
    
    /// The minimum space to leave on the left, right and bottom of the card
    /// Top is ignored
    var cardEdgeSpacing: UIEdgeInsets = {
        var insets = UIEdgeInsets(top: 0, left: 114, bottom: 10, right: 10)

        // Notched devices may get a little extra height
        if #available(iOS 11.0, *) {
            insets.bottom = max(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0, 10)
            insets.right = max(UIApplication.shared.keyWindow?.safeAreaInsets.right ?? 0, 10)
        }

        return insets
    }()
    
    public class CardAppearanceConfiguration {
        /// The corner radius for a card
        var cornerRadius: CGFloat = 4
        
        /// The shadow color for a card
        var shadowColor: UIColor = .black
        
        /// The shadow opacity for a card
        var shadowOpacity: CGFloat = 0.2
        
        /// The shadow radius for a card
        var shadowRadius: CGFloat = 4
        
        /// The shadow offset for a card
        var shadowOffset: CGSize = CGSize(width: 0, height: 1)
    }
    
    /// The appearance properties for the main cards cardy appearance
    var mainCardAppearance: CardAppearanceConfiguration = CardAppearanceConfiguration()
    
    /// The appearance properties for the image cards cardy appearance
    var imageCardAppearance: CardAppearanceConfiguration = CardAppearanceConfiguration()
    
    var swipeToDismissAppearanceConfiguration: SwipeToDismissConfiguration = SwipeToDismissConfiguration()
}
