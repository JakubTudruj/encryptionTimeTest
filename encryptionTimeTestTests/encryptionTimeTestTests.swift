//
//  encryptionTimeTestTests.swift
//  encryptionTimeTestTests
//
//  Created by Jakub Tudruj on 28/06/2018.
//  Copyright © 2018 Jakub Tudruj. All rights reserved.
//

import XCTest
@testable import encryptionTimeTest

class encryptionTimeTestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformanceRsa1024() {
        self.measure {
            KeyGenerator().rsa(keyLength: .rsa1024)
        }
    }
    
    func testPerformanceRsa2048() {
        self.measure {
            KeyGenerator().rsa(keyLength: .rsa2048)
        }
    }
    
    func testPerformanceRsa4096() {
        self.measure {
            KeyGenerator().rsa(keyLength: .rsa4096)
        }
    }
    
    func testPerformanceRsa8192() {
        self.measure {
            KeyGenerator().rsa(keyLength: .rsa8192)
        }
    }
    
}
