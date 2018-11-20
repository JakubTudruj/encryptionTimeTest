//
//  KeyGenerator.swift
//  encryptionTimeTest
//
//  Created by Jakub Tudruj on 20/11/2018.
//  Copyright © 2018 Jakub Tudruj. All rights reserved.
//

import Foundation

enum AESError: LocalizedError {
    case secRandomCopyBytes(OSStatus)
    
    var errorDescription: String? {
        switch self {
        case .secRandomCopyBytes(let code):
            return "AES generating error. OSStatus: \(code)"
        }
    }
}

class KeyGenerator {
    
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
    }
    
    func rsa(keyLength: RSA) throws {
        let parameters: [CFString : Any] = [
            kSecAttrKeyType : kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits : keyLength.rawValue
        ]
        try key(parameters: parameters)
    }
    
    func ecc(keyLength: ECC) throws {
        let parameters: [CFString : Any] = [
            kSecAttrKeyType : kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeySizeInBits : keyLength.rawValue
        ]
        try key(parameters: parameters)
    }
    
    func aes(keyLength: AES) throws {
        var bytes = [Int8](repeating: 0, count: keyLength.rawValue)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        if status == errSecSuccess {
            print("AES \(keyLength.rawValue):")
            print(bytes)
        } else {
            throw AESError.secRandomCopyBytes(status)
        }
    }
    
    private func key(parameters: [CFString : Any]) throws {
        var error: Unmanaged<CFError>?
        SecKeyCreateRandomKey(parameters as CFDictionary, &error)
        if let e = error {
            throw e.takeRetainedValue()
        }
    }
    
    func resetKeychain() {
        deleteAllKeysForSecClass(kSecClassGenericPassword)
        deleteAllKeysForSecClass(kSecClassInternetPassword)
        deleteAllKeysForSecClass(kSecClassCertificate)
        deleteAllKeysForSecClass(kSecClassKey)
        deleteAllKeysForSecClass(kSecClassIdentity)
    }
    
    private func deleteAllKeysForSecClass(_ secClass: CFTypeRef) {
        let dict: [String : Any] = [kSecClass as String : secClass,]
        deleteKey(for: dict)
    }
    
    private func deleteKey(for attributes: [String: Any]) {
        let result = SecItemDelete(attributes as CFDictionary)
        assert(result == noErr || result == errSecItemNotFound, "Error deleting keychain data (\(result))")
    }
    
}
