//
//  FeedsViewModelProtocol.swift
//  TalkShop
//
//  Created by Samarth on 20/03/24.
//

import Foundation

protocol FeedsViewModelProtocol {
    
    /// Title shown on the Navigation bar
    var screenTitle: String { get }
    
    /// Array to store all the posts
    var posts: [Post] { get }
    
    /// Method to fetch the feeds from the backend
    func fetchPosts(completion: @escaping (Result<Void, Error>) -> Void)
    
}
