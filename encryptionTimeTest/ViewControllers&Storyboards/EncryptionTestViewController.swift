//
//  EncryptionTestViewController.swift
//  encryptionTimeTest
//
//  Created by Jakub Tudruj on 28/06/2018.
//  Copyright © 2018 Jakub Tudruj. All rights reserved.
//

import UIKit
import CommonCrypto

class EncryptionTestViewController: UIViewController {

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
    
    
    func test(name: String, code: @escaping () throws -> ()) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            let result = self.execute(test: code, named: name)
            DispatchQueue.main.async { [weak self] in
                self?.handle(result: result)
            }
        }
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
