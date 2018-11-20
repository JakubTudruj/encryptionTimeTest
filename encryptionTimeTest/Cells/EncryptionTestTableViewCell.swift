//
//  EncryptionTestTableViewCell.swift
//  encryptionTimeTest
//
//  Created by Jakub Tudruj on 20/11/2018.
//  Copyright © 2018 Jakub Tudruj. All rights reserved.
//

import UIKit

class EncryptionTestTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var testNameLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var errorLabel: UILabel!
    
    var entity: ResultEntity? {
        didSet {
            setupCell()
        }
    }
    
    private func setupCell() {
        guard let entity = entity else { return }
        setupNameLabel(with: entity)
        setupTimeLabel(with: entity)
        setupErrorLabel(with: entity)
    }
    
    private func setupNameLabel(with entity: ResultEntity) {
        let resultSymbol = entity.error != nil ? "✅" : "‼️"
        testNameLabel.text = "\(resultSymbol) \(entity.name)"
    }
    
    private func setupTimeLabel(with entity: ResultEntity) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss"
        let startTime = formatter.string(from: entity.startTime)
        let stopTime = formatter.string(from: entity.stopTime)
        var executionTime = ""
        if entity.executionTime.timeInterval > 0.01 {
            executionTime = "\(entity.executionTime.seconds)s"
            executionTime += " \(entity.executionTime.miliseconds)ms"
        } else {
            executionTime = "\(entity.executionTime.timeInterval)s"
        }
        timeLabel.text = "\(startTime) - \(stopTime) (\(executionTime))"
    }
    
    private func setupErrorLabel(with entity: ResultEntity) {
        if let error = entity.error {
            errorLabel.isHidden = false
            errorLabel.text = "Error: \(error.localizedDescription)"
        } else {
            errorLabel.text = nil
            errorLabel.isHidden = true
        }
    }

}
