//
//  PsionicTimeMap_ImageProducerTests.swift
//  PsionicTimeMap_ImageProducerTests
//
//  Created by Jordan Trana on 8/31/20.
//  Copyright © 2020 Jordan Trana. All rights reserved.
//

import XCTest
@testable import PsionicTimeMap_ImageProducer

class PsionicTimeMap_ImageProducerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRGYBColor_Red() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        var rgybColor = RGYBColor(degrees: 15)
        
        print("R: \(rgybColor.red)")
        print("G: \(rgybColor.green)")
        print("Y: \(rgybColor.yellow)")
        print("B: \(rgybColor.blue)")
        
        XCTAssert(rgybColor.red == 1)
        XCTAssert(rgybColor.green == 0)
        XCTAssert(rgybColor.yellow == 0)
        XCTAssert(rgybColor.blue == 0)
        
        rgybColor = RGYBColor(degrees: 135)
        
        XCTAssert(rgybColor.red == 1)
        XCTAssert(rgybColor.green == 0)
        XCTAssert(rgybColor.yellow == 0)
        XCTAssert(rgybColor.blue == 0)
        
        rgybColor = RGYBColor(degrees: 255)
        
        XCTAssert(rgybColor.red == 1)
        XCTAssert(rgybColor.green == 0)
        XCTAssert(rgybColor.yellow == 0)
        XCTAssert(rgybColor.blue == 0)
    }

    func testRGYBColorAt_Green() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        var rgybColor = RGYBColor(degrees: 45)
        
        print("R: \(rgybColor.red)")
        print("G: \(rgybColor.green)")
        print("Y: \(rgybColor.yellow)")
        print("B: \(rgybColor.blue)")
        
        XCTAssert(rgybColor.red == 0)
        XCTAssert(rgybColor.green == 1)
        XCTAssert(rgybColor.yellow == 0)
        XCTAssert(rgybColor.blue == 0)
        
        rgybColor = RGYBColor(degrees: 165)
        
        XCTAssert(rgybColor.red == 0)
        XCTAssert(rgybColor.green == 1)
        XCTAssert(rgybColor.yellow == 0)
        XCTAssert(rgybColor.blue == 0)
        
        rgybColor = RGYBColor(degrees: 285)
        
        XCTAssert(rgybColor.red == 0)
        XCTAssert(rgybColor.green == 1)
        XCTAssert(rgybColor.yellow == 0)
        XCTAssert(rgybColor.blue == 0)
    }

    func testRGYBColorAt_Yellow() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        var rgybColor = RGYBColor(degrees: 75)
        
        print("R: \(rgybColor.red)")
        print("G: \(rgybColor.green)")
        print("Y: \(rgybColor.yellow)")
        print("B: \(rgybColor.blue)")
        
        XCTAssert(rgybColor.red == 0)
        XCTAssert(rgybColor.green == 0)
        XCTAssert(rgybColor.yellow == 1)
        XCTAssert(rgybColor.blue == 0)
        
        rgybColor = RGYBColor(degrees: 195)
        
        XCTAssert(rgybColor.red == 0)
        XCTAssert(rgybColor.green == 0)
        XCTAssert(rgybColor.yellow == 1)
        XCTAssert(rgybColor.blue == 0)
        
        rgybColor = RGYBColor(degrees: 315)
        
        XCTAssert(rgybColor.red == 0)
        XCTAssert(rgybColor.green == 0)
        XCTAssert(rgybColor.yellow == 1)
        XCTAssert(rgybColor.blue == 0)
    }

    func testRGYBColorAt_Blue() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        var rgybColor = RGYBColor(degrees: 105)
        
        print("R: \(rgybColor.red)")
        print("G: \(rgybColor.green)")
        print("Y: \(rgybColor.yellow)")
        print("B: \(rgybColor.blue)")
        
        XCTAssert(rgybColor.red == 0)
        XCTAssert(rgybColor.green == 0)
        XCTAssert(rgybColor.yellow == 0)
        XCTAssert(rgybColor.blue == 1)
        
        rgybColor = RGYBColor(degrees: 225)
        
        XCTAssert(rgybColor.red == 0)
        XCTAssert(rgybColor.green == 0)
        XCTAssert(rgybColor.yellow == 0)
        XCTAssert(rgybColor.blue == 1)
        
        rgybColor = RGYBColor(degrees: 345)
        
        XCTAssert(rgybColor.red == 0)
        XCTAssert(rgybColor.green == 0)
        XCTAssert(rgybColor.yellow == 0)
        XCTAssert(rgybColor.blue == 1)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
