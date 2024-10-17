//
//  UIImage+Extension.swift
//  FriendsListTrackman
//
//  Created by Ivan Jovanovik on 15.10.24.
//

import SwiftUI

extension UIImage {
    func resize(to targetSize: CGSize) -> UIImage? {
        let widthRatio = targetSize.width / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        let scaleFactor = max(widthRatio, heightRatio)
        
        let scaledImageSize = CGSize(
            width: self.size.width * scaleFactor,
            height: self.size.height * scaleFactor
        )
        
        let origin = CGPoint(
            x: (targetSize.width - scaledImageSize.width) / 2,
            y: (targetSize.height - scaledImageSize.height) / 2
        )
        
        let drawRect = CGRect(origin: origin, size: scaledImageSize)
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        self.draw(in: drawRect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
