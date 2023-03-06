//
//  WebView.swift
//  movies
//
//  Created by Oleksandr Khalypa on 27.02.2023.
//

import WebKit
import UIKit
import SnapKit

final class PreloaderView: UIView {

    var openAppWithId: Dynamic<Int?> = Dynamic(nil)
    
    let activityIndicator: UIActivityIndicatorView = {
        let obj = UIActivityIndicatorView()
        obj.isHidden = false
        obj.startAnimating()
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    lazy var webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let coinfiguration = WKWebViewConfiguration()
        coinfiguration.defaultWebpagePreferences = preferences
        let obj = WKWebView(frame: .zero, configuration: coinfiguration)
        obj.navigationDelegate = self
        obj.uiDelegate = self
        obj.alpha = 0
        obj.allowsBackForwardNavigationGestures = true
        return obj
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(with url: URL) {
        self.webView.load(URLRequest(url: url))
        
    }
    
    private func setupUI() {
        backgroundColor = .white
        addSubview(webView)
        addSubview(activityIndicator)
        addConstraint()
    }
    
    private func addConstraint() {
        webView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(webView.snp.center)
        }
    }
    
}

