//
//  PlayViewController.swift
//  movies
//
//  Created by Oleksandr Khalypa on 06.03.2023.
//

import UIKit
import YouTubeiOSPlayerHelper

class PlayViewController: UIViewController, YTPlayerViewDelegate {
    
    private let id: String
    private let mainView = YTPlayerView()
    
    override func loadView() {
        view = mainView
    }
    
    init(id: String) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        mainView.load(withVideoId: id)
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
}
