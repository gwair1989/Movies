//
//  NetworkManager.swift
//  movies
//
//  Created by Oleksandr Khalypa on 26.02.2023.
//

import Foundation
import Network

class NetworkManager {
    static let shared = NetworkManager()
    
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkManager")
    
    private(set) var isShowAlert: Dynamic<Bool> = Dynamic(false)
    
    var imageName: String {
        return isShowAlert.value ? "wifi.slash" : "wifi"
    }
    
    var connectionDescription: String {
        if isShowAlert.value {
            return "Please check your internet connection!"
        } else {
            return "Internet connection looks good!"
        }
    }
    
   private init() {
       monitor = NWPathMonitor()
        getNetworkStatus()
    }
    
    func getNetworkStatus() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            print("Network Status: ", path.status)
            switch path.status {
            case .satisfied:
                DispatchQueue.main.async {
                    self.isShowAlert.value = false
                }
            case .unsatisfied:
                DispatchQueue.main.async {
                    self.isShowAlert.value = true
                }
            case .requiresConnection:
                DispatchQueue.main.async {
                    self.isShowAlert.value = true
                }
            @unknown default:
                print("Network Status default: ", path.status)
            }
            
        }
        monitor.start(queue: queue)
    }
}

