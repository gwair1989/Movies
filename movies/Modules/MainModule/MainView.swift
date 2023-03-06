//
//  MainView.swift
//  movies
//
//  Created by Oleksandr Khalypa on 31.01.2023.
//

import UIKit
import SnapKit

class MainView: UIView {
    let itemsPerRow: CGFloat = 1
    let sectionInserts = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
    
    var movies: [MainModel] = []

    var searchTerm: Dynamic<String?> = Dynamic(nil)
    var getNextMovies: (() -> Void)?
    var didClickCell: Dynamic<Int?> = Dynamic(nil)
    
    var isSort = false {
        didSet {
            if isSort {
                movies.sort { $0.rating < $1.rating }
            } else {
                movies.sort { $0.rating > $1.rating }
            }
            collectionView.reloadData()
        }
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
        let obj = UIActivityIndicatorView()
        obj.isHidden = false
        obj.startAnimating()
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        let obj = UICollectionView(frame: .zero,
                                   collectionViewLayout: layout)
        obj.contentInsetAdjustmentBehavior = .automatic
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.backgroundColor = .white
        obj.alpha = 0
        obj.allowsMultipleSelection = true
        obj.showsVerticalScrollIndicator = false
        return obj
    }()
    
    private let searchBar: UISearchBar = {
        let obj = UISearchBar()
        obj.backgroundImage = UIImage()
        obj.placeholder = "Пошук"
        obj.searchTextField.textColor = .black
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(newMovies: [MainModel]) {
        if self.movies.isEmpty {
            self.movies = newMovies
            collectionView.reloadData()
        } else {
            var indexPathes: [IndexPath] = []
            for (index, _) in newMovies.enumerated() {
                let indexPath = IndexPath(item: index + self.movies.count, section: 0)
                indexPathes.append(indexPath)
            }
            self.collectionView.performBatchUpdates {
                self.movies.append(contentsOf: newMovies)
                self.collectionView.insertItems(at: indexPathes)
            }
        }
    }
    
    func showCollectionView() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.collectionView.alpha = 1
        })
    }
    
    private func setupUI() {
        self.backgroundColor = .white
        addSubview(searchBar)
        searchBar.delegate = self
        addSubview(collectionView)
        addSubview(activityIndicator)
        collectionView.register(MainCell.self, forCellWithReuseIdentifier: MainCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        addConstraint()
    }
    
    private func addConstraint() {
        
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
        }
        
    }
}


