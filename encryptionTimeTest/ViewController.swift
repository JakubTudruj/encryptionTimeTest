//
//  ViewController.swift
//  encryptionTimeTest
//
//  Created by Jakub Tudruj on 28/06/2018.
//  Copyright © 2018 Jakub Tudruj. All rights reserved.
//

import UIKit
import CommonCrypto

class ViewController: UIViewController {

    lazy var keyGenerator = KeyGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyGenerator.resetKeychain()
    }

   
    @IBAction func startTestButtonTapped(_ sender: Any) {
        let semaphore = DispatchSemaphore(value: 1)
        
        test(name: "RSA 1024") {
            self.keyGenerator.rsa(keyLength: .rsa1024)
            semaphore.signal()
        }
        
        semaphore.wait()
        test(name: "RSA 2048") {
            self.keyGenerator.rsa(keyLength: .rsa2048)
            semaphore.signal()
        }
        
        semaphore.wait()
        test(name: "RSA 4096") {
            self.keyGenerator.rsa(keyLength: .rsa4096)
            semaphore.signal()
        }
        
        semaphore.wait()
        test(name: "RSA 8192") {
            self.keyGenerator.rsa(keyLength: .rsa8192)
            semaphore.signal()
        }
        
        semaphore.wait()
        test(name: "RSA 15360") {
            self.keyGenerator.rsa(keyLength: .rsa15360)
            semaphore.signal()
        }
        
        semaphore.wait()
        test(name: "ECC 160") {
            self.keyGenerator.ecc(keyLength: .ecc160)
            semaphore.signal()
        }
        
        semaphore.wait()
        test(name: "ECC 224") {
            self.keyGenerator.ecc(keyLength: .ecc224)
            semaphore.signal()
        }
        
        semaphore.wait()
        test(name: "ECC 256") {
            self.keyGenerator.ecc(keyLength: .ecc256)
            semaphore.signal()
        }
        
        semaphore.wait()
        test(name: "ECC 384") {
            self.keyGenerator.ecc(keyLength: .ecc384)
            semaphore.signal()
        }
        
        semaphore.wait()
        test(name: "ECC 512") {
            self.keyGenerator.ecc(keyLength: .ecc512)
            semaphore.signal()
        }
        
        semaphore.wait()
        test(name: "AES 128") {
            self.keyGenerator.aes(keyLength: .aes128)
            semaphore.signal()
        }
        
        semaphore.wait()
        test(name: "AES 192") {
            self.keyGenerator.aes(keyLength: .aes192)
            semaphore.signal()
        }
        
        semaphore.wait()
        test(name: "AES 256") {
            self.keyGenerator.aes(keyLength: .aes256)
            semaphore.signal()
        }
    }
    
    
    func test(name: String, code: ()->()) {
        let startTime = Date()
        print("\n\n\nStarted test: ", name, " at time: ", startTime)
        code()
        let stopTime = Date()
        print("Stopped ad time: ", stopTime)
        let executionTime = stopTime.timeIntervalSince(startTime)
        print("Execution time: ", executionTime)
        print("seconds: ", executionTime.seconds)
        print("miliseconds: ", executionTime.miliseconds)
        print("##########################")
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
    
    func rsa(keyLength: RSA) {
        let parameters: [CFString : Any] = [
            kSecAttrKeyType : kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits : keyLength.rawValue
        ]
        key(parameters: parameters)
    }
    
    func ecc(keyLength: ECC) {
        let parameters: [CFString : Any] = [
            kSecAttrKeyType : kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeySizeInBits : keyLength.rawValue
        ]
        key(parameters: parameters)
    }
    
    func aes(keyLength: AES) {
        var bytes = [Int8](repeating: 0, count: keyLength.rawValue)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        if status == errSecSuccess {
            print("AES \(keyLength.rawValue):")
            print(bytes)
        } else {
            print("Error: ", status)
        }
    }
    
    private func key(parameters: [CFString : Any]) {
        var error: Unmanaged<CFError>?
        SecKeyCreateRandomKey(parameters as CFDictionary, &error)
        if let e = error {
            print("Error: ", e)
            print()
        }
    }
    
    func resetKeychain() {
        deleteAllKeysForSecClass(kSecClassGenericPassword)
        deleteAllKeysForSecClass(kSecClassInternetPassword)
        deleteAllKeysForSecClass(kSecClassCertificate)
        deleteAllKeysForSecClass(kSecClassKey)
        deleteAllKeysForSecClass(kSecClassIdentity)
    }
    
    func deleteAllKeysForSecClass(_ secClass: CFTypeRef) {
        let dict: [String : Any] = [kSecClass as String : secClass,]
        deleteKey(for: dict)
    }
    
    func deleteKey(for attributes: [String: Any]) {
        let result = SecItemDelete(attributes as CFDictionary)
        assert(result == noErr || result == errSecItemNotFound, "Error deleting keychain data (\(result))")
    }
}

extension TimeInterval {
    var miliseconds: Int64 {
        return Int64((self * 1000.0).rounded())
    }
    
    var seconds: Int64 {
        return Int64(self)
    }
}
