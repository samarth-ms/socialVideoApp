//
//  Post.swift
//  TalkShop
//
//  Created by Samarth on 21/03/24.
//

import Foundation

class Post {
    let postId: String
    let video: Video
    let user: User
    let likes: Int
    
    init?(postModel: PostModel) {
        guard let postId = postModel.postId,
              let video = Video(postModel: postModel),
              let user = User(post: postModel) else {
            return nil
        }
        
        self.postId = postId
        self.video = video
        self.user = user
        self.likes = postModel.likes ?? 0
    }
}
