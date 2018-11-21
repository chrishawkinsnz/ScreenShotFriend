//
//  ScreenShotActionHelper.swift
//  BirdNerd
//
//  Created by Chris Hawkins on 21/11/18.
//  Copyright © 2018 Chris Hawkins. All rights reserved.
//

import Foundation

public
class ScreenShotActionHelper {
    
    weak var delegate: ScreenShotActionHelperDelegate?
    
    public init(delegate: ScreenShotActionHelperDelegate) {
        self.delegate = delegate
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
    func tookScreenshot(_: NSNotification) {
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let image = window.renderToImage() else { return }
        guard let delegate = delegate else { return }
        
        let config = delegate.appearanceConfiguration
        
        let card = ScreenShotActionCard.create(
            with: image,
            title: delegate.titleForScreenshotActionCard,
            subtitle: delegate.subtitleForScreenshotCard ?? "",
            appearanceConfiguration: delegate.appearanceConfiguration,
            onSelect: { [weak self] (image) in
                self?.delegate?.didSelectScreenshotAction(image: image)
        })
        card.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(card)
        
        card.startDisppearTimer()
        card.fadeInElements()
        
        let spacing = config.cardEdgeSpacing
        NSLayoutConstraint.activate([
            card.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -spacing.right),
            card.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: -spacing.bottom),
            card.leadingAnchor.constraint(greaterThanOrEqualTo: window.leadingAnchor, constant: spacing.left)
        ])

        card.alpha = 0.0
        UIView.animate(withDuration: delegate.appearanceConfiguration.cardAppearanceAnimationDuration) {
            card.alpha = 1.0
        }
        let scaleFactor = delegate.appearanceConfiguration.cardAppearanceScaleUpFactor
        card.transform = CGAffineTransform.identity.scaledBy(x: scaleFactor, y: scaleFactor)
        card.transform = CGAffineTransform.identity.translatedBy(
            x: UIScreen.main.bounds.size.width * delegate.appearanceConfiguration.cardAppearanceFractionalHorizontalOffset,
            y: UIScreen.main.bounds.size.height * delegate.appearanceConfiguration.cardAppearanceFractionalVerticalOffset
        )
        
        UIView.animate(withDuration: config.cardAppearanceSettlingAnimationDuration) {
            card.transform = CGAffineTransform.identity
        }
    }
}
