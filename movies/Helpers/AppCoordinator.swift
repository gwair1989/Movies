//
//  AppCoordinator.swift
//  movies
//
//  Created by Oleksandr Khalypa on 26.02.2023.
//

import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    func start() {
        let vc = PreloaderViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func toMainVC() {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
            return
        }
        let mainVC = MainViewController()
        mainVC.coordinator = self
        let navVC = UINavigationController(rootViewController: mainVC)
        self.navigationController = navVC
        window.rootViewController = navVC
        UIView.transition(with: window, duration: 0.5, options: .curveEaseInOut, animations: {
            window.makeKeyAndVisible()
        })
    }
    
    func toDetailVC(id: Int) {
        let detailVC = DetailsViewController(id: id)
        self.navigationController.pushViewController(detailVC, animated: true)
    }

}

