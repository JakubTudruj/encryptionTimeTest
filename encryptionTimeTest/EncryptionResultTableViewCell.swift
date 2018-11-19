//
//  EncryptionResultTableViewCell.swift
//  encryptionTimeTest
//
//  Created by Jakub Tudruj on 19/11/2018.
//  Copyright © 2018 Jakub Tudruj. All rights reserved.
//

import UIKit

struct ResultEntity {
    let algorithmName: String
    let operationType: String
    let startTime: Date
    let stopDate: Date
    let operationTime: TimeInterval
    let error: String?
}

class EncryptionResultTableViewCell: UITableViewCell {

    @IBOutlet private weak var algorithmNameLabel: UILabel!
    @IBOutlet private weak var operationTypeLabel: UILabel!
    @IBOutlet private weak var startTimeLabel: UILabel!
    @IBOutlet private weak var stopTimeLabel: UILabel!
    @IBOutlet private weak var operationTimeLabel: UILabel!
    @IBOutlet private weak var errorLabel: UILabel!
    
    @IBOutlet private weak var algorithmStackView: UIStackView!
    @IBOutlet private weak var operationStackView: UIStackView!
    @IBOutlet private weak var startTimeStackView: UIStackView!
    @IBOutlet private weak var stopTimeStackView: UIStackView!
    @IBOutlet private weak var operationTimeStackView: UIStackView!
    
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    var resultEntity: ResultEntity? {
        didSet {
            setupCell()
        }
    }

    private func setupCell() {
        guard let entity = resultEntity else {
            loadingIndicator.startAnimating()
            return
        }
        loadingIndicator.stopAnimating()
        algorithmNameLabel.text = entity.algorithmName
        operationTypeLabel.text = entity.operationType
        startTimeLabel.text = "\(entity.startTime)"
        stopTimeLabel.text = "\(entity.stopDate)"
        operationTimeLabel.text = "\(entity.operationTime.seconds)s \(entity.operationTime.miliseconds)ms"
        errorLabel.text = entity.error
        setupStackViews()
    }

    func setupStackViews() {
        guard let entity = resultEntity else {
            return
        }
        if entity.error != nil {
            algorithmStackView.isHidden = true
            operationStackView.isHidden = true
            startTimeStackView.isHidden = true
            stopTimeStackView.isHidden = true
            operationTimeStackView.isHidden = true
            errorLabel.isHidden = false
        } else {
            algorithmStackView.isHidden = false
            operationStackView.isHidden = false
            startTimeStackView.isHidden = false
            stopTimeStackView.isHidden = false
            operationTimeStackView.isHidden = false
            errorLabel.isHidden = true
        }
    }
    
}
