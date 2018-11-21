//
//  UIImage+Data.swift
//  encryptionTimeTest
//
//  Created by Jakub Tudruj on 21/11/2018.
//  Copyright © 2018 Jakub Tudruj. All rights reserved.
//

import UIKit

extension UIImage {
    
    var data: Data {
        return self.pngData()!
    }
    
}
