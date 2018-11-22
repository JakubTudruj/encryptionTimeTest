//
//  AsymmetricEncryptor.swift
//  encryptionTimeTest
//
//  Created by Jakub Tudruj on 21/11/2018.
//  Copyright © 2018 Jakub Tudruj. All rights reserved.
//

import CommonCrypto
import Foundation
import UIKit

class AsymmetricEncryptor {
    
    func encrypt(data: CFData, using algorithm: SecKeyAlgorithm, with key: SecKey) {
        var error: Unmanaged<CFError>?
        SecKeyCreateEncryptedData(key, algorithm, data, &error)
    }
    
    func decrypt(data: Data, using algorithm: SecKeyAlgorithm, with key: SecKey) {
        
    }
    
}

struct SymmetricEncryptor {
    
    // MARK: - Value
    // MARK: Private
    private let key: Data
    private let iv: Data
    
    
    // MARK: - Initialzier
    init?(key: Data, iv: Data = Data.random(length: kCCBlockSizeAES128)) {
        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES192 || key.count == kCCKeySizeAES256 else {
            debugPrint("Error: Failed to set a key.")
            return nil
        }
        
        guard iv.count == kCCBlockSizeAES128 else {
            debugPrint("Error: Failed to set an initial vector.")
            return nil
        }
        
        self.key = key
        self.iv  = iv
    }
    
    
    // MARK: - Function
    // MARK: Public
    @discardableResult
    func encrypt(string: String) -> Data? {
        return crypt(data: string.data(using: .utf8), option: CCOperation(kCCEncrypt))
    }
    
    @discardableResult
    func encrypt(data: Data) -> Data? {
        return crypt(data: data, option: CCOperation(kCCEncrypt))
    }
    
    @discardableResult
    func encrypt(image: UIImage) -> Data? {
        return crypt(data: image.pngData()!, option: CCOperation(kCCEncrypt))
    }
    
    func decrypt(data: Data?) -> String? {
        guard let decryptedData = crypt(data: data, option: CCOperation(kCCDecrypt)) else { return nil }
        return String(bytes: decryptedData, encoding: .utf8)
    }
    
    func crypt(data: Data?, option: CCOperation) -> Data? {
        guard let data = data else { return nil }
        
        let cryptLength = [UInt8](repeating: 0, count: data.count + kCCBlockSizeAES128).count
        var cryptData   = Data(count: cryptLength)
        
        let keyLength = [UInt8](repeating: 0, count: kCCBlockSizeAES128).count
        let options   = CCOptions(kCCOptionPKCS7Padding)
        
        var bytesLength = Int(0)
        
        let status = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                iv.withUnsafeBytes { ivBytes in
                    key.withUnsafeBytes { keyBytes in
                        CCCrypt(option, CCAlgorithm(kCCAlgorithmAES), options, keyBytes, keyLength, ivBytes, dataBytes, data.count, cryptBytes, cryptLength, &bytesLength)
                    }
                }
            }
        }
        
        guard UInt32(status) == UInt32(kCCSuccess) else {
            debugPrint("Error: Failed to crypt data. Status \(status)")
            return nil
        }
        
        cryptData.removeSubrange(bytesLength..<cryptData.count)
        return cryptData
    }
}

