//
//  ModelMigrateTests.swift
//  ModelMigrateTests
//
//  Created by Alexey Martemianov on 15/01/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import XCTest
@testable import ModelMigrate

class ModelMigrateTests: XCTestCase {
    var coder: MigrateDecoder!
    var bundle: Bundle!
    
    override func setUp() {
        let jsonDecoder = JSONDecoder()
        let jsonEncoder = JSONEncoder()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"

        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        jsonEncoder.dateEncodingStrategy = .formatted(dateFormatter)
        
        coder = MigrateDecoder(encoder: jsonEncoder, decoder: jsonDecoder)
        bundle = Bundle(for: type(of: self))
    }

    override func tearDown() {
        coder = nil
        bundle = nil
    }

    func test_migration_from_0() {
        let data = try! Data(contentsOf: bundle.url(forResource: "model0", withExtension: "json")!)
        
        let model = try! coder.decode(Model.self, from: data)

        XCTAssertEqual(model.divisions.count, 2)

        XCTAssertEqual(model.divisions[0].employees.count, 2)
        XCTAssertEqual(model.divisions[1].employees.count, 2)

        XCTAssertEqual(model.employees[model.divisions[0].employees[0]]?.name, "John")
        XCTAssertEqual(model.employees[model.divisions[0].employees[0]]?.surname, "Doe")
        XCTAssertEqual(model.employees[model.divisions[0].employees[0]]?.birthdate, Date(timeIntervalSince1970: 536518800))
        
        XCTAssertEqual(model.employees[model.divisions[0].employees[1]]?.name, "Sarah")
        XCTAssertEqual(model.employees[model.divisions[1].employees[0]]?.name, "James")
        XCTAssertEqual(model.employees[model.divisions[1].employees[1]]?.name, "Emily")

    }

    func test_migration_from_1() {
        let data = try! Data(contentsOf: bundle.url(forResource: "model1", withExtension: "json")!)
        
        let model = try! coder.decode(Model.self, from: data)
        
        XCTAssertEqual(model.divisions.count, 2)
        
        XCTAssertEqual(model.divisions[0].employees.count, 2)
        XCTAssertEqual(model.divisions[1].employees.count, 2)
        
        XCTAssertEqual(model.employees[model.divisions[0].employees[0]]?.name, "John")
        XCTAssertEqual(model.employees[model.divisions[0].employees[0]]?.surname, "Doe")
        XCTAssertEqual(model.employees[model.divisions[0].employees[0]]?.birthdate, Date(timeIntervalSince1970: 536518800))
        
        XCTAssertEqual(model.employees[model.divisions[0].employees[1]]?.name, "Sarah")
        XCTAssertEqual(model.employees[model.divisions[1].employees[0]]?.name, "James")
        XCTAssertEqual(model.employees[model.divisions[1].employees[1]]?.name, "Emily")
    }
    
    func test_migration_from_2() {
        let data = try! Data(contentsOf: bundle.url(forResource: "model2", withExtension: "json")!)
        
        let model = try! coder.decode(Model.self, from: data)
        
        XCTAssertEqual(model.divisions.count, 2)
        
        XCTAssertEqual(model.divisions[0].employees.count, 2)
        XCTAssertEqual(model.divisions[1].employees.count, 2)
        
        XCTAssertEqual(model.employees[model.divisions[0].employees[0]]?.name, "John")
        XCTAssertEqual(model.employees[model.divisions[0].employees[0]]?.surname, "Doe")
        XCTAssertEqual(model.employees[model.divisions[0].employees[0]]?.birthdate, Date(timeIntervalSince1970: 536518800))
        
        XCTAssertEqual(model.employees[model.divisions[0].employees[1]]?.name, "Sarah")
        XCTAssertEqual(model.employees[model.divisions[1].employees[0]]?.name, "James")
        XCTAssertEqual(model.employees[model.divisions[1].employees[1]]?.name, "Emily")
    }

    func test_migration_from_3() {
        let data = try! Data(contentsOf: bundle.url(forResource: "model3", withExtension: "json")!)
        
        XCTAssertThrowsError(try coder.decode(Model.self, from: data)) { (error) -> Void in
            XCTAssertEqual(error as? MigrationError, MigrationError.unsupportedVersion(3))
        }
    }
    
    func test_encode() {
        let data = try! Data(contentsOf: bundle.url(forResource: "model0", withExtension: "json")!)
        
        let model = try! coder.decode(Model.self, from: data)
        
        let result = try! coder.encode(model)
        let obj = try! JSONSerialization.jsonObject(with: result, options: []) as? [String: Any]
        
        XCTAssertNotNil(obj)
        
        XCTAssertEqual(obj!["schema"] as? Int ?? -1, 2)
        
        let model2 = try! coder.decode(Model.self, from: result)
        XCTAssertEqual(model2.employees[model.divisions[0].employees[0]]?.name, "John")
        XCTAssertEqual(model.employees[model.divisions[0].employees[0]]?.birthdate, Date(timeIntervalSince1970: 536518800))
    }
    
}
