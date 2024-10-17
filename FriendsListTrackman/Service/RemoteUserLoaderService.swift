//
//  RemoteCacheLoader.swift
//  FriendsListTrackman
//
//  Created by Ivan Jovanovik on 16.10.24.
//

import Foundation

public final class RemoteUserLoaderService: UserListLoaderProtocol {
    @Service var client: HTTPClientProtocol?
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    public typealias Result = LoadUserListResult
    
    public init(url: URL = APIEndpoints.friendsList) {
        self.url = url
    }
    
    public func loadUserList(completion: @escaping (Result) -> Void) {
        client?.get(from: url) { [weak self] result in
            guard self != nil else { return }
            DispatchQueue.main.async {
                switch result {
                case let .success((data, response)):
                    completion(UsersMapper.map(data, from: response))
                case .failure:
                    completion(.failure(Error.connectivity))
                }
            }

        }
    }
}
