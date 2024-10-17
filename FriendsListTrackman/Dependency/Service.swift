//
//  Service.swift
//  FriendsListTrackman
//
//  Created by Ivan Jovanovik on 16.10.24.
//

import Foundation

@propertyWrapper
public struct Service<Service> {

    private var service: Service?
    private var resolved = false

    public init() {
    }

    public var wrappedValue: Service? {
        mutating get {
            if !resolved {
                self.service = ServiceContainer.resolve(Service.self)
                resolved = true
            }
            return service
        }
        mutating set {
            service = newValue
            resolved = true
        }
    }
}
