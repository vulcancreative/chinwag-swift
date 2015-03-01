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

  func openTestCase(filename: String)
  -> String? {
    let manager = NSFileManager.defaultManager()
    let base = "Tests/TestCases"
    let file = base + "/" + filename

    if manager.fileExistsAtPath(file) {
      let enc = UnsafeMutablePointer<UInt>()

      return String(contentsOfFile: file, usedEncoding: enc, error: nil)
    }

    return nil
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

  func testCWDictCopy() {
    let testCaseOne = openTestCase("chinwag_testcase_seuss_dict_to_s")

    if testCaseOne == nil {
      XCTFail("test case should not be nil")
    }

    var clone = seuss.copy() as CWDict
    XCTAssertEqual(seuss.string(), testCaseOne!, "should match test case")
    XCTAssertEqual(clone.string(), testCaseOne!, "should match test case")

    seuss.close()
    XCTAssertEqual(seuss.string(), "[]", "should be closed")
    XCTAssertEqual(clone.string(), testCaseOne!, "should match test case")

    seuss = clone.copy() as CWDict
    XCTAssertEqual(seuss.string(), testCaseOne!, "should match test case")
    XCTAssertEqual(clone.string(), testCaseOne!, "should match test case")

    clone.close()
    XCTAssertEqual(seuss.string(), testCaseOne!, "should match test case")
    XCTAssertEqual(clone.string(), "[]", "should be closed")
  }
}
