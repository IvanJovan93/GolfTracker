//
//  Untitled.swift
//  FriendsListTrackman
//
//  Created by Ivan Jovanovik on 16.10.24.
//

import Foundation
import UIKit

public enum HTTPClientError: Error {
    case invalidResponse
    case invalidData
    case invalidURL
}

public final class URLSessionHTTPClientService: HTTPClientProtocol {
  
    private let session: URLSession
    var tasks: [String: URLSessionTask] = [:]
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
        return df
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask
        
        func cancel() {
            wrapped.cancel()
        }
    }
    
    public func get(from url: URL, completion: @escaping (HTTPClientProtocol.Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: url) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }
        task.resume()
        tasks[url.absoluteString] = task
        return URLSessionTaskWrapper(wrapped: task)
    }
    
    public func getImageMetaData(from url: URL, completion: @escaping (ImageMetaDataResult) -> Void) {
        
        var headRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        headRequest.httpMethod = "HEAD"
        
        session.dataTask(with: headRequest)
        { _, response , _ in
            guard let httpResponse = response as? HTTPURLResponse,
                let lastModifiedString = httpResponse.allHeaderFields["Last-Modified"] as? String,
                  let lastModifiedDate = self.dateFormatter.date(from: lastModifiedString) else { completion(.failure(.invalidResponse))
                return
            }

            completion(.success(lastModifiedDate))
        }.resume()
    }
    
    public func cancelTaskForIdentifier(_ identifier: String) {
        tasks[identifier]?.cancel()
        tasks.removeValue(forKey: identifier)
    }
    
}
