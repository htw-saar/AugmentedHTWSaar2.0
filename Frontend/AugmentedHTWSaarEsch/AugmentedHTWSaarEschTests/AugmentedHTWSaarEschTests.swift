//
//  AugmentedHTWSaarEschTests.swift
//  AugmentedHTWSaarEschTests
//
//  Created by Christian Herz on 13.08.18.
//  Copyright © 2018 AugmentedReality. All rights reserved.
//

import XCTest
@testable import AugmentedHTWSaarEsch

class AugmentedHTWSaarEschTests: XCTestCase {
    
    var slot:TimeSlot?
    
    override func setUp() {
        super.setUp()
        
        slot = TimeSlot(from: "2019-01-01T08:30:00.000", to: "2019-01-01T10:00:00.000", id: 0220, label: "kp")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLeft() {
    
        let left = TimeUtils.longDate(str: "2019-01-01 08:00:00")!
        let right = TimeUtils.longDate(str: "2019-01-01 08:15:00")!
        
        XCTAssertFalse(slot!.intersect(from: left, to: right))
    }
    
    func testNearLeft() {
        
        let left = TimeUtils.longDate(str: "2019-01-01 08:00:00")!
        let right = TimeUtils.longDate(str: "2019-01-01 08:30:00")!
        
        XCTAssertFalse(slot!.intersect(from: left, to: right))
    }
    
    
    func testIntersectLeft() {
        
        let left = TimeUtils.longDate(str: "2019-01-01 08:00:00")!
        let right = TimeUtils.longDate(str: "2019-01-01 08:45:00")!
        
        XCTAssertTrue(slot!.intersect(from: left, to: right))
    }
    
    func testInside() {
        
        let left = TimeUtils.longDate(str: "2019-01-01 08:45:00")!
        let right = TimeUtils.longDate(str: "2019-01-01 08:50:00")!
        
        XCTAssertTrue(slot!.intersect(from: left, to: right))
    }
    
    func testOutside() {
        
        let left = TimeUtils.longDate(str: "2019-01-01 08:00:00")!
        let right = TimeUtils.longDate(str: "2019-01-01 10:50:00")!
        
        XCTAssertTrue(slot!.intersect(from: left, to: right))
    }
    
    func testIntersectRight() {
        
        let left = TimeUtils.longDate(str: "2019-01-01 08:45:00")!
        let right = TimeUtils.longDate(str: "2019-01-01 10:10:00")!
        
        XCTAssertTrue(slot!.intersect(from: left, to: right))
    }
    
    
    func testNearRight() {
        
        let left = TimeUtils.longDate(str: "2019-01-01 10:00:00")!
        let right = TimeUtils.longDate(str: "2019-01-01 10:10:00")!
        
        XCTAssertFalse(slot!.intersect(from: left, to: right))
    }
    
    
    func testRight() {
        
        let left = TimeUtils.longDate(str: "2019-01-01T10:01:00")!
        let right = TimeUtils.longDate(str: "2019-01-01T10:10:00")!
        
        XCTAssertFalse(slot!.intersect(from: left, to: right))
    }
    
    
    func testRight2() {
        
        let leftA = TimeUtils.isoDate(str: "2000-01-01T16:00:00.000+000")!
        let rightA = TimeUtils.isoDate(str: "2000-01-01T17:30:00.000+000")!
        
        var slot = TimeSlot()
        
        slot.from = "2019-09-05T14:15:00.000+000"
        slot.to = "2019-09-05T15:45:00.000+000"
        
        XCTAssertFalse(slot.intersect(from: leftA, to: rightA))
    }
    
}

