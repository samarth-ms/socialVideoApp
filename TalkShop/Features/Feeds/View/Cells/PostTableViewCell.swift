//
//  PostTableViewCell.swift
//  TalkShop
//
//  Created by Samarth on 22/03/24.
//

import UIKit

class PostTableViewCell: UITableViewCell, HighlightFeedback {

    @IBOutlet weak var mediaContainerView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var videoPlayer: VideoPlayerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    private func setupViews() {
        mediaContainerView.layer.cornerRadius = 16
        mediaContainerView.layer.masksToBounds = true
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        scaleDownFeedback(highlighted: highlighted, animated: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func didEndDisplayingCell() {
        pauseVideo()
    }
    
    // MARK: - Helpers
    
    func setData(post: Post) {
        userNameLabel.text = post.user.username
        setLikes(likes: post.likes)
        setupVideo(video: post.video)
        playVideo()
    }
    
    private func setLikes(likes: Int) {
        if likes > 0 {
            likeButton.setTitle("\(likes)", for: .normal)
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.setTitle(nil, for: .normal)
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    // MARK: - Video player
    
    func setupVideo(video: Video) {
        videoPlayer.video = video
    }
    
    func playVideo() {
        videoPlayer.play()
    }
    
    func pauseVideo() {
        videoPlayer.pause()
    }
}
