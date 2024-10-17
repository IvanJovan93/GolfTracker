//
//  ServiceContainer.swift
//  FriendsListTrackman
//
//  Created by Ivan Jovanovik on 16.10.24.
//

import Foundation

public enum ServiceContainer {

    private static var services: [String: Any] = [:]

    public static func register<Service>(_ type: Service.Type, with service: Service) {
        let serviceName = String(describing: type.self)
        services[serviceName] = service
    }

    public static func resolve<Service>(_ type: Service.Type) -> Service? {
        let serviceName = String(describing: type.self)
        let service = services[serviceName] as? Service
        return service
    }

    public static func unregister<Service>(_ type: Service.Type) {
        let serviceName = String(describing: type.self)
        services.removeValue(forKey: serviceName)
    }
}
