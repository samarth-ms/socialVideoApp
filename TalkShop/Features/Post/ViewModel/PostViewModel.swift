//
//  PostViewModel.swift
//  TalkShop
//
//  Created by Samarth on 22/03/24.
//

import Foundation

class PostViewModel: PostViewModelProtocol {
    var post: Post?
    
    init(post: Post) {
        self.post = post
    }
    
    func fetchPostDetails(completion: @escaping (Result<Void, Error>) -> Void) {
        guard var feedsUrl = URL(string: URLs.postUrl) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        if let postId = post?.postId {
            // Adding a post id to the path for testing purpose
            feedsUrl.append(path: postId, directoryHint: .inferFromPath)
        }
        
        NetworkManager.shared.fetchData(from: feedsUrl, method: .get) { [weak self] (result: Result<PostResponse, NetworkError>) in
            guard let self else { return }
            switch result {
                case .success(let postData):
                    post = Post(postModel: postData.data)
                    completion(.success(()))
                    
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}

struct PostResponse: Decodable {
    let data: PostModel
}
