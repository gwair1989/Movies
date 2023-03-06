//
//  PosterViewController.swift
//  movies
//
//  Created by Oleksandr Khalypa on 05.02.2023.
//

import UIKit
import SnapKit

class PosterViewController: UIViewController {
    
    var posterPath: String!
    private var imageDataTask: URLSessionDataTask?
    
    private static let cache = URLCache(
        memoryCapacity: 50 * 1024 * 1024,
        diskCapacity: 100 * 1024 * 1024,
        diskPath: "photo"
    )
    
    private var imageScrollView: PosterView!
    
    private let activityIndicator: UIActivityIndicatorView = {
        let obj = UIActivityIndicatorView()
        obj.isHidden = false
        obj.startAnimating()
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addSubview(activityIndicator)
        activityIndicator.isHidden = false
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let urlString = "https://image.tmdb.org/t/p/original"
        guard let url = URL(string: urlString + posterPath) else { return }
        
        downloadPhoto(url: url) { [weak self] image, error in
            guard let self, error == nil,
                  let image else { return }
            DispatchQueue.main.async {
                self.setupImageScrollView(image: image)
            }
        }
    }
    
    
    func setupImageScrollView(image: UIImage) {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        imageScrollView = PosterView(frame: view.bounds)
        view.addSubview(imageScrollView)
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.imageScrollView.set(image: image)
    }
    
    
    private func downloadPhoto(url: URL, completion: @escaping (UIImage?, Error?) -> Void) {
        if let cachedResponse = PosterViewController.cache.cachedResponse(for: URLRequest(url: url)),
           let image = UIImage(data: cachedResponse.data) {
            completion(image, nil)
            return
        }
        
        imageDataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            self?.imageDataTask = nil
            
            if let error = error {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            
            guard let data = data, let image = UIImage(data: data), error == nil else { return }
            DispatchQueue.main.async { completion(image, nil) }
        }
        
        imageDataTask?.resume()
        
    }
    
}
