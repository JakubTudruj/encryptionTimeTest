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
    @IBOutlet private weak var stackView: UIStackView!
    
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
        let resultSymbol = entity.error == nil ? "✅" : "‼️"
        testNameLabel.text = "\(resultSymbol) \(entity.name)"
    }
    
    private func setupTimeLabel(with entity: ResultEntity) {
        guard entity.error == nil else {
            timeLabel.isHidden = true
            return
        }
        timeLabel.isHidden = false
        let miliseconds = entity.executionTime.miliseconds == 0 ? "< 1ms" : "\(entity.executionTime.miliseconds)ms"
        timeLabel.text = "\(entity.executionTime.seconds)s (\(miliseconds))"
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
