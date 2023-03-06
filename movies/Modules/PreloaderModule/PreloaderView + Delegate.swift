//
//  PreloaderView + Delegate.swift
//  movies
//
//  Created by Oleksandr Khalypa on 06.03.2023.
//

import UIKit
import WebKit

extension PreloaderView: WKNavigationDelegate, WKUIDelegate {
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.shouldPerformDownload {
            decisionHandler(.download)
            return
        }
        
        if let url = navigationAction.request.url {
            if isDeeplink(url) {
                handleDeeplink(url)
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }
    
    private func openDipLink(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func isDeeplink(_ url: URL) -> Bool {
        guard let scheme = url.scheme?.lowercased() else { return false }
        if scheme != "https" && scheme != "http" {
            return true
        }
        return false
    }
    
    private func handleDeeplink(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}

