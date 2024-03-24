//
//  HomeTabBarViewController.swift
//  TalkShop
//
//  Created by Samarth on 20/03/24.
//

import UIKit

class HomeTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        loadTabs()
    }
    
    func loadTabs() {
        let feedsVC = FeedsViewController(viewModel: FeedsViewModel())
        let feedsTab: UINavigationController = UINavigationController.init(rootViewController: feedsVC)
        feedsTab.tabBarItem = UITabBarItem(title: "Feeds", image: UIImage(systemName: "quote.bubble"), selectedImage: UIImage(systemName: "quote.bubble.fill"))
        
        let profileVC = ProfileViewController(viewModel: ProfileViewModel(userName: currentUserName))
        let profielTab: UINavigationController = UINavigationController.init(rootViewController: profileVC)
        profielTab.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), selectedImage: UIImage(systemName: "person.crop.circle.fill"))
        
        self.viewControllers = [feedsTab, profielTab]
    }
    
}
