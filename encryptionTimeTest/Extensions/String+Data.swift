//
//  String+Data.swift
//  encryptionTimeTest
//
//  Created by Jakub Tudruj on 21/11/2018.
//  Copyright © 2018 Jakub Tudruj. All rights reserved.
//

import Foundation

extension String {
    
    var cfdata: CFData {
        return self.data(using: .utf8)! as CFData
    }
    
}
