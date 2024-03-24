//
//  ProfileViewModelProtocol.swift
//  TalkShop
//
//  Created by Samarth on 21/03/24.
//

import Foundation

protocol ProfileViewModelProtocol {
    var username: String { get }
    var profilePictureURL: URL? { get }
    var posts: [Post] { get }
    
    func fetchProfileData(completion: @escaping (Result<Void, Error>) -> Void)
}
