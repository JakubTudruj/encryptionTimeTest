//
//  EncryptionTestViewModel.swift
//  encryptionTimeTest
//
//  Created by Jakub Tudruj on 20/11/2018.
//  Copyright © 2018 Jakub Tudruj. All rights reserved.
//

import CommonCrypto
import Foundation

protocol EncryptionTestViewModelDelegate: class {
    func viewModelDidEndTest(with result: ResultEntity)
    func viewModelDidEndClearingResults()
    func viewModelDidEndAllTest()
}

class EncryptionTestViewModel {
    
    private(set) var results = [ResultEntity]()
    
    weak var delegate: EncryptionTestViewModelDelegate?
    
    private let keyGenerator = KeyGenerator()
    private let semaphore = DispatchSemaphore(value: 1)
    
    func runAllTests() {
        keyGenerator.resetKeychain()
        results = [ResultEntity]()
        delegate?.viewModelDidEndClearingResults()
        
        test(name: "RSA 1024") { [weak self] in
            try self?.keyGenerator.rsa(keyLength: .rsa1024)
        }
        
        test(name: "RSA 2048") { [weak self] in
            try self?.keyGenerator.rsa(keyLength: .rsa2048)
        }
        
        test(name: "RSA 4096") { [weak self] in
            try self?.keyGenerator.rsa(keyLength: .rsa4096)
        }

        test(name: "RSA 8192") { [weak self] in
            try self?.keyGenerator.rsa(keyLength: .rsa8192)
        }
        
        test(name: "RSA 15360") { [weak self] in
            try self?.keyGenerator.rsa(keyLength: .rsa15360)
        }
        
        test(name: "ECC 160") { [weak self] in
            try self?.keyGenerator.ecc(keyLength: .ecc160)
        }
        
        test(name: "ECC 224") { [weak self] in
            try self?.keyGenerator.ecc(keyLength: .ecc224)
        }
        
        test(name: "ECC 256") { [weak self] in
            try self?.keyGenerator.ecc(keyLength: .ecc256)
        }
        
        test(name: "ECC 384") { [weak self] in
            try self?.keyGenerator.ecc(keyLength: .ecc384)
        }
        
        test(name: "ECC 512") { [weak self] in
            try self?.keyGenerator.ecc(keyLength: .ecc512)
        }
        
        test(name: "AES 128") { [weak self] in
            try self?.keyGenerator.aes(keyLength: .aes128)
        }
        
        test(name: "AES 192") { [weak self] in
            try self?.keyGenerator.aes(keyLength: .aes192)
        }
        
        test(name: "AES 256") { [weak self] in
            try self?.keyGenerator.aes(keyLength: .aes256)
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.viewModelDidEndAllTest()
            }
        }
        
    }
    
    private func test(name: String, code: @escaping () throws -> ()) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.semaphore.wait()
            let result = self.execute(test: code, named: name)
            DispatchQueue.main.async { [weak self] in
                self?.results.append(result)
                self?.delegate?.viewModelDidEndTest(with: result)
            }
            self.semaphore.signal()
        }
    }
    
    private func execute(test: () throws -> (), named name: String) -> ResultEntity {
        let startTime = Date()
        var error: Error? = nil
        do {
            try test()
        } catch(let e) {
            error = e
        }
        let stopTime = Date()
        return ResultEntity(name: name, startTime: startTime, stopTime: stopTime, error: error)
    }
    
}
