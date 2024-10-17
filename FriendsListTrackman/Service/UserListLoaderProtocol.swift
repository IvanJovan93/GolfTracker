//
//  UserListLoader.swift
//  FriendsListTrackman
//
//  Created by Ivan Jovanovik on 16.10.24.
//

import Foundation

public enum LoadUserListResult {
    case success([UserProfile])
    case failure(Error)
}

public protocol UserListLoaderProtocol {
    func loadUserList(completion: @escaping (LoadUserListResult) -> Void)
}
