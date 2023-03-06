//
//  PreloaderViewController.swift
//  movies
//
//  Created by Oleksandr Khalypa on 26.02.2023.
//

import UIKit
import SnapKit
import FacebookCore
import StoreKit

class PreloaderViewController: UIViewController {

    weak var coordinator: AppCoordinator?
    private let networkManager = NetworkManager.shared
    lazy var errorView = NetworkErrorView(networkManager: networkManager)
    private let mainVIew = PreloaderView()
    private let viewModel = PreloaderViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func loadView() {
        self.view = mainVIew
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppEvents.logEvent(.viewedContent)
    }
    
    private func bind() {
        networkManager.isShowAlert.bind { [weak self] isShow in
            guard let self else { return }
            if isShow {
                self.showErrorView()
            } else {
                self.viewModel.getParams()
            }
        }
        
        mainVIew.openAppWithId.bind { [weak self] id in
            guard let self, let id else { return }
            let vc = SKStoreProductViewController()
            vc.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier : NSNumber(value: id)])
            self.present(vc, animated: true)
        }
        
        viewModel.isOpenWebView.bind { [weak self] isOpen in
            guard let self, isOpen != nil else { return }
                if isOpen! {
                    DispatchQueue.main.async {
                        self.showWebView()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.coordinator?.toMainVC()
                    }
                }
        }

        viewModel.urlSting.bind { [weak self] urlSting in
            guard let self, let urlSting, let url = URL(string: urlSting) else { return }
            self.mainVIew.load(with: url)
        }
    }
    
    
    private func showErrorView() {
        let errorView = NetworkErrorView(networkManager: networkManager)
        self.view.addSubview(errorView)
        
        errorView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func showWebView() {
        mainVIew.activityIndicator.stopAnimating()
        mainVIew.activityIndicator.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            self.mainVIew.webView.alpha = 1
        })
    }
    

}
