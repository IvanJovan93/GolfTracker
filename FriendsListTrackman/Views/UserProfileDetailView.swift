//
//  UserProfileDetailView.swift
//  FriendsListTrackman
//
//  Created by Ivan Jovanovik on 15.10.24.
//

import SwiftUI

struct UserProfileDetailView: View {
    let userProfile: UserProfile
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ZStack {
            Image("Profile background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                CachedAsyncImageView(url: userProfile.profilePictureUrl, isThumbnail: false)
                    .frame(width: 180, height: 180)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                    .padding(.top, 40)

                Text(userProfile.fullName)
                    .font(.title2)
                    .bold()

                Text("\(calculateAge(from: userProfile.dateOfBirth)) yrs")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("""
                You can play recorded Virtual Golf rounds 
                with \(userProfile.firstName) in TrackMan Performance Studio (TPS).
                More Friends functionalities will be available soon.
                """)
                .font(.callout)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.top, 10)

                Image("Graphic")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.7)
                    .padding([.bottom, .top], 10)
            }
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
            }
        }
    }

    private func calculateAge(from dateString: String) -> String {
        guard let date = parseDate(from: dateString) else { return "N/A" }

        let now = Date()
        let components = Calendar.current.dateComponents([.year], from: date, to: now)

        return "\(components.year ?? 0)"
    }

    private func parseDate(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()

        let dateFormats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd HH:mm:ss",
        ]

        for format in dateFormats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
        }

        return nil
    }
}
