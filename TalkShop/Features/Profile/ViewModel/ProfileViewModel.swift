//
//  ProfileViewModel.swift
//  TalkShop
//
//  Created by Samarth on 21/03/24.
//

import Foundation

class ProfileViewModel: ProfileViewModelProtocol {
    
    private var internalUsername: String
    private var user: User?
    
    var posts: [Post] = []
    
    var username: String {
        return internalUsername == currentUserName ? "My Account" : internalUsername
    }
    
    var profilePictureURL: URL? {
        return user?.profilePictureUrl
    }
    
    init(user: User) {
        self.user = user
        self.internalUsername = user.username
    }
    
    init(userName: String) {
        self.internalUsername = userName
    }
    
    
    func fetchProfileData(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let profileUrl = URL(string: URLs.profileUrl + "/" + internalUsername) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        NetworkManager.shared.fetchData(from: profileUrl, method: .get) { [weak self] (result: Result<ProfileResponse, NetworkError>) in
            guard let self else { return }
            switch result {
                case .success(let profileData):
                    user = User(profileModel: profileData.data)
                    posts = profileData.data.posts?.compactMap({ Post(postModel: $0) }) ?? []
                    completion(.success(()))
                    
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}

struct ProfileResponse: Decodable {
    let data: UserProfileModel
}
