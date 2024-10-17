//
//  HTTPClient.swift
//  FriendsListTrackman
//
//  Created by Ivan Jovanovik on 16.10.24.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

public protocol HTTPClientProtocol {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    typealias ImageMetaDataResult = Swift.Result<Date, HTTPClientError>
    @discardableResult
    func get(from url: URL, completion: @escaping (Result) -> Void) -> HTTPClientTask
        
    func getImageMetaData(from url: URL, completion: @escaping (ImageMetaDataResult) -> Void)
    
    func cancelTaskForIdentifier(_ identifier: String)
    
}
