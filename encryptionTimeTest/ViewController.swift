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
            return self.keyGenerator.rsa(keyLength: .rsa1024)
        }
        
        test(name: "RSA 2048") {
            return self.keyGenerator.rsa(keyLength: .rsa2048)
        }
        
        test(name: "RSA 4096") {
            return self.keyGenerator.rsa(keyLength: .rsa4096)
        }
        
        test(name: "RSA 8192") {
            return self.keyGenerator.rsa(keyLength: .rsa8192)
        }
        
        test(name: "RSA 15360") {
            return self.keyGenerator.rsa(keyLength: .rsa15360)
        }
        
        test(name: "ECC 160") {
            return self.keyGenerator.ecc(keyLength: .ecc160)
        }
        
        test(name: "ECC 224") {
            return self.keyGenerator.ecc(keyLength: .ecc224)
        }
        
        test(name: "ECC 256") {
            return self.keyGenerator.ecc(keyLength: .ecc256)
        }
        
        test(name: "ECC 384") {
            return self.keyGenerator.ecc(keyLength: .ecc384)
        }
        
        test(name: "ECC 512") {
            return self.keyGenerator.ecc(keyLength: .ecc512)
        }
        
        test(name: "AES 128") {
            return self.keyGenerator.aes(keyLength: .aes128)
        }
        
        test(name: "AES 192") {
            return self.keyGenerator.aes(keyLength: .aes192)
        }
        
        test(name: "AES 256") {
            return self.keyGenerator.aes(keyLength: .aes256)
        }
    }
    
    
    func test(name: String, code: ()->(String?)) {
        
        let startTime = Date()
        let startText = "\nStarted test: \(name) at time: \(startTime)"
        print(startText)
        textView.text += startText
        if let error = code() {
            textView.text += error
        }
        let stopTime = Date()
        var text = "\nStopped ad time: \(stopTime)\n"
        let executionTime = stopTime.timeIntervalSince(startTime)
        text += "Execution time: \(executionTime)\n"
        text += "seconds: \(executionTime.seconds)\n"
        text += "miliseconds: \(executionTime.miliseconds)\n"
        text += "##########################\n\n\n"
        print(text)
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
    
    func rsa(keyLength: RSA) -> String? {
        let parameters: [CFString : Any] = [
            kSecAttrKeyType : kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits : keyLength.rawValue
        ]
        return key(parameters: parameters)
    }
    
    func ecc(keyLength: ECC) -> String? {
        let parameters: [CFString : Any] = [
            kSecAttrKeyType : kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeySizeInBits : keyLength.rawValue
        ]
        return key(parameters: parameters)
    }
    
    func aes(keyLength: AES) -> String? {
        var bytes = [Int8](repeating: 0, count: keyLength.rawValue)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        if status == errSecSuccess {
            print("AES \(keyLength.rawValue):")
            print(bytes)
            return nil
        } else {
            print("Error: ", status)
            return "Error: \(status)"
        }
    }
    
    private func key(parameters: [CFString : Any]) -> String? {
        var error: Unmanaged<CFError>?
        SecKeyCreateRandomKey(parameters as CFDictionary, &error)
        if let e = error {
            print("Error: ", e)
            return "Error: \(e)"
        } else {
            return nil
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
