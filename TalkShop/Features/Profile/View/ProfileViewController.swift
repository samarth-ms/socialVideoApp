//
//  ProfileViewController.swift
//  TalkShop
//
//  Created by Samarth on 21/03/24.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var postsCollectionView: UICollectionView!
    @IBOutlet weak var postCollectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let viewModel: ProfileViewModelProtocol
    
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: "ProfileViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setProfileData()
        setupCollectionView()
        fetchProfileDetails()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        // Setting the collection views item size
        let width = (self.view.frame.width - 2) / 3
        let height = width * 5 / 3
        postCollectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    func setupViews() {
        navigationController?.navigationBar.prefersLargeTitles = true
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.width / 2.0
        profilePictureImageView.clipsToBounds = true
    }
    
    func fetchProfileDetails() {
        activityIndicator.startAnimating()
        viewModel.fetchProfileData { [weak self] result in
            guard let self else { return }
            activityIndicator.stopAnimating()
            
            switch result {
                case .success(_):
                    setProfileData()
                    
                case .failure(let error):
                    print(error)
                    let errorAlert = UIAlertController(title: "Something went wrong", message: "Something seems broken on our end.\nPlease try again later.", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "Okay", style: .cancel))
                    self.present(errorAlert, animated: true)
            }
        }
    }

    func setProfileData() {
        self.title = viewModel.username
        profilePictureImageView.sd_setImage(with: viewModel.profilePictureURL, placeholderImage: UIImage(systemName: "person.crop.circle.fill"))
        postsCollectionView.reloadData()
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func setupCollectionView() {
        postsCollectionView.registerNib(cellType: PostCollectionViewCell.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.defaultReuseIdentifier, for: indexPath) as! PostCollectionViewCell
        
        postCell.setData(post: viewModel.posts[indexPath.item])
        
        return postCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = viewModel.posts[indexPath.item]
        let postVC = PostViewController(viewModel: PostViewModel(post: post))
        self.navigationController?.pushViewController(postVC, animated: true)
    }
}
