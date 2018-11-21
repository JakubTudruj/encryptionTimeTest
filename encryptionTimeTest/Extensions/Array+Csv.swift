//
//  Array+Csv.swift
//  encryptionTimeTest
//
//  Created by Jakub Tudruj on 21/11/2018.
//  Copyright © 2018 Jakub Tudruj. All rights reserved.
//

import Foundation

extension Array where Element : CsvExportable {
    var csvText: String {
        var fullText = ""
        self.forEach { fullText += $0.csvText + "\n" }
        return fullText
    }
}
