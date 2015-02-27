//
//  GenerationTests.swift
//  Chinwag
//
//  Created by Chris Calo on 2/26/15.
//  Copyright (c) 2015 Chris Calo. All rights reserved.
//

import Foundation
import Chinwag
import XCTest

class GenerationTests: XCTestCase {
    var blank = Chinwag.open()
    var seuss = Chinwag.open()
    var latin = Chinwag.open()
    
    override func setUp() {
        super.setUp()
        
        blank = Chinwag.open()
        seuss = Chinwag.open(embedded: .Seuss)!
        latin = Chinwag.open(embedded: .Latin)!
    }
    
    override func tearDown() {
        super.tearDown()
        
        blank.close()
        seuss.close()
        latin.close()
    }
    
    func testGenerateMinLessThanOneError() {
        let result = Chinwag.generate(seuss, .Letters, 0, 10)
        let raw = result.err!.rawValue
        
        XCTAssertEqual(raw, CWError.MinLessThanOne.rawValue, "min is less than one, but no error was thrown")
    }
    
    func testGenerateMaxLessThanMinError() {
        let result = Chinwag.generate(seuss, .Letters, 13, 12)
        let raw = result.err!.rawValue
        
        XCTAssertEqual(raw, CWError.MaxLessThanMin.rawValue, "max is less than min, but no error was thrown")
    }
    
    func testGenerateMaxTooHighError() {
        let result = Chinwag.generate(seuss, .Letters, 5, 10001)
        let raw = result.err!.rawValue
        
        XCTAssertEqual(raw, CWError.MaxTooHigh.rawValue, "max exceeds 10.000, but no error was thrown")
    }
    
    func testGenerateDictionaryTooSmallError() {
        let result = Chinwag.generate(blank, .Letters, 4, 50)
        let raw = result.err!.rawValue
        
        XCTAssertEqual(raw, CWError.DictTooSmall.rawValue, "dict should be too small, but no error was thrown")
    }
}
