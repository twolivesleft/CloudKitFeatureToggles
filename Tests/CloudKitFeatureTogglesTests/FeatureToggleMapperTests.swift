//
//  FeatureToggleMapperTests.swift
//  CloudKitFeatureTogglesTests
//
//  Created by Jonas Reichert on 06.01.20.
//

import XCTest
import CloudKit
@testable import CloudKitFeatureToggles

class FeatureToggleMapperTests: XCTestCase {
    
    var subject: FeatureToggleMappable!

    override func setUp() {
        subject = FeatureToggleMapper(featureToggleNameFieldID: "name", featureToggleValueFieldID: "value")
    }
    
    func testMapInvalidInput() {
        let everythingWrong = CKRecord(recordType: "RecordType", recordID: CKRecord.ID(recordName: "identifier"))
        everythingWrong["bla"] = true
        everythingWrong["muh"] = 1283765
        
        XCTAssertNil(subject.map(record: everythingWrong))
        
        let wrongFields = CKRecord(recordType: "FeatureStatus", recordID: CKRecord.ID(recordName: "identifier2"))
        wrongFields["bla"] = true
        wrongFields["muh"] = 1283765
        
        XCTAssertNil(subject.map(record: wrongFields))
        
        let wrongIsActiveField = CKRecord(recordType: "FeatureStatus", recordID: CKRecord.ID(recordName: "identifier3"))
        wrongIsActiveField["bla"] = true
        wrongIsActiveField["name"] = 1283765
        
        XCTAssertNil(subject.map(record: wrongIsActiveField))
        
        let wrongFeatureNameField = CKRecord(recordType: "FeatureStatus", recordID: CKRecord.ID(recordName: "identifier4"))
        wrongFeatureNameField["value"] = true
        wrongFeatureNameField["muh"] = 1283765
        
        XCTAssertNil(subject.map(record: wrongFeatureNameField))
        
        let wrongFeatureNameType = CKRecord(recordType: "FeatureStatus", recordID: CKRecord.ID(recordName: "identifier6"))
        wrongFeatureNameType["value"] = true
        wrongFeatureNameType["name"] = 1283765
        
        XCTAssertNil(subject.map(record: wrongFeatureNameType))
    }
    
    func testMap() {
        let expectedIdentifier = "1283765"
        let expectedValue: FeatureToggleValue = .integer(1)
        
        let record = CKRecord(recordType: "FeatureStatus", recordID: CKRecord.ID(recordName: "identifier"))
        record["value"] = true
        record["name"] = expectedIdentifier
        
        let result = subject.map(record: record)
        XCTAssertNotNil(result)
        XCTAssertEqual(result, FeatureToggle(identifier: expectedIdentifier, value: expectedValue))
    }
    
    func testMap2() {
        let expectedIdentifier = "akjshgdjaskd(/(/&%$§"
        let expectedValue: FeatureToggleValue = .integer(0)
        
        let record = CKRecord(recordType: "FeatureStatus", recordID: CKRecord.ID(recordName: "identifier"))
        record["value"] = false
        record["name"] = expectedIdentifier
        
        let result = subject.map(record: record)
        XCTAssertNotNil(result)
        XCTAssertEqual(result, FeatureToggle(identifier: expectedIdentifier, value: expectedValue))
    }
    
    static var allTests = [
        ("testMapInvalidInput", testMapInvalidInput),
        ("testMap", testMap),
        ("testMap2", testMap2),
    ]

}
