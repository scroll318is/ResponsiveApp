//
//  WKViewController.swift
//  ResponsiveApp
//
//  Created by Stoyan Kostov on 3.02.18.
//  Copyright © 2018 Stoyan Kostov. All rights reserved.
//

import UIKit
import WebKit

class WKViewController: BaseViewController {
    
    // MARK: - Properties
    private var webView:WKWebView!
    private var url:URL!
    private var isStatusBarHidden:Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpWebView()
        applyConstraintsToWebView()
        addPanGestureToWebView()
        loadUrl()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if navigationController?.isNavigationBarHidden ?? false {
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    // MARK: - Public Interface
    public func inject(url:URL) {
        self.url = url
    }
    
    // MARK: - Helpers
    private func setUpWebView() {
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.contentMode = .scaleToFill
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false
        self.view.addSubview(webView)
    }
    
    private func loadUrl() {
        let request = URLRequest(url:url)
        webView.load(request)
    }
    
    private func addPanGestureToWebView() {
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(onLeftHandSidePan(_:)))
        edgeGesture.edges = .left
        edgeGesture.delegate = self
        webView.scrollView.addGestureRecognizer(edgeGesture)
    }
    
    private func applyConstraintsToWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        var constraints:[NSLayoutConstraint] = []
        constraints.append(webView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor))
        constraints.append(webView.rightAnchor.constraint(equalTo: self.view.rightAnchor))
        constraints.append(webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor))
        constraints.append(webView.leftAnchor.constraint(equalTo: self.view.leftAnchor))
        NSLayoutConstraint.activate(constraints)
    }
    
    private func showTutorial() {
        let key = "WVTS"
        if !UserDefaults.standard.bool(forKey: key) {
            let tutorialViewController = storyboard!.instantiateViewController(withIdentifier: "WebViewTutorialViewController") as! WebViewTutorialViewController
            tutorialViewController.delegate = self
            navigationController?.present(tutorialViewController, animated: false, completion:nil)
            UserDefaults.standard.set(true, forKey: key)
        }
    }
    
    private func popBack() {
        if navigationController?.isNavigationBarHidden ?? false {
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Actions
    @objc private func onLeftHandSidePan(_ sender: UIScreenEdgePanGestureRecognizer) {
        popBack()
    }
    
    @IBAction func onSwipeUpGesture(_ sender: UISwipeGestureRecognizer) {
        guard let navigationController = navigationController else { return }
        if !(navigationController.isNavigationBarHidden) {
            UIView.transition(with: view,
                              duration: TimeInterval(UINavigationControllerHideShowBarDuration),
                              options: .curveEaseOut,
                              animations:
            { [weak self] in
                self?.isStatusBarHidden = true
                self?.navigationController?.setNavigationBarHidden(true, animated: true)
            }, completion: { [weak self] finished in
                self?.showTutorial()
            })
        }
    }
}

// MARK: - WKNavigationDelegate
extension WKViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        startLoading()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        finishLoading()
    }
}

// MARK: - WebViewTutorialViewControllerDelegate
extension WKViewController: WebViewTutorialViewControllerDelegate {
    func onSwipeFromLeft() {
        popBack()
    }
}

// MARK: - UIGestureRecognizerDelegate
extension WKViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


