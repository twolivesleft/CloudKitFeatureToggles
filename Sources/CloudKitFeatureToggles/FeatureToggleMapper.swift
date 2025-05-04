//
//  FeatureToggleMapper.swift
//  CloudKitFeatureToggles
//
//  Created by Jonas Reichert on 06.01.20.
//

import Foundation
import CloudKit

public enum FeatureToggleValue: Equatable {
    case integer(Int)
    case string(String)    
}

public extension FeatureToggleValue {
    var boolValue: Bool {
        switch self {
        case .integer(let i): return i != 0
        case .string(let s): return (s as NSString).boolValue
        }
    }
}

public protocol FeatureToggleRepresentable {
    var identifier: String { get }
    var value: FeatureToggleValue { get }
}

public protocol FeatureToggleIdentifiable {
    var identifier: String { get }
    var fallbackValue: FeatureToggleValue { get }
}

public struct FeatureToggle: FeatureToggleRepresentable, Equatable {
    public let identifier: String
    public let value: FeatureToggleValue
}

protocol FeatureToggleMappable {
    func map(record: CKRecord) -> FeatureToggle?
}

class FeatureToggleMapper: FeatureToggleMappable {
    private let featureToggleNameFieldID: String
    private let featureToggleValueFieldID: String
    
    init(featureToggleNameFieldID: String, featureToggleValueFieldID: String) {
        self.featureToggleNameFieldID = featureToggleNameFieldID
        self.featureToggleValueFieldID = featureToggleValueFieldID
    }
    
    func map(record: CKRecord) -> FeatureToggle? {
        guard let featureName = record[featureToggleNameFieldID] as? String else {
            return nil
        }
        
        let value = record[featureToggleValueFieldID]
        
        switch value {
        case let value as String:
            return FeatureToggle(identifier: featureName, value: .string(value))
        case let value as Int:
            return FeatureToggle(identifier: featureName, value: .integer(value))
        default:
            return nil
        }
    }
}
