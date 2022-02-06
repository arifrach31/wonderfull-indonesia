//
//  WonderfullIndonesiaUITestsLaunchTests.swift
//  WonderfullIndonesiaUITests
//
//  Created by ArifRachman on 05/02/22.
//  Copyright © 2022 WonderfullIndonesia. All rights reserved.
//

import XCTest

class WonderfullIndonesiaUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
    }
}
