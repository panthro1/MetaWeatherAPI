//
//  MetaWeatherAPITests.swift
//  MetaWeatherAPITests
//
//  Created by john ledesma on 8/14/18.
//  Copyright © 2018 john ledesma. All rights reserved.
//

import XCTest
@testable import MetaWeatherAPI

extension XCTestCase {
    
    func wait(for duration: TimeInterval) {
        let waitExpectation = expectation(description: "Waiting")
        
        let when = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: when) {
            waitExpectation.fulfill()
        }
        
        // We use a buffer here to avoid flakiness with Timer on CI
        waitForExpectations(timeout: duration + 0.5)
    }
}

class MetaWeatherAPITests: XCTestCase {

    
    var metaWeatherApi: MetaWeatherApi!
    
    override func setUp() {
        super.setUp()
        metaWeatherApi = MetaWeatherApi()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        metaWeatherApi = nil
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
