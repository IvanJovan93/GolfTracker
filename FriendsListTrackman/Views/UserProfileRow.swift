//
//  UserProfileRow.swift
//  FriendsListTrackman
//
//  Created by Ivan Jovanovik on 15.10.24.
//

import SwiftUI
struct UserProfileRow: View {
    let userProfile: UserProfile
    
    var body: some View {
        HStack {
            CachedAsyncImageView(url: userProfile.profilePictureUrl, isThumbnail: true)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(userProfile.fullName)
                    .font(.headline)
                    .foregroundStyle(Color("CellMainTextColor"))
                Text(userProfile.nickName)
                    .font(.subheadline)
                    .foregroundStyle(Color("SectionTextColor"))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}
