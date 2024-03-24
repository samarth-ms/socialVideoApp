//
//  PostViewController.swift
//  TalkShop
//
//  Created by Samarth on 22/03/24.
//

import UIKit
import SDWebImage

class PostViewController: UIViewController {
    
    @IBOutlet var singleTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var doubleTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var tripleTapGestureRecognizer: UITapGestureRecognizer!

    @IBOutlet weak var videoPlayer: VideoPlayerView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeAnimationImageView: UIImageView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    let viewModel: PostViewModelProtocol
    
    // MARK: - Lifecycle

    init(viewModel: PostViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: "PostViewController", bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupPostData(post: viewModel.post)
        fetchData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videoPlayer.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        videoPlayer.pause()
    }

    // MARK: - Data Helpers
    
    func fetchData() {
        viewModel.fetchPostDetails { [weak self] result in
            guard let self else { return }
            
            switch result {
                case .success(_):
                    setupPostData(post: viewModel.post)
                    
                case .failure(let error):
                    print(error)
                    let errorAlert = UIAlertController(title: "Something went wrong", message: "Something seems broken on our end.\nPlease try again later.", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "Okay", style: .cancel))
                    self.present(errorAlert, animated: true)
                    clearPostData()
            }
        }
    }

    // MARK: - View Helpers
    
    func setupViews() {
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.width / 2.0
        userProfileImageView.clipsToBounds = true
        addShadow(toView: userProfileImageView)
        addShadow(toView: userNameLabel)
        addShadow(toView: likeButton)
        addShadow(toView: likeCountLabel)
    }
    
    private func addShadow(toView view: UIView) {
        view.layer.shadowRadius = 8.0
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.7
    }
    
    func clearPostData() {
        userProfileImageView.image = UIImage(named: "videoPlaceholder")
        userNameLabel.text = nil
        videoPlayer.video = nil
    }
    
    func setupPostData(post: Post?) {
        guard let post else {
            clearPostData()
            return
        }
        
        userProfileImageView.sd_setImage(with: post.user.profilePictureUrl, placeholderImage: UIImage(systemName: "person.crop.circle"))
        userNameLabel.text = post.user.username
        videoPlayer.video = post.video
        likeCountLabel.text = post.likes > 0 ? "\(post.likes)" : nil
    }
    
    // MARK: - User actions
    
    @IBAction func likeAction(_ sender: Any) {
        likePost()
    }
    
    @IBAction func userProfileAction(_ sender: Any) {
        guard let user = viewModel.post?.user else { return }
        let profileVC = ProfileViewController(viewModel: ProfileViewModel(user: user))
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @IBAction func singleTapGestureAction(_ sender: Any) {
        videoPlayer.isMuted = !videoPlayer.isMuted
    }
    
    @IBAction func doubleTapGestureAction(_ sender: Any) {
        likePost()
    }
    
    @IBAction func tripleTapGestureAction(_ sender: Any) {
        // Resize video
        videoPlayer.videoGravity = videoPlayer.videoGravity == .resizeAspectFill ? .resizeAspect : .resizeAspectFill
    }
    
    func likePost() {
        // Make an API call to like a post
        
        // ...and also show an animation
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.5, options: .curveEaseOut) {
            self.likeAnimationImageView.alpha = 1
            self.likeAnimationImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            
        } completion: { _ in
            UIView.animate(withDuration: 0.8, delay: 0.8, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.5) {
                self.likeAnimationImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.likeAnimationImageView.center = self.likeButton.center
            } completion: { _ in
                self.likeAnimationImageView.alpha = 0.0
                self.likeAnimationImageView.center = self.videoPlayer.center
            }
        }
    }
}
