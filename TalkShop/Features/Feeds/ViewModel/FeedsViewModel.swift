//
//  FeedsViewModel.swift
//  TalkShop
//
//  Created by Samarth on 20/03/24.
//

import Foundation

class FeedsViewModel: FeedsViewModelProtocol {
    
    // MARK: Properties
    
    var screenTitle: String = "Feeds"

    var posts: [Post] = []
    
    
    // MARK: Methods
    
    func fetchPosts(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let feedsUrl = URL(string: URLs.feedsUrl) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
                
        NetworkManager.shared.fetchData(from: feedsUrl, method: .get) { [weak self] (result: Result<FeedsResponse, NetworkError>) in
            guard let self else { return }
            switch result {
                case .success(let feedsData):
                    // Map Post model to Post objects
                    posts = feedsData.data.compactMap({ Post(postModel: $0) })
                    completion(.success(()))
                    
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}

struct FeedsResponse: Decodable {
    let data: [PostModel]
}
