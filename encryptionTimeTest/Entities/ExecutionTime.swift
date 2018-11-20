//
//  ExecutionTime.swift
//  encryptionTimeTest
//
//  Created by Jakub Tudruj on 21/11/2018.
//  Copyright © 2018 Jakub Tudruj. All rights reserved.
//

import Foundation

struct ExecutionTime {
    
    let timeInterval: TimeInterval
    
    var seconds: Int64 {
        return timeInterval.seconds
    }
    
    var miliseconds: Int64 {
        return timeInterval.miliseconds
    }
    
}
