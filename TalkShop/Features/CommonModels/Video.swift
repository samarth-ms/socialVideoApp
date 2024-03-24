//
//  Video.swift
//  TalkShop
//
//  Created by Samarth on 21/03/24.
//

import Foundation

class Video {
    let videoUrl: URL
    let thumbnailUrl: URL?
    
    init?(postModel: PostModel) {
        guard let videoUrl = postModel.videoUrl else {
            return nil
        }
        
        self.videoUrl = videoUrl
        self.thumbnailUrl = postModel.thumbnailUrl
    }
}
