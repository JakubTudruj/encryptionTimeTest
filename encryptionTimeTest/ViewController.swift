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

    @IBOutlet weak var textView: UITextView!
    let keyGenerator = KeyGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyGenerator.resetKeychain()
        textView.text = nil
    }

   
    @IBAction func startTestButtonTapped(_ sender: Any) {
        textView.text = nil
        test(name: "RSA 1024") {
            try self.keyGenerator.rsa(keyLength: .rsa1024)
        }
        
        test(name: "RSA 2048") {
            try self.keyGenerator.rsa(keyLength: .rsa2048)
        }
        
        test(name: "RSA 4096") {
            try self.keyGenerator.rsa(keyLength: .rsa4096)
        }
        
//        test(name: "RSA 8192") {
//            try self.keyGenerator.rsa(keyLength: .rsa8192)
//        }
        
        test(name: "RSA 15360") {
            try self.keyGenerator.rsa(keyLength: .rsa15360)
        }
        
        test(name: "ECC 160") {
            try self.keyGenerator.ecc(keyLength: .ecc160)
        }
        
        test(name: "ECC 224") {
            try self.keyGenerator.ecc(keyLength: .ecc224)
        }
        
        test(name: "ECC 256") {
            try self.keyGenerator.ecc(keyLength: .ecc256)
        }
        
        test(name: "ECC 384") {
            try self.keyGenerator.ecc(keyLength: .ecc384)
        }
        
        test(name: "ECC 512") {
            try self.keyGenerator.ecc(keyLength: .ecc512)
        }
        
        test(name: "AES 128") {
            try self.keyGenerator.aes(keyLength: .aes128)
        }
        
        test(name: "AES 192") {
            try self.keyGenerator.aes(keyLength: .aes192)
        }
        
        test(name: "AES 256") {
            try self.keyGenerator.aes(keyLength: .aes256)
        }
    }
    
    
    func test(name: String, code: () throws -> ()) {
        let result = execute(test: code, named: name)
        handle(result: result)
    }
    
    private func execute(test: () throws -> (), named name: String) -> ResultEntity {
        let startTime = Date()
        let error: Error?
        do {
            try test()
            error = nil
        } catch(let e) {
            error = e
        }
        let stopTime = Date()
        return ResultEntity(name: name, startTime: startTime, stopTime: stopTime, error: error)
    }
    
    private func handle(result: ResultEntity) {
        var text = "\nStarted test: \(result.name) at time: \(result.startTime)"
        print(text)
        text += "\nStopped ad time: \(result.stopTime)\n"
        if let error = result.error {
            text += "****"
            text += "\nTestu failure. Error: \(error.localizedDescription)\n"
            text += "****"
        } else {
            text += "\nExecution time: \(result.executionTime.timeInterval)"
            text += "\nseconds: \(result.executionTime.seconds)"
            text += "\nmiliseconds: \(result.executionTime.miliseconds)"
        }
        text += "\n##########################\n\n\n"
        textView.text += text
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
    
    enum AESError: LocalizedError {
        case secRandomCopyBytes(OSStatus)
        
        var errorDescription: String? {
            switch self {
            case .secRandomCopyBytes(let code):
                return "AES generating error. OSStatus: \(code)"
            }
        }
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
