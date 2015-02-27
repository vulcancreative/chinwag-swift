//
//  DictionaryTests.swift
//  Chinwag
//
//  Created by Chris Calo on 2/26/15.
//  Copyright (c) 2015 Chris Calo. All rights reserved.
//

import Foundation
import Chinwag
import XCTest

class DictionaryTests: XCTestCase {
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

  func testCWDictGetName() {
    XCTAssertEqual(blank.name, "", "name should be a empty")
    XCTAssertEqual(seuss.name, "Seussian", "name should be \"Seussian\"")
    XCTAssertEqual(latin.name, "Latin", "name should be \"Latin\"")
  }

  func testCWDictSetname() {
    blank.name = "blank"
    seuss.name = "Geisel"
    XCTAssertEqual(blank.name, "blank", "name should be \"blank\"")
    XCTAssertEqual(seuss.name, "Geisel", "name should be \"Geisel\"")
  }
}
