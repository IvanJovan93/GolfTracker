//
//  ListPlayerMapper.swift
//  FriendsListTrackman
//
//  Created by Ivan Jovanovik on 16.10.24.
//

import Foundation

internal final class UsersMapper {
    private struct Root: Decodable {
        let items: [Item]
        var feed: [UserProfile] {
            items.map { $0.item }
        }
        enum CodingKeys: String, CodingKey {
            case items = "friends"
        }
    }
    
    private struct Item: Decodable {
        let firstName: String
        let lastName: String
        let nickName: String
        let dateOfBirth: String
        let profilePictureUrl: String
        let isFriend: Bool
        let majorsWon: Int
        var item: UserProfile {
            var id: Int {
                var hasher = Hasher()
                hasher.combine(firstName)
                hasher.combine(lastName)
                hasher.combine(nickName)
                hasher.combine(dateOfBirth)
                hasher.combine(majorsWon)
                return hasher.finalize()
            }
            var fullName: String {"\(firstName) \(lastName)"}
            var profilePictureURL: URL? {
                URL(string: profilePictureUrl)
            }
            return UserProfile(
                id: id,
                firstName: firstName,
                lastName: lastName,
                nickName: nickName,
                dateOfBirth: dateOfBirth,
                profilePictureUrl: profilePictureURL,
                isFriend: isFriend,
                majorsWon: majorsWon,
                fullName: fullName
            )
        }
    }
    private static var okCode: Int { return 200 }
    internal static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteUserLoaderService.Result {
        guard response.statusCode == okCode,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(RemoteUserLoaderService.Error.invalidData)
        }
        return .success(root.feed)
    }
}
