//
//  ResultEntity.swift
//  encryptionTimeTest
//
//  Created by Jakub Tudruj on 20/11/2018.
//  Copyright © 2018 Jakub Tudruj. All rights reserved.
//

import Foundation

struct ResultEntity {
    let name: String
    let startTime: Date
    let stopTime: Date
    let error: Error?

    var executionTime: ExecutionTime {
        let timeInterval = stopTime.timeIntervalSince(startTime)
        return ExecutionTime(timeInterval: timeInterval)
    }
}

struct ExecutionTime {
    let timeInterval: TimeInterval
    
    var seconds: Int64 {
        return timeInterval.seconds
    }
    
    var miliseconds: Int64 {
        return timeInterval.miliseconds
    }
}
