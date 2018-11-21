//
//  BugReportView.swift
//  BirdNerd
//
//  Created by Chris Hawkins on 22/10/18.
//  Copyright © 2018 Chris Hawkins. All rights reserved.
//

import UIKit

public class ScreenShotActionCard: UIView {
    
    var configuration: ScreenShotActionCardConfiguration = ScreenShotActionCardConfiguration()
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
    @IBOutlet var imageViewContainer: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var disclosureIcon: UIImageView!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var card: UIView!

    private var onSelect: () -> Void = { }
    private var selected: Bool = false
    
    private var disappearTimer: Timer?
    
    private var isSelecting: Bool = false { didSet { reevaluateTimer() } }
    private var isSwiping: Bool = false { didSet { reevaluateTimer() } }
    
    private var swipeToDismissManager: SwipeToDismissManager!
    
    static func create(with image: UIImage, title: String, subtitle: String, appearanceConfiguration: ScreenShotActionCardConfiguration, onSelect: @escaping (UIImage) -> Void) -> ScreenShotActionCard {
        let nib = UINib(nibName: "ScreenShotActionCard", bundle: Bundle(for: self))
        let card = nib.instantiate(withOwner: nil, options: nil).first as! ScreenShotActionCard
        card.configure(with: image, title: title, subtitle: subtitle, appearanceConfiguration: appearanceConfiguration, onSelect: onSelect)
        return card
    }
    
    public override func awakeFromNib() {
        let tapper = UITapGestureRecognizer.init(target: self, action: #selector(didTouchUpInside(_:)))
        self.addGestureRecognizer(tapper)
    }
    
    private func configure(with image: UIImage, title: String, subtitle: String, appearanceConfiguration: ScreenShotActionCardConfiguration, onSelect: @escaping (UIImage) -> Void) {
        configuration = appearanceConfiguration
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        titleLabel.text = title
        detailLabel.text = subtitle
        let aspectRatio = image.size.width / image.size.height
        imageWidthConstraint.constant = aspectRatio * imageHeightConstraint.constant
        
        applyCardAppearance(to: card, configuration: configuration.mainCardAppearance)
        applyCardAppearance(to: imageViewContainer, configuration: configuration.imageCardAppearance)
        imageViewContainer.transform = CGAffineTransform.identity.rotated(by: configuration.imageTiltAngle)
        setNeedsLayout()
        layoutIfNeeded()
        self.onSelect = { onSelect(image) }
        
        let tintColor = configuration.tintColor ?? disclosureIcon.tintColor
        // Tint colors are in some cases ignored on initial setting unless you clear the tint color
        disclosureIcon.tintColor = nil
        disclosureIcon.tintColor = tintColor
        disclosureIcon.alpha = 0.0
        
        swipeToDismissManager = SwipeToDismissManager(targetView: self, direction: .right, delegate: self, appearanceConfiguration: appearanceConfiguration.swipeToDismissAppearanceConfiguration)
        swipeToDismissManager.start()
    }
    
    func fadeInElements() {
        let fadingViews = [imageView, titleLabel, detailLabel, disclosureIcon]
        fadingViews.forEach { $0?.alpha = 0.0 }
        
        // Stagger fade in all the views so it roughly appears top left to bottom right
        let delays: [TimeInterval] = [
            configuration.imageViewFadeInDelay,
            configuration.titleLabelFadeInDelay,
            configuration.detailLabelFadeInDelay,
            configuration.disclosureIconFadeInDelay
        ]
        for (index, view) in fadingViews.enumerated() {
            let delay = delays[index]
            UIView.animate(withDuration: configuration.fadeInElementDuration, delay: delay, options: .curveEaseInOut, animations: {
                view?.alpha = 1.0
            }, completion: nil)
        }
    }
    
    func startDisppearTimer() {
        disappearTimer = Timer.scheduledTimer(withTimeInterval: configuration.disappearDelayTime, repeats: false, block: { [weak self] (_) in
            guard let `self` = self else { return }
            UIView.animate(withDuration: self.configuration.disappearAnimationDuration, delay: 0.0, options: .curveEaseIn, animations: {
                self.transform = CGAffineTransform.identity.translatedBy(x: UIScreen.main.bounds.size.width, y: 0)
            }, completion: { _ in
                self.removeFromSuperview()
            })
        })
    }
    
    func stopDisappearTimer() {
        disappearTimer?.invalidate()
    }
    
    func reevaluateTimer() {
        if isSwiping || isSelecting {
            stopDisappearTimer()
        }
        else {
            startDisppearTimer()
        }
    }
    
    
    @IBAction func didTouchUpInside(_ sender: Any) {
        self.isSelecting = true
        UIView.animate(withDuration: configuration.disappearAnimationDuration, delay: 0.0, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform.identity.translatedBy(x: UIScreen.main.bounds.size.width, y: 0)
            self.card.backgroundColor = .white
        }) { (_) in
            self.onSelect()
        }
    }
    
    @IBAction func touchDown(_ sender: UIButton) {
        UIView.animate(withDuration: configuration.highlightAniamtionDuration) {
            self.card.backgroundColor = self.configuration.highlightedColor
        }
    }
    
    @IBAction func touchCacnel(_ sender: UIButton) {
        self.isSelecting = false
        UIView.animate(withDuration: configuration.highlightAniamtionDuration) {
            self.card.backgroundColor = self.configuration.backgroundColor
        }
    }
    
    func applyCardAppearance(to view: UIView, configuration: ScreenShotActionCardConfiguration.CardAppearanceConfiguration) {
        view.layer.cornerRadius = configuration.cornerRadius
        view.layer.shadowOffset = configuration.shadowOffset
        view.layer.shadowColor = configuration.shadowColor.cgColor
        view.layer.shadowOpacity = Float(configuration.shadowOpacity)
        view.layer.shadowRadius = configuration.shadowRadius
    }
    
}

extension ScreenShotActionCard: SwipeToDismissManagerDelegate {
    func didSwipeToDismiss(view: UIView) {
        self.removeFromSuperview()
    }
    
    func didBringSwipeToRest(view: UIView) {
        self.isSwiping = false
    }
    
    func didBeginSwiping(view: UIView) {
        self.isSwiping = true
    }
}
