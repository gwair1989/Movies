//
//  NetworkErrorView.swift
//  movies
//
//  Created by Oleksandr Khalypa on 26.02.2023.
//

import UIKit
import SnapKit

class NetworkErrorView: UIView {
    
    var networkManager: NetworkManager
    
    private lazy var statusImage: UIImageView = {
        let obj = UIImageView()
        obj.contentMode = .scaleAspectFit
        obj.image = UIImage(systemName: networkManager.imageName)
        obj.tintColor = .white
        return obj
    }()
    
    private lazy var statusTitle: UILabel = {
        let obj = UILabel()
        obj.font = .systemFont(ofSize: 18, weight: .semibold)
        obj.text = networkManager.connectionDescription
        obj.textColor = .white
        obj.numberOfLines = 0
        obj.textAlignment = .center
        return obj
    }()
    
    private lazy var retryButton: UIButton = {
        let obj = UIButton(type: .system)
        obj.setTitle("Retry", for: .normal)
        obj.setTitleColor(.systemBlue, for: .normal)
        obj.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        obj.backgroundColor = .white
        obj.layer.cornerRadius = 20
        obj.addTarget(self, action: #selector(tapRetryButton), for: .touchUpInside)
        return obj
    }()
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapRetryButton() {
        if !networkManager.isShowAlert.value {
            self.isHidden = true
        }
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()
            if bounds.width > bounds.height {
                addLandscapeConstraint()
            } else {
                addPortraitConstraint()
            }
        }
    
   private func setupUI() {
        backgroundColor = .systemBlue
        self.addSubview(statusImage)
        self.addSubview(statusTitle)
        self.addSubview(retryButton)
       
       statusTitle.snp.remakeConstraints { make in
           make.center.equalToSuperview()
       }
    }
    
    private func addPortraitConstraint() {
        statusImage.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-250)
            make.size.equalTo(200)
        }

        retryButton.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(250)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
    }
    
    private func addLandscapeConstraint() {
        statusImage.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
            make.size.equalTo(180)
        }
        
        retryButton.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(100)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
    }
    
}

