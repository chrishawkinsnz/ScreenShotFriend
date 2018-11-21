//
//  ViewController.swift
//  Example
//
//  Created by Chris Hawkins on 22/11/18.
//  Copyright © 2018 Chris Hawkins. All rights reserved.
//

import UIKit
import ScreenShotFriend

class ViewController: UIViewController {

    var manager: ScreenShotActionHelper!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager = ScreenShotActionHelper.init(delegate: self)
        manager.startListeningForScreenshots()
    }

    @IBAction func didSelectScreenshotButton(_ sender: Any) {
        /// Feign the screenshot action so the example can run in the simulator
        NotificationCenter.default.post(name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }
    
}

extension ViewController: ScreenShotActionHelperDelegate {

    var titleForScreenshotActionCard: String {
        return "Example Title"
    }
    
    var subtitleForScreenshotCard: String? {
        return "Example subtitle"
    }
    
    func didSelectScreenshotAction(image: UIImage) {
        let alert = UIAlertController(title: "You selected the screnshot", message: "\(image)", preferredStyle: .alert)
        alert.addAction(.init(title: "Cool", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
