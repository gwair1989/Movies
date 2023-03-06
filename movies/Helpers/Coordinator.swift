//
//  Coordinator.swift
//  movies
//
//  Created by Oleksandr Khalypa on 26.02.2023.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    
    func start()
    func toMainVC()
    func toDetailVC(id: Int)
}
