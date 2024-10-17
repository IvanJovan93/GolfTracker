//
//  UserProfile.swift
//  FriendsListTrackman
//
//  Created by Ivan Jovanovik on 15.10.24.
//

import SwiftUI

public struct UserProfile: Identifiable, Decodable {
    public var id: Int
    let firstName: String
    let lastName: String
    let nickName: String
    let dateOfBirth: String
    let profilePictureUrl: URL?
    var profileImageData: Data?
    let isFriend: Bool
    let majorsWon: Int
    
    var fullName: String
}
