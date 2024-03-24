//
//  User.swift
//  TalkShop
//
//  Created by Samarth on 24/03/24.
//

import Foundation

class User {
    let username: String
    let profilePictureUrl: URL?
    
    init?(post: PostModel) {
        guard let userName = post.username, !userName.isEmpty else {
            return nil
        }
        self.username = userName
        self.profilePictureUrl = post.userProfilePicture
    }
    
    init?(profileModel: UserProfileModel) {
        guard let username = profileModel.username, !username.isEmpty else {
            return nil
        }
        self.username = username
        self.profilePictureUrl = profileModel.profilePictureUrl
    }
}
