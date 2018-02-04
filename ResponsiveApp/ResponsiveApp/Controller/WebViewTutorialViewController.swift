//
//  WebViewTutorialViewController.swift
//  ResponsiveApp
//
//  Created by Stoyan Kostov on 4.02.18.
//  Copyright © 2018 Stoyan Kostov. All rights reserved.
//

import UIKit

protocol WebViewTutorialViewControllerDelegate:class {
    func onSwipeFromLeft()
}

class WebViewTutorialViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var imageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageView: UILabel!
    
    // MARK: - Public interface
    public weak var delegate:WebViewTutorialViewControllerDelegate?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateImage()
    }
    
    // MARK: - Animation
    private func animateImage() {
        imageLeadingConstraint.constant = self.view.bounds.width / 2 - imageView.bounds.width
        UIView.animate(withDuration: 1.0, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }) { [weak self] finished in
            if finished {
                self?.imageLeadingConstraint.constant = 0
                self?.view.layoutIfNeeded()
                self?.animateImage()
            }
        }
    }

    // MARK: - Actions
    @IBAction func onBackgroundTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onSwipeFromLeft(_ sender: UIScreenEdgePanGestureRecognizer) {
        dismiss(animated: false, completion: nil)
        delegate?.onSwipeFromLeft()
    }
}
