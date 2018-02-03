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
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    // MARK: - Public Interface
    public func inject(url:URL) {
        self.url = url
    }
    
    // MARK: - Helpers
    private func setUpWebView() {
        let userContentController = WKUserContentController();
        userContentController.add(self, name: "iOS");
        let jScript = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" +
        "head.appendChild(meta);";
        let wkUScript = WKUserScript(source: jScript, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        userContentController.addUserScript(wkUScript)
        let configuration = WKWebViewConfiguration();
        configuration.userContentController = userContentController;

        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.backgroundColor = .red
        webView.navigationDelegate = self
        self.view.addSubview(webView)
    }
    
    private func applyConstraintsToWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        var constraints:[NSLayoutConstraint] = []
        constraints.append(webView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor))
        constraints.append(webView.rightAnchor.constraint(equalTo: self.view.rightAnchor))
        constraints.append(webView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor))
        constraints.append(webView.leftAnchor.constraint(equalTo: self.view.leftAnchor))
        NSLayoutConstraint.activate(constraints)
    }
    
}

// MARK: - WKNavigationDelegate
extension WKViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(webView.url?.absoluteString)
    }
}

extension WKViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message)
    }
}



