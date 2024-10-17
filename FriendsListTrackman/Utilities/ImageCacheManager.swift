//
//  ImageCacheManager.swift
//  FriendsListTrackman
//
//  Created by Ivan Jovanovik on 15.10.24.
//

import Combine
import SwiftUI
import UIKit

class ImageCacheManager: ObservableObject {
    private let imageCache = NSCache<NSURL, UIImage>()
    @Service var imageService: HTTPClientProtocol?
    var dateFormatter: DateFormatter {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
        return dateformatter
    }

    func getImage(url: URL, completion: @escaping (UIImage) -> Void) {
        if let cachedImage = imageCache.object(forKey: url as NSURL) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
        }
        checkIfImageNeedsUpdating(for: url) { [weak self] image in
            if let image = image {
                self?.saveImageToCache(image, for: url)
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                self?.imageService?.get(from: url) { result in
                    switch result {
                    case let .success((data, response)):
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            completion(image ?? UIImage(systemName: "person.crop.circle.fill")!)
                        }
                        if let image = image,
                           let lastModifiedString = response.allHeaderFields["Last-Modified"] as? String {
                            self?.saveImageToCache(image, for: url)
                            self?.saveImageToSandbox(image, for: url, modificationDate: lastModifiedString)
                        }
                    case .failure:
                        DispatchQueue.main.async {
                            completion(UIImage(systemName: "person.crop.circle.fill")!)
                        }
                    }
                }
            }
        }
    }

    func cancelTaskForIdentifier(_ identifier: String) {
        imageService?.cancelTaskForIdentifier(identifier)
    }

    private func checkIfImageNeedsUpdating(for url: URL, completion: @escaping (UIImage?) -> Void) {
        imageService?.getImageMetaData(from: url) { result in

            switch result {
            case let .success(lastModifiedDate):

                if let imageAndMetadata = self.loadImageFromSandbox(for: url),
                   let attributes = try? FileManager.default.attributesOfItem(atPath: imageAndMetadata.url!.path),
                   let modifiedDate = attributes[.modificationDate] as? Date {
                    if lastModifiedDate > modifiedDate {
                        completion(nil)
                        return
                    }
                    completion(imageAndMetadata.image)
                    return
                }
                completion(nil)
            case .failure:
                completion(nil)
            }
        }
    }

    private func downloadImage(for url: URL) -> AnyPublisher<UIImage, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> UIImage in
                guard let image = UIImage(data: data),
                      let modificationDate = (response as? HTTPURLResponse)?
                    .allHeaderFields["Last-Modified"] as? String else {
                    throw URLError(.badServerResponse)
                }
                self.saveImageToSandbox(image, for: url, modificationDate: modificationDate)
                return image
            }
            .eraseToAnyPublisher()
    }
    
    private func saveImageToCache(_ image: UIImage, for url: URL) {
        if let compressedImageData = image.jpegData(compressionQuality: 0.3),
           let compressedImage = UIImage(data: compressedImageData) {
            self.imageCache.setObject(compressedImage, forKey: url as NSURL)
        }
    }

    private func loadImageFromSandbox(for url: URL) -> (url: URL?, image: UIImage?)? {
        let fileManager = FileManager.default
        let sandboxURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("imgs")
        guard let imagePath = sandboxURL?.appendingPathComponent(url.lastPathComponent) else { return nil }
        return (imagePath, UIImage(contentsOfFile: imagePath.path))
    }

    private func saveImageToSandbox(_ image: UIImage, for url: URL, modificationDate: String) {
        let modDate = dateFormatter.date(from: modificationDate)
        let fileManager = FileManager.default
        let sandboxURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("imgs")

        do {
            try fileManager.createDirectory(at: sandboxURL!, withIntermediateDirectories: true, attributes: nil)
            guard let imagePath = sandboxURL?.appendingPathComponent(url.lastPathComponent) else { return }
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                try imageData.write(to: imagePath)
                let fileAttributes = [FileAttributeKey.modificationDate: modDate]
                try FileManager.default.setAttributes(fileAttributes as [FileAttributeKey: Any], ofItemAtPath: imagePath.path)
            }
        } catch {
            print("Error saving image to sandbox: \(error)")
        }
    }
}
