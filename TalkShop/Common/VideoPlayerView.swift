//
//  VideoPlayerView.swift
//  TalkShop
//
//  Created by Samarth on 22/03/24.
//

import UIKit
import AVFoundation
import SDWebImage

class VideoPlayerView: UIView {
    // MARK: Private properties
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var thumbnailImageView: UIImageView!
    
    // MARK: - Public properties
    
    var video: Video? {
        didSet {
            self.videoURL = video?.videoUrl
        }
    }
    
    private var videoURL: URL? {
        didSet {
            guard oldValue != videoURL else { return }
            setupPlayer()
        }
    }
    
    var isMuted: Bool {
        get {
            return player?.isMuted ?? false
        }
        set {
            player?.isMuted = newValue
        }
    }
    
    var videoGravity: AVLayerVideoGravity {
        get {
            return playerLayer?.videoGravity ?? .resizeAspectFill
        }
        set {
            playerLayer?.videoGravity = newValue
        }
    }
    
    var loopVideo: Bool = true
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupViews()
        observeNotifications()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
        setupViews()
        observeNotifications()
    }
    
    override func layoutSubviews() {
        playerLayer?.frame = bounds
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Helpers
    
    func setupViews() {
        thumbnailImageView = UIImageView()
        thumbnailImageView.contentMode = .scaleAspectFill
        
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(thumbnailImageView)
        
        // Add constraints
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            thumbnailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            thumbnailImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            thumbnailImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }
    
    private func observeNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReachEndOfVideo), name: AVPlayerItem.didPlayToEndTimeNotification, object: nil)
    }
    
    // MARK: - Controls
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.pause()
        player?.seek(to: .zero)
    }
    
    // MARK: - Player Helpers
    
    private func setupPlayer() {
        self.backgroundColor = .clear
        guard let videoURL = videoURL else {
            stop()
            thumbnailImageView.image = nil
            return
        }
        
        thumbnailImageView.sd_setImage(with: video?.thumbnailUrl, placeholderImage: UIImage(named: "videoPlaceholder"))
        
        if let player = player {
            // If a video is already playing
            player.replaceCurrentItem(with: AVPlayerItem(url: videoURL))
            
        } else {
            // Player does not exist
            player = AVPlayer(url: videoURL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bounds
            playerLayer?.videoGravity = .resizeAspectFill
            layer.addSublayer(playerLayer!)
        }
    }
    
    @objc func didReachEndOfVideo() {
        if loopVideo, let player = player, player.rate == 0 { // Will restart a paused video. Needs to be handled right
            player.seek(to: .zero)
            play()
        }
    }
    
}
