//
//  CachedAsyncImage.swift
//  FriendsListTrackman
//
//  Created by Ivan Jovanovik on 15.10.24.
//

import SwiftUI

struct CachedAsyncImageView: View {
    @StateObject private var viewModel = CachedAsyncImageViewModel()
    let url: URL?
    let isThumbnail: Bool

    init(url: URL? = nil, isThumbnail: Bool = false) {
        self.url = url
        self.isThumbnail = isThumbnail
    }

    var body: some View {
        if let url = url {
            VStack {
                Group {
                    if let image = viewModel.image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .scaledToFill()
                            .frame(width: frameWidth, height: frameHeight)
                            .clipShape(Circle())
                            .clipped()
                    } else {
                        ProgressView()
                            .frame(width: frameWidth, height: frameHeight)
                    }
                }
                .onAppear {
                    viewModel.getImage(url: url)
                }
                .onDisappear {
                    viewModel.cancelLoading(for: url)
                }
            }
        } else {
            EmptyView()
        }
    }

    private var frameWidth: CGFloat {
        isThumbnail ? 60 : 180
    }

    private var frameHeight: CGFloat {
        isThumbnail ? 60 : 180
    }
}
