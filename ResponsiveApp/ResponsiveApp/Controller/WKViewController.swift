//
//  WKViewController.swift
//  ResponsiveApp
//
//  Created by Stoyan Kostov on 3.02.18.
//  Copyright © 2018 Stoyan Kostov. All rights reserved.
//

import UIKit
import WebKit

class WKViewController: UIViewController {
    
    private var webView:WKWebView!
    private var url:URL!
    
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
    
    // MARK: - Public Interface
    public func inject(url:URL) {
        self.url = url
    }
    
    // MARK: - Helpers
    private func setUpWebView() {
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.contentMode = .scaleToFill
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
    
    // MARK: - Actions
    @objc private func onLeftHandSidePan(_ sender: UIScreenEdgePanGestureRecognizer) {
        if navigationController?.isNavigationBarHidden ?? false {
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension WKViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}



