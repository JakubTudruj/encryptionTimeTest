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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

   
    @IBAction func startTestButtonTapped(_ sender: Any) {
        let semaphore = DispatchSemaphore(value: 1)
        
        test(name: "RSA 1024") {
            KeyGenerator().rsa(keyLength: .rsa1024)
        }
        
        test(name: "RSA 2048") {
            KeyGenerator().rsa(keyLength: .rsa2048)
        }
        
        test(name: "RSA 4096") {
            KeyGenerator().rsa(keyLength: .rsa4096)
        }
        
        test(name: "RSA 8192") {
            KeyGenerator().rsa(keyLength: .rsa8192)
        }
        
        test(name: "RSA 15360") {
            KeyGenerator().rsa(keyLength: .rsa15360)
        }
        
        test(name: "ECC 160") {
            KeyGenerator().ecc(keyLength: .ecc160)
        }
        
        test(name: "ECC 224") {
            KeyGenerator().ecc(keyLength: .ecc224)
        }
        
        test(name: "ECC 256") {
            KeyGenerator().ecc(keyLength: .ecc256)
        }
        
        test(name: "ECC 384") {
            KeyGenerator().ecc(keyLength: .ecc384)
        }
        
        test(name: "ECC 512") {
            KeyGenerator().ecc(keyLength: .ecc512)
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
        }
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

extension TimeInterval {
    var miliseconds: Int64 {
        return Int64((self * 1000.0).rounded())
    }
    
    var seconds: Int64 {
        return Int64(self)
    }
}
