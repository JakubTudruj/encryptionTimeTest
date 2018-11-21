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
        var text = "\nStart time: \(name) at time: \(startTime)"
        text += "\nStop time: \(stopTime)\n"
        if let error = error {
            text += "****"
            text += "\nTest failure. Error: \(error.localizedDescription)\n"
            text += "****"
        } else {
            text += "\nExecution time: \(executionTime.timeInterval)"
            text += "\nSeconds: \(executionTime.seconds)"
            text += "\nMiliseconds: \(executionTime.miliseconds)"
        }
        return text
    }

}

extension ResultEntity: CsvExportable {
    var csvText: String {
        let errorText = error?.localizedDescription ?? "-"
        return "\(name);\(errorText);\(executionTime.miliseconds);"
    }
}

protocol CsvExportable {
    var csvText: String { get }
}
