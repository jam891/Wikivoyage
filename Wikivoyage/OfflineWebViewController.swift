//
//  OfflineWebViewController.swift
//  Wikivoyage
//
//  Created by Ben Meline on 9/24/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

import WebKit

class OfflineWebViewController: WebViewController {

    var html: String!
    
    override func setupScriptNames() {
        super.setupScriptNames()
        applyScriptName = "ApplyOfflineScript"
    }
    
    override func setupProgressView() {
        super.setupProgressView()
        progressView.hidden = true
    }
    
    override func setupButtons() {
        super.setupButtons()
        contentsButton.enabled = true
    }
    
    override func requestURL() {
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    // Disable WebView navigation except for original load
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        navigationAction.navigationType == .Other ? decisionHandler(WKNavigationActionPolicy.Allow) : decisionHandler(WKNavigationActionPolicy.Cancel)
    }
    
    override func setContentsButtonState(message: WKScriptMessage) {
        contentsButton.enabled = true
    }
}
