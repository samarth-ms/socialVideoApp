//
//  Constants.swift
//  TalkShop
//
//  Created by Samarth on 21/03/24.
//

import Foundation

let currentUserName: String = "Me"

// MARK : Network constants

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    // Add more methods as needed
}

struct URLs {
    static let baseUrl: String  = "https://63a661d1-a056-4df9-92e5-b78981db94f5.mock.pstmn.io"
    static let feedsUrl: String = Self.baseUrl + "/api/feeds"
    static let postUrl: String  = Self.baseUrl + "/api/post"
    static let profileUrl: String  = Self.baseUrl + "/api/profile"
}
