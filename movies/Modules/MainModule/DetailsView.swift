//
//  DetailsView.swift
//  movies
//
//  Created by Oleksandr Khalypa on 01.02.2023.
//

import UIKit
import SnapKit
import SDWebImage

class DetailsView: UIView {
    
    var detail: DetailModel! {
        didSet {
            let urlString = "https://image.tmdb.org/t/p/w500"
            guard let urlBack = URL(string: urlString + detail.backdropPath),
                  let urlPoster = URL(string: urlString + detail.posterPath)
            else { return }
            
            backgroundImage.sd_setImage(with: urlBack)
            posterImage.sd_setImage(with: urlPoster)
            
            nameLabel.text = detail.title
            dateLabel.text = detail.releaseDate
            ratingLabel.text = detail.voteAverage
            overviewlabel.text = detail.overview
            countryLabel.text = detail.countries
            genresLabel.text = detail.genres
            
            trailerButton.isHidden = detail.youtubeID.isEmpty
        }
    }
    
    var didClickButtonTrailer: Dynamic<String?> = Dynamic(nil)
    var didClickPoster: Dynamic<String?> = Dynamic(nil)
    
    private let topView: UIView = {
        let obj = UIView()
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
    
    private let bottomView: UIView = {
        let obj = UIView()
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    private let nameLabel: UILabel = {
        let obj = UILabel()
        obj.textColor = .black
        obj.font = .systemFont(ofSize: 18, weight: .bold)
        obj.numberOfLines = 0
        obj.sizeToFit()
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    private let dateLabel: UILabel = {
        let obj = UILabel()
        obj.textColor = .black
        obj.font = .systemFont(ofSize: 15, weight: .semibold)
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    private lazy var trailerButton: UIButton = {
        let obj = UIButton()
        obj.setImage(UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        obj.isHidden = true
        obj.addTarget(self, action: #selector(tapTrailerButton), for: .touchUpInside)
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    private lazy var posterButton: UIButton = {
        let obj = UIButton()
        obj.addTarget(self, action: #selector(tapPosterButton), for: .touchUpInside)
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    private let ratingLabel: UILabel = {
        let obj = UILabel()
        obj.textColor = .black
        obj.font = .systemFont(ofSize: 15, weight: .semibold)
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    private let countryLabel: UILabel = {
        let obj = UILabel()
        obj.textColor = .black
        obj.font = .systemFont(ofSize: 15, weight: .semibold)
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    private let genresLabel: UILabel = {
        let obj = UILabel()
        obj.textColor = .black
        obj.font = .systemFont(ofSize: 15, weight: .semibold)
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    private let overviewlabel: UILabel = {
        let obj = UILabel()
        obj.textColor = .black
        obj.numberOfLines = 0
        obj.sizeToFit()
        obj.font = .systemFont(ofSize: 15, weight: .semibold)
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
    
    @objc private func tapTrailerButton() {
        didClickButtonTrailer.value = detail.youtubeID
    }
    
    @objc private func tapPosterButton() {
        didClickPoster.value = detail.posterPath
    }
    
    private func setupUI() {
        self.backgroundColor = .white
        addSubview(topView)
        topView.addSubview(backgroundImage)
        topView.addSubview(posterImage)
        topView.addSubview(posterButton)
        
        addSubview(bottomView)
        bottomView.addSubview(nameLabel)
        bottomView.addSubview(trailerButton)
        bottomView.addSubview(dateLabel)
        bottomView.addSubview(countryLabel)
        bottomView.addSubview(genresLabel)
        bottomView.addSubview(ratingLabel)
        bottomView.addSubview(overviewlabel)
        
        addConstraint()
    }
    
    private func addConstraint() {
        
        topView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(8)
            make.height.equalTo(topView.snp.width)
        }
        
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        posterImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
            make.width.equalTo(posterImage.snp.height).dividedBy(1.5)
        }
        
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
        
        countryLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
        
        genresLabel.snp.makeConstraints { make in
            make.top.equalTo(countryLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(genresLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.height.equalTo(20)
        }
        
        trailerButton.snp.makeConstraints { make in
            make.centerY.equalTo(ratingLabel.snp.centerY)
            make.trailing.equalToSuperview()
            make.size.equalTo(30)
        }
        
        posterButton.snp.makeConstraints { make in
            make.center.equalTo(posterImage.snp.center)
            make.size.equalTo(posterImage.snp.size)
        }
        
        overviewlabel.snp.makeConstraints { make in
            make.top.equalTo(trailerButton.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        
    }
    
}

