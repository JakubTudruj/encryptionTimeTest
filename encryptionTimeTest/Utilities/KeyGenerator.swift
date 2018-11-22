//
//  KeyGenerator.swift
//  encryptionTimeTest
//
//  Created by Jakub Tudruj on 20/11/2018.
//  Copyright © 2018 Jakub Tudruj. All rights reserved.
//

import Foundation
import CommonCrypto

enum AESError: LocalizedError {
    case secRandomCopyBytes(OSStatus)
    case generatingKeyProblem(Int)
    
    var errorDescription: String? {
        switch self {
        case .secRandomCopyBytes(let code):
            return "AES generating error. OSStatus: \(code)"
        case .generatingKeyProblem(let code):
            return "AES generating error. OSStatus: \(code)"
        }
    }
}

class KeyGenerator {
    
    func rsa(keyLength: RSA) throws -> SecKey {
        let parameters: [CFString : Any] = [
            kSecAttrKeyType : kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits : keyLength.rawValue
        ]
        return try key(parameters: parameters)
    }
    
    func ecc(keyLength: ECC) throws -> SecKey {
        let parameters: [CFString : Any] = [
            kSecAttrKeyType : kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeySizeInBits : keyLength.rawValue
        ]
        return try key(parameters: parameters)
    }
    
    func aes(keyLength: AES) throws -> Data {
        let password = Data.random(length: 8)
        let salt = Data.random(length: 8)
        
        let length = keyLength.keySize
        
        var status = Int32(0)
        var derivedBytes = [UInt8](repeating: 0, count: length)
        password.withUnsafeBytes { (passwordBytes: UnsafePointer<Int8>!) in
            salt.withUnsafeBytes { (saltBytes: UnsafePointer<UInt8>!) in
                status = CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2),                  // algorithm
                    passwordBytes,                                // password
                    password.count,                               // passwordLen
                    saltBytes,                                    // salt
                    salt.count,                                   // saltLen
                    CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA1),   // prf
                    10000,                                        // rounds
                    &derivedBytes,                                // derivedKey
                    length)                                       // derivedKeyLen
            }
        }
        guard status == 0 else {
            throw AESError.generatingKeyProblem(Int(status))
        }
        return Data(bytes: UnsafePointer<UInt8>(derivedBytes), count: length)
    }
    
    private func key(parameters: [CFString : Any]) throws -> SecKey {
        var error: Unmanaged<CFError>?
        let key = SecKeyCreateRandomKey(parameters as CFDictionary, &error)
        if let e = error {
            throw e.takeRetainedValue()
        } else {
            return key!
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
