//
//  DetailsViewController.swift
//  movies
//
//  Created by Oleksandr Khalypa on 01.02.2023.
//

import UIKit

class DetailsViewController: UIViewController {
    
    private var viewModel: DetailsViewModelProtocol!
    private let mainView = DetailsView()
    
    init(id: Int, viewModel: DetailsViewModelProtocol = DetailsViewModel()) {
        self.viewModel = viewModel
        self.viewModel.filter.id = id
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    private func setupNavBar() {
        if #unavailable(iOS 16) {
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.shadowImage = UIImage()
        }
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.backItem?.title = ""
    }
    
    private func bind() {
        viewModel.model.bind { [weak self] data in
            guard let self, let data else { return }
            self.navigationItem.title = data.title
            self.mainView.detail = data
        }
        
        mainView.didClickButtonTrailer.bind { [weak self] id in
            guard let self, let id else { return }
            let vc = PlayViewController(id: id)
            self.present(vc, animated: true)
        }
        
        mainView.didClickPoster.bind { [weak self] posterPath in
            guard let self, let posterPath else { return }
            let vc = PosterViewController()
            vc.posterPath = posterPath
            self.present(vc, animated: true)
        }
        
    }
    

}
