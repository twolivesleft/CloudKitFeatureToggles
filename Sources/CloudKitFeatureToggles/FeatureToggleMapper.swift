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
    private let featureToggleIntValueFieldID: String
    private let featureToggleStringValueFieldID: String
    
    init(featureToggleNameFieldID: String, featureToggleIntValueFieldID: String, featureToggleStringValueFieldID: String) {
        self.featureToggleNameFieldID = featureToggleNameFieldID
        self.featureToggleIntValueFieldID = featureToggleIntValueFieldID
        self.featureToggleStringValueFieldID = featureToggleStringValueFieldID
    }
    
    func map(record: CKRecord) -> FeatureToggle? {
        guard let featureName = record[featureToggleNameFieldID] as? String else {
            return nil
        }
        
        return if let value = record[featureToggleIntValueFieldID] as? Int {
            FeatureToggle(identifier: featureName, value: .integer(value))
        } else if let value = record[featureToggleStringValueFieldID] as? String {
            FeatureToggle(identifier: featureName, value: .string(value))
        } else {
            nil
        }
    }
}

public extension FeatureToggleRepresentable {
    var intValue: Int {
        switch value {
        case .integer(let int):
            int
        default:
            fatalError("Int value used on non-int feature type")
        }
    }
    
    var stringValue: String {
        switch value {
        case .string(let string):
            string
        default:
            fatalError("String value used on non-string feature type")
        }
    }
    
    var boolValue: Bool {
        switch value {
        case .integer(let i):
            i != 0
        case .string(let s):
            (s as NSString).boolValue
        }
    }
}
