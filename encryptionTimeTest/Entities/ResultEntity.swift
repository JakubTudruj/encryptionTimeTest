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

extension ResultEntity: CustomStringConvertible {
    var description: String {
        var text = "\nStarted test: \(name) at time: \(startTime)"
        text += "\nStopped ad time: \(stopTime)\n"
        if let error = error {
            text += "****"
            text += "\nTest failure. Error: \(error.localizedDescription)\n"
            text += "****"
        } else {
            text += "\nExecution time: \(executionTime.timeInterval)"
            text += "\nseconds: \(executionTime.seconds)"
            text += "\nmiliseconds: \(executionTime.miliseconds)"
        }
        return text
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
