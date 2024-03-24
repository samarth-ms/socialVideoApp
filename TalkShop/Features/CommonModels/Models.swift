//
//  Models.swift
//  TalkShop
//
//  Created by Samarth on 20/03/24.
//

import Foundation

// Model for a post containing a video
struct PostModel: Decodable {
    let postId: String?
    let videoUrl: URL?
    let thumbnailUrl: URL?
    let userProfilePicture: URL?
    let username: String?
    let likes: Int?
    
    enum CodingKeys: String, CodingKey {
        case postId
        case videoUrl
        case thumbnailUrl = "thumbnail_url"
        case userProfilePicture
        case username
        case likes
    }
}

// Model for a user profile
struct UserProfileModel: Decodable {
    let username: String?
    let profilePictureUrl: URL?
    let posts: [PostModel]?
}
