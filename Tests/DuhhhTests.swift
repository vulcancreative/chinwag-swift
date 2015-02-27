//
//  DuhhhTests.swift
//  DuhhhTests
//
//  Created by Chris Calo on 2/26/15.
//  Copyright (c) 2015 Chris Calo. All rights reserved.
//

import Foundation
import Chinwag
import XCTest

class DuhhhTests: XCTestCase {
    func testChinwagVersion() {
        let version = "1.2.3"
        XCTAssertEqual(Chinwag.version, version, "version is incorrect")
    }
}
