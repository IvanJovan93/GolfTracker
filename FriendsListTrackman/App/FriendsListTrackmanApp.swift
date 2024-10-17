//
//  FriendsListTrackmanApp.swift
//  FriendsListTrackman
//
//  Created by Ivan Jovanovik on 14.10.24.
//

import SwiftUI
import SwiftData

@main
struct FriendsListTrackmanApp: App {
    let imageCacheService: ImageCacheManager = ImageCacheManager()
    let remoteUserLoaderService: UserListLoaderProtocol = RemoteUserLoaderService()
    let clientService: HTTPClientProtocol = URLSessionHTTPClientService()
    
    init () {
        ServiceContainer.register(ImageCacheManager.self, with: imageCacheService)
        ServiceContainer.register(UserListLoaderProtocol.self, with: remoteUserLoaderService)
        ServiceContainer.register(HTTPClientProtocol.self, with: clientService)
    }
    @State var playingLottie: Bool = true
    var body: some Scene {
        WindowGroup {
            VStack {
                if playingLottie {
                    LottieView(animationFileName: "golfTracker.json", loopMode: .playOnce)
                        .scaledToFit()
                        .padding()
                        .preferredColorScheme(.light)
                } else {
                    UserProfilesListView()
                        .preferredColorScheme(.light)
                }
            }.onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        playingLottie = false
                    }
                }
            }
        }
    }
}
