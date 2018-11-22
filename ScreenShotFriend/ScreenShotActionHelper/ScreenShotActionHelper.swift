//
//  ScreenShotActionHelper.swift
//  BirdNerd
//
//  Created by Chris Hawkins on 21/11/18.
//  Copyright © 2018 Chris Hawkins. All rights reserved.
//

import Foundation

open class ScreenShotActionHelper {
    
    private weak var delegate: ScreenShotActionHelperDelegate?
    private var configuration: ScreenShotActionCardConfiguration
    
    public init(delegate: ScreenShotActionHelperDelegate, appearanceConfiguration: ScreenShotActionCardConfiguration = ScreenShotActionCardConfiguration()) {
        self.delegate = delegate
        self.configuration = appearanceConfiguration
    }
    
    public func startListeningForScreenshots() {
        NotificationCenter.default.addObserver(self, selector: #selector(tookScreenshot(_:)), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }
    
    public func stopListeningForScreenshots() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }
    
    deinit {
        stopListeningForScreenshots()
    }
    
    @objc
    open func tookScreenshot(_: NSNotification) {
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let image = window.renderToImage() else { return }
        guard let delegate = delegate else { return }
        
        let card = ScreenShotActionCard.create(
            with: image,
            title: delegate.titleForScreenshotActionCard,
            subtitle: delegate.subtitleForScreenshotCard ?? "",
            appearanceConfiguration: configuration,
            onSelect: { [weak self] (image) in
                self?.delegate?.didSelectScreenshotAction(image: image)
        })
        card.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(card)
        
        card.startDisppearTimer()
        card.fadeInElements()
        
        let spacing = configuration.cardEdgeSpacing
        NSLayoutConstraint.activate([
            card.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -spacing.right),
            card.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: -spacing.bottom),
            card.leadingAnchor.constraint(greaterThanOrEqualTo: window.leadingAnchor, constant: spacing.left)
        ])

        card.alpha = 0.0
        UIView.animate(withDuration: configuration.cardAppearanceAnimationDuration) {
            card.alpha = 1.0
        }
        let scaleFactor = configuration.cardAppearanceScaleUpFactor
        card.transform = CGAffineTransform.identity.scaledBy(x: scaleFactor, y: scaleFactor)
        card.transform = CGAffineTransform.identity.translatedBy(
            x: UIScreen.main.bounds.size.width * configuration.cardAppearanceFractionalHorizontalOffset,
            y: UIScreen.main.bounds.size.height * configuration.cardAppearanceFractionalVerticalOffset
        )
        
        UIView.animate(withDuration: configuration.cardAppearanceSettlingAnimationDuration) {
            card.transform = CGAffineTransform.identity
        }
    }
}
