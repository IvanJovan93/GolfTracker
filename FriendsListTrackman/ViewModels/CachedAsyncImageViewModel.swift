//
//  Untitled.swift
//  FriendsListTrackman
//
//  Created by Ivan Jovanovik on 17.10.24.
//

import SwiftUI
import Combine

class CachedAsyncImageViewModel: ObservableObject {
    @Published var image: UIImage?
    
    @Service var imageCacheService: ImageCacheManager?
    
    func getImage(url: URL) {
           imageCacheService?.getImage(url: url) { image in
               self.image = image
           }
       }
    
    func cancelLoading(for url: URL) {
        imageCacheService?.cancelTaskForIdentifier(url.absoluteString)
    }
}
