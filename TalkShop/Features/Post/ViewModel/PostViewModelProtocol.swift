//
//  PostViewModelProtocol.swift
//  TalkShop
//
//  Created by Samarth on 22/03/24.
//

import Foundation

protocol PostViewModelProtocol {
    var post: Post? { get }
    
    func fetchPostDetails(completion: @escaping (Result<Void, Error>) -> Void)
}
