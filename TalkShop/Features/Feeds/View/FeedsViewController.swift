//
//  FeedsViewController.swift
//  TalkShop
//
//  Created by Samarth on 21/03/24.
//

import UIKit

class FeedsViewController: UIViewController {
    
    @IBOutlet weak var feedsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var refreshControl = UIRefreshControl()

    let viewModel: FeedsViewModelProtocol
    
    // MARK: - Lifecycle
    
    init(viewModel: FeedsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: "FeedsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupViews()
        fetchPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playAllVisibleVideos()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        pauseAllVisibleVideos()
    }
    
    // MARK: - Helpers
    
    func setupViews() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = viewModel.screenTitle
        refreshControl.addTarget(self, action: #selector(refreshFeeds), for: .valueChanged)
        feedsTableView.addSubview(refreshControl)

    }
    
    func fetchPosts() {
        if viewModel.posts.isEmpty {
            activityIndicator.startAnimating()
        }
        viewModel.fetchPosts { [weak self] result in
            guard let self else { return }
            // Added a delay to view the pull to refresh UI
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.activityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
                switch result {
                    case .success(_):
                        
                        self.feedsTableView.reloadData()
                        
                    case .failure(let error):
                        print(error)
                        let errorAlert = UIAlertController(title: "Something went wrong", message: "Something seems broken on our end.\nPlease try again later.", preferredStyle: .alert)
                        errorAlert.addAction(UIAlertAction(title: "Okay", style: .cancel))
                        self.present(errorAlert, animated: true)
                }
//            }
        }
    }
    
    @objc private func refreshFeeds() {
        fetchPosts()
        feedsTableView.reloadData()
    }

    // MARK: - Video Helpers
    
    func playAllVisibleVideos() {
        for index in feedsTableView.indexPathsForVisibleRows ?? [] {
            if let postCell = feedsTableView.cellForRow(at: index) as? PostTableViewCell {
                postCell.playVideo()
            }
        }
    }
    
    func pauseAllVisibleVideos() {
        for index in feedsTableView.indexPathsForVisibleRows ?? [] {
            if let postCell = feedsTableView.cellForRow(at: index) as? PostTableViewCell {
                postCell.pauseVideo()
            }
        }
    }
    
}

extension FeedsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func setupTableView() {
        feedsTableView.registerNib(cellType: PostTableViewCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.defaultReuseIdentifier, for: indexPath) as! PostTableViewCell
        
        // Configure the cell with post data
        cell.setData(post: viewModel.posts[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = viewModel.posts[indexPath.row]
        let postVC = PostViewController(viewModel: PostViewModel(post: post))
        self.navigationController?.pushViewController(postVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let postCell = cell as? PostTableViewCell {
            postCell.didEndDisplayingCell()
        }
    }
}
