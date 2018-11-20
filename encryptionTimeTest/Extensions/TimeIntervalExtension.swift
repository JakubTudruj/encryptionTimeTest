//
//  TimeIntervalExtension.swift
//  encryptionTimeTest
//
//  Created by Jakub Tudruj on 20/11/2018.
//  Copyright © 2018 Jakub Tudruj. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    var miliseconds: Int64 {
        return Int64((self * 1000.0).rounded())
    }
    
    var seconds: Int64 {
        return Int64(self)
    }
    
}
