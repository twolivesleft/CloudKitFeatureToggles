//
//  FeatureToggleManager.swift
//  CloudKitFeatureToggles
//
//  Created by Jonas Reichert on 01.01.20.
//

import Foundation

public protocol FeatureToggleRepository {
    /// retrieves a stored `FeatureToggleRepresentable` from the underlying store.
    func retrieve(identifiable: FeatureToggleIdentifiable) -> FeatureToggleRepresentable
    /// saves a supplied `FeatureToggleRepresentable` to the underlying store
    func save(featureToggle: FeatureToggleRepresentable)
}

public class FeatureToggleUserDefaultsRepository {
    
    private static let defaultsSuiteName = "featureToggleUserDefaultsRepositorySuite"
    private let defaults: UserDefaults
    
    public init(defaults: UserDefaults? = nil) {
        self.defaults = defaults ?? UserDefaults(suiteName: FeatureToggleUserDefaultsRepository.defaultsSuiteName) ?? .standard
    }
}

extension FeatureToggleUserDefaultsRepository: FeatureToggleRepository {
    public func retrieve(identifiable: FeatureToggleIdentifiable) -> FeatureToggleRepresentable {
        let storedValue = defaults.value(forKey: identifiable.identifier)
        let value: FeatureToggleValue
        
        switch storedValue {

        case let int as Int:
            value = .integer(int)
        case let string as String:
            value = .string(string)
        default:
            value = identifiable.fallbackValue
        }
        
        return FeatureToggle(identifier: identifiable.identifier, value: value)
    }
    
    public func save(featureToggle: FeatureToggleRepresentable) {
        switch featureToggle.value {
        case .integer(let intValue):
            defaults.set(intValue, forKey: featureToggle.identifier)
        case .string(let stringValue):
            defaults.set(stringValue, forKey: featureToggle.identifier)
        }
    }
}
