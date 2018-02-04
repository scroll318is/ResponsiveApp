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
        let request = URLRequest(url:url)
        webView.load(request)
        webView.scrollView.isScrollEnabled = false
    }
    
    // MARK: - Public Interface
    public func inject(url:URL) {
        self.url = url
    }
    
    // MARK: - Helpers
    private func setUpWebView() {
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.navigationDelegate = self
        webView.contentMode = .scaleToFill
        self.view.addSubview(webView)
    }
    
    private func applyConstraintsToWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        var constraints:[NSLayoutConstraint] = []
        constraints.append(webView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor))
        constraints.append(webView.rightAnchor.constraint(equalTo: self.view.rightAnchor))
        constraints.append(webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor))
        constraints.append(webView.leftAnchor.constraint(equalTo: self.view.leftAnchor))
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - WKNavigationDelegate
extension WKViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(webView.url?.absoluteString as Any)
    }
}

extension WKViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message)
    }
}



