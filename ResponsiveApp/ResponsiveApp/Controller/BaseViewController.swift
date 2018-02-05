//
//  BaseViewController.swift
//  ResponsiveApp
//
//  Created by Stoyan Kostov on 5.02.18.
//  Copyright © 2018 Stoyan Kostov. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    private var loadingViewController:LoadingViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    func startLoading() {
        guard loadingViewController == nil else { return }
        loadingViewController = storyboard?.instantiateViewController(withIdentifier: "LoadingViewController") as? LoadingViewController
        present(loadingViewController!, animated: false, completion: nil)
    }
    
    func finishLoading() {
        guard loadingViewController != nil else { return }
        loadingViewController?.dismiss(animated: false, completion: nil)
        loadingViewController = nil
    }
    
}
