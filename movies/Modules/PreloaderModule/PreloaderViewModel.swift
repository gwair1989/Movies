//
//  PreloaderViewModel.swift
//  movies
//
//  Created by Oleksandr Khalypa on 01.03.2023.
//

import Foundation
import AdSupport
import AppTrackingTransparency
import UIKit

final class PreloaderViewModel {
    private let dataService: DataServiseProtocol
    private var model: Dynamic<PreloaderModel?> = Dynamic(nil)
    var urlSting: Dynamic<String?> = Dynamic(nil)
    var isOpenWebView: Dynamic<Bool?> = Dynamic(nil)

    init(dataService: DataServiseProtocol = DataFetcherService()) {
        self.dataService = dataService
        bind()
        getParams()
    }
    
    private func bind() {
        model.bind { [weak self] preloaderModel in
            guard let self else { return }
            guard let model = preloaderModel,
                  model.statusCode > 1,
                  let modelConnection = model.connection,
                  let connection = self.decodingBase64(base64: modelConnection)
            else {
                self.isOpenWebView.value = false
                return }
            self.verifyURL(urlPath: connection) { statusCode in
                if statusCode == 301 || statusCode == 302 {
                    self.urlSting.value = connection
                    self.isOpenWebView.value = true
                } else {
                    self.isOpenWebView.value = false
                    return
                }
            }
            
            if let _ = model.statusMessage {
                self.isOpenWebView.value = false
            }
        }
        
    }
    
    private func verifyURL(urlPath: String, completion: @escaping (_ statusCode: Int?) ->()) {
        if let url = URL(string: urlPath) {
            var request = URLRequest(url: url)
            request.httpMethod = "HEAD"
            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                if let httpResponse = (response as? HTTPURLResponse) {
                    completion(httpResponse.statusCode)
                } else {
                    completion(nil)
                }
            }
            task.resume()
        } else {
            completion(nil)
        }
    }
    
    private func encodingDiplink() -> String? {
        let diplink = "hqmovies://"
        if let plainData = diplink.data(using: .utf8) {
            return plainData.base64EncodedString()
        }
        return nil
    }
    
    private func decodingBase64(base64: String) -> String? {
        if let decodedData = Data(base64Encoded: base64) {
            let decodedString = String(data: decodedData, encoding: .utf8)
            return decodedString
        } else {
            return nil
        }
    }
    
    
    func getParams() {
        let encodedDiplink = encodingDiplink()
        let campaign = UserDefaultsManager.shared[.campaign]
        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        let idfv = UIDevice.current.identifierForVendor?.uuidString
        
        let filter = Filter(typeRequest: .preloader,
                            preloader: PreloaderParameters(encodedDiplink: encodedDiplink,
                                                           campaign: campaign,
                                                           idfa: idfa,
                                                           idfv: idfv))
        
        fetchData(filter: filter)
    }
    
    private func fetchData(filter: Filter) {
        dataService.fetchPreloader(filter: filter) { [weak self] data in
            guard let self, let data else { return }
            self.model.value = data
        }
    }
    
    
    
}
