//
//  FeatureToggleRepositoryTests.swift
//  CloudKitFeatureTogglesTests
//
//  Created by Jonas Reichert on 01.01.20.
//

import XCTest
@testable import CloudKitFeatureToggles

class FeatureToggleRepositoryTests: XCTestCase {
    
    enum TestToggle: String, FeatureToggleIdentifiable {
        var identifier: String {
            return self.rawValue
        }
        
        var fallbackValue: FeatureToggleValue {
            switch self {
            case .feature1:
                return .integer(0)
            case .feature2:
                return .integer(1)
            }
        }
        
        case feature1
        case feature2
    }
    
    let suiteName = "repositoryTest"
    var defaults: UserDefaults!
    
    var subject: FeatureToggleRepository!
    
    override func setUp() {
        super.setUp()
        
        guard let defaults = UserDefaults(suiteName: suiteName) else {
            XCTFail()
            return
        }
        
        self.defaults = defaults
        self.subject = FeatureToggleUserDefaultsRepository(defaults: defaults)
    }
    
    override func tearDown() {
        self.defaults.removePersistentDomain(forName: suiteName)
        
        super.tearDown()
    }
    
    func testRetrieveBeforeSave() {
        XCTAssertEqual(subject.retrieve(identifiable: TestToggle.feature1).value, TestToggle.feature1.fallbackValue)
        XCTAssertEqual(subject.retrieve(identifiable: TestToggle.feature2).value, TestToggle.feature2.fallbackValue)
        
        XCTAssertFalse(subject.retrieve(identifiable: TestToggle.feature1).value == .integer(1))
        subject.save(featureToggle: FeatureToggle(identifier: TestToggle.feature1.rawValue, value: .integer(1)))
        XCTAssertTrue(subject.retrieve(identifiable: TestToggle.feature1).value == .integer(1))
    }

    func testSaveAndRetrieve() {
        XCTAssertFalse(subject.retrieve(identifiable: TestToggle.feature1).value == .integer(1))
        XCTAssertTrue(subject.retrieve(identifiable: TestToggle.feature2).value == .integer(1))
        
        subject.save(featureToggle: FeatureToggle(identifier: TestToggle.feature1.rawValue, value: .integer(1)))
        XCTAssertTrue(subject.retrieve(identifiable: TestToggle.feature1).value == .integer(1))
        XCTAssertTrue(subject.retrieve(identifiable: TestToggle.feature2).value == .integer(1))
        
        subject.save(featureToggle: FeatureToggle(identifier: TestToggle.feature2.rawValue, value: .integer(0)))
        XCTAssertTrue(subject.retrieve(identifiable: TestToggle.feature1).value == .integer(1))
        XCTAssertFalse(subject.retrieve(identifiable: TestToggle.feature2).value == .integer(1))
    }
    
    static var allTests = [
        ("testSaveAndRetrieve", testSaveAndRetrieve),
        ("testRetrieveBeforeSave", testRetrieveBeforeSave),
    ]

}
