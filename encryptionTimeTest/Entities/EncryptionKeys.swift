//
//  EncryptionKeys.swift
//  encryptionTimeTest
//
//  Created by Jakub Tudruj on 21/11/2018.
//  Copyright © 2018 Jakub Tudruj. All rights reserved.
//

import Foundation
import CommonCrypto

enum RSA: Int {
    case rsa1024 = 1024
    case rsa2048 = 2048
    case rsa4096 = 4096
    case rsa8192 = 8192
    case rsa15360 = 15360
}

enum ECC: Int {
    case ecc160 = 160
    case ecc224 = 224
    case ecc256 = 256
    case ecc384 = 384
    case ecc512 = 512
}

enum AES: Int {
    case aes128 = 128
    case aes192 = 192
    case aes256 = 256
    
    var keySize: Int {
        switch self {
        case .aes128:
            return kCCKeySizeAES128
        case .aes192:
            return kCCKeySizeAES192
        case .aes256:
            return kCCKeySizeAES256
        }
    }
}
