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
    private let asymmetricEncryptor = AsymmetricEncryptor()
    private let dataProvider = TestDataProvider()
    
    private let semaphore = DispatchSemaphore(value: 1)
    
    private var generatedAsymmetricKey: SecKey!
    private var generatedSymmetricKey: Data!
    
    func runAllTests() {
        keyGenerator.resetKeychain()
        results = [ResultEntity]()
        delegate?.viewModelDidEndClearingResults()
        runTests(count: 4)
    }
    
    func runTests(count: Int) {
        for i in 1...count {
            // MARK: - AES
            // MARK: 128
            test(name: "Generating AES 128") { [weak self] in
                self?.generatedSymmetricKey = try self?.keyGenerator.aes(keyLength: .aes128)
            }
            
            test(name: "AES 128: Encrypting small text") { [weak self] in
                guard let self = self else { return }
                SymmetricEncryptor(key: self.generatedSymmetricKey, iv: Data.random(length: 8))?.encrypt(string: self.dataProvider.text)
            }
            
            test(name: "AES 128: Encrypting long text") { [weak self] in
                guard let self = self else { return }
                SymmetricEncryptor(key: self.generatedSymmetricKey, iv: Data.random(length: 8))?.encrypt(string: self.dataProvider.longText)
            }
            
            test(name: "AES 128: Encrypting small image") { [weak self] in
                guard let self = self else { return }
                SymmetricEncryptor(key: self.generatedSymmetricKey, iv: Data.random(length: 8))?.encrypt(image: self.dataProvider.smallImage)
            }
            
            test(name: "AES 128: Encrypting large image") { [weak self] in
                guard let self = self else { return }
                SymmetricEncryptor(key: self.generatedSymmetricKey, iv: Data.random(length: 8))?.encrypt(image: self.dataProvider.largeImage)
            }
            
            // MARK: 192
            test(name: "Generating AES 192") { [weak self] in
                self?.generatedSymmetricKey = try self?.keyGenerator.aes(keyLength: .aes192)
            }
            
            test(name: "AES 192: Encrypting small text") { [weak self] in
                guard let self = self else { return }
                SymmetricEncryptor(key: self.generatedSymmetricKey, iv: Data.random(length: 8))?.encrypt(string: self.dataProvider.text)
            }
            
            test(name: "AES 192: Encrypting long text") { [weak self] in
                guard let self = self else { return }
                SymmetricEncryptor(key: self.generatedSymmetricKey, iv: Data.random(length: 8))?.encrypt(string: self.dataProvider.longText)
            }
            
            test(name: "AES 192: Encrypting small image") { [weak self] in
                guard let self = self else { return }
                SymmetricEncryptor(key: self.generatedSymmetricKey, iv: Data.random(length: 8))?.encrypt(image: self.dataProvider.smallImage)
            }
            
            test(name: "AES 192: Encrypting large image") { [weak self] in
                guard let self = self else { return }
                SymmetricEncryptor(key: self.generatedSymmetricKey, iv: Data.random(length: 8))?.encrypt(image: self.dataProvider.largeImage)
            }
            
            // MARK: 256
            test(name: "Generating AES 256") { [weak self] in
                self?.generatedSymmetricKey = try self?.keyGenerator.aes(keyLength: .aes256)
            }
            
            test(name: "AES 256: Encrypting small text") { [weak self] in
                guard let self = self else { return }
                SymmetricEncryptor(key: self.generatedSymmetricKey, iv: Data.random(length: 8))?.encrypt(string: self.dataProvider.text)
            }
            
            test(name: "AES 256: Encrypting long text") { [weak self] in
                guard let self = self else { return }
                SymmetricEncryptor(key: self.generatedSymmetricKey, iv: Data.random(length: 8))?.encrypt(string: self.dataProvider.longText)
            }
            
            test(name: "AES 256: Encrypting small image") { [weak self] in
                guard let self = self else { return }
                SymmetricEncryptor(key: self.generatedSymmetricKey, iv: Data.random(length: 8))?.encrypt(image: self.dataProvider.smallImage)
            }
            
            test(name: "AES 256: Encrypting large image") { [weak self] in
                guard let self = self else { return }
                SymmetricEncryptor(key: self.generatedSymmetricKey, iv: Data.random(length: 8))?.encrypt(image: self.dataProvider.largeImage)
            }
            
            // generating aes 128 for asymmetric tests below
            generatedSymmetricKey = try! keyGenerator.aes(keyLength: .aes128)
            
            // MARK: - RSA
            // MARK: 1024
            test(name: "Generating RSA 1024") { [weak self] in
                self?.generatedAsymmetricKey = try self?.keyGenerator.rsa(keyLength: .rsa1024)
            }
            
            test(name: "Encrypting using RSA 1024") { [weak self] in
                guard let self = self else { return }
                self.asymmetricEncryptor.encrypt(data: self.generatedSymmetricKey as CFData, using: .rsaEncryptionRaw, with: self.generatedAsymmetricKey)
            }
            
            // MARK: 2048
            test(name: "Generating RSA 2048") { [weak self] in
                self?.generatedAsymmetricKey = try self?.keyGenerator.rsa(keyLength: .rsa2048)
            }
            
            test(name: "Encrypting using RSA 2048") { [weak self] in
                guard let self = self else { return }
                self.asymmetricEncryptor.encrypt(data: self.generatedSymmetricKey as CFData, using: .rsaEncryptionRaw, with: self.generatedAsymmetricKey)
            }
            
            // MARK: 4096
            test(name: "Generating RSA 4096") { [weak self] in
                self?.generatedAsymmetricKey = try self?.keyGenerator.rsa(keyLength: .rsa4096)
            }
            
            test(name: "Encrypting using RSA 4096") { [weak self] in
                guard let self = self else { return }
                self.asymmetricEncryptor.encrypt(data: self.generatedSymmetricKey as CFData, using: .rsaEncryptionRaw, with: self.generatedAsymmetricKey)
            }
            
            // MARK: 8192
            test(name: "Generating RSA 8192") { [weak self] in
                self?.generatedAsymmetricKey = try self?.keyGenerator.rsa(keyLength: .rsa8192)
            }
            
            test(name: "Encrypting using RSA 8192") { [weak self] in
                guard let self = self else { return }
                self.asymmetricEncryptor.encrypt(data: self.generatedSymmetricKey as CFData, using: .rsaEncryptionRaw, with: self.generatedAsymmetricKey)
            }
            
            // MARK: 15360
            test(name: "Generating RSA 15360") { [weak self] in
                self?.generatedAsymmetricKey = try self?.keyGenerator.rsa(keyLength: .rsa15360)
            }
            
            /*no encrypting test - generating RSA 15360 failure*/
            
            // MARK: - ECC
            // MARK: 160
            test(name: "Generating ECC 160") { [weak self] in
                self?.generatedAsymmetricKey = try self?.keyGenerator.ecc(keyLength: .ecc160)
            }
            
            /*no encrypting test - generating ECC 512 failure*/
            
            // MARK: 224
            test(name: "Generating ECC 224") { [weak self] in
                self?.generatedAsymmetricKey = try self?.keyGenerator.ecc(keyLength: .ecc224)
            }
            
            test(name: "Encrypting using ECC 224") { [weak self] in
                guard let self = self else { return }
                self.asymmetricEncryptor.encrypt(data: self.generatedSymmetricKey as CFData, using: .rsaEncryptionRaw, with: self.generatedAsymmetricKey)
            }
            
            // MARK: 256
            test(name: "Generating ECC 256") { [weak self] in
                self?.generatedAsymmetricKey = try self?.keyGenerator.ecc(keyLength: .ecc256)
            }
            
            test(name: "Encrypting using ECC 256") { [weak self] in
                guard let self = self else { return }
                self.asymmetricEncryptor.encrypt(data: self.generatedSymmetricKey as CFData, using: .rsaEncryptionRaw, with: self.generatedAsymmetricKey)
            }
            
            // MARK: 512
            test(name: "Generating ECC 512") { [weak self] in
                self?.generatedAsymmetricKey = try self?.keyGenerator.ecc(keyLength: .ecc512)
            }
            
            /*no encrypting test - generating ECC 512 failure*/
            
            // MARK: 384
            test(name: "Generating ECC 384") { [weak self] in
                self?.generatedAsymmetricKey = try self?.keyGenerator.ecc(keyLength: .ecc384)
            }
            
            test(name: "Encrypting using ECC 384") { [weak self] in
                guard let self = self else { return }
                self.asymmetricEncryptor.encrypt(data: self.generatedSymmetricKey as CFData, using: .rsaEncryptionRaw, with: self.generatedAsymmetricKey)
                if i == count {
                    self.endTests()
                }
            }
        }
    }
    
    private func endTests() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let sortedResults = self.results.sorted { $0.name < $1.name }
            self.delegate?.viewModelDidEndAllTest()
            print(sortedResults.csvText)
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
