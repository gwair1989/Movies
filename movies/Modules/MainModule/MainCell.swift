//
//  MainCell.swift
//  movies
//
//  Created by Oleksandr Khalypa on 31.01.2023.
//

import UIKit
import SnapKit
import SDWebImage

class MainCell: UICollectionViewCell {
    
    static let identifier = "MainCell"
    
    var callback: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let obj = UILabel()
        obj.font = .systemFont(ofSize: 16, weight: .bold)
        obj.textColor = .black
        obj.numberOfLines = 2
        obj.lineBreakMode = .byWordWrapping
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    private let yearLabel: UILabel = {
        let obj = UILabel()
        obj.font = .systemFont(ofSize: 13, weight: .bold)
        obj.textColor = .black
        obj.numberOfLines = 4
        obj.lineBreakMode = .byWordWrapping
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    private let backgroundImage: UIImageView = {
        let obj = UIImageView()
        obj.clipsToBounds = true
        obj.backgroundColor = .lightGray
        obj.contentMode = .scaleAspectFill
        obj.layer.cornerRadius = 10
        obj.applyBlurEffect()
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    private let posterImage: UIImageView = {
        let obj = UIImageView()
        obj.clipsToBounds = true
        obj.backgroundColor = .clear
        obj.contentMode = .scaleAspectFill
        obj.layer.cornerRadius = 10
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    private let ratingLabel: UILabel = {
        let obj = UILabel()
        obj.font = .systemFont(ofSize: 12, weight: .semibold)
        obj.textColor = .black
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    private let genresLabel: UILabel = {
        let obj = UILabel()
        obj.font = .systemFont(ofSize: 12, weight: .semibold)
        obj.textColor = .black
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    
    var movie: MainModel! {
        didSet {
            let urlString = "https://image.tmdb.org/t/p/w500"
            guard let urlBack = URL(string: urlString + movie.backdropPath),
                  let urlPoster = URL(string: urlString + movie.posterPath)
            else { return }

            backgroundImage.sd_setImage(with: urlBack) { [weak self]_,_,_,_ in
                guard let self else { return }
                self.posterImage.sd_setImage(with: urlPoster) { _,_,_,_ in
                    self.callback?()
                }
            }
            
            titleLabel.text = movie.title
            genresLabel.text = movie.genres
            ratingLabel.text = movie.rating
            yearLabel.text = movie.year
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundImage.image = nil
        posterImage.image = nil
    }
    
    private func setupUI() {
        contentView.addSubview(backgroundImage)
        contentView.addSubview(posterImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(yearLabel)
        contentView.addSubview(genresLabel)
        contentView.addSubview(ratingLabel)
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        addShadow()
        addConstraints()
    }
    
    private func addShadow() {
        layer.borderWidth = 0.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 1
        layer.masksToBounds = false
    }
    
    
    private func addConstraints() {
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        posterImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
            make.width.equalTo(posterImage.snp.height).dividedBy(1.5)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
        }
        
        genresLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalToSuperview().offset(20)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        
    }
    
}

