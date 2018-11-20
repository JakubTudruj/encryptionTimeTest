//
//  EncryptionTestViewController.swift
//  encryptionTimeTest
//
//  Created by Jakub Tudruj on 28/06/2018.
//  Copyright © 2018 Jakub Tudruj. All rights reserved.
//

import UIKit

class EncryptionTestViewController: UIViewController {

    let viewModel = EncryptionTestViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }

    @IBAction func startTestButtonTapped(_ sender: Any) {
        viewModel.runAllTests()
    }
    
}

extension EncryptionTestViewController: EncryptionTestViewModelDelegate {
    
    func viewModelDidEndTest(with result: ResultEntity) {
        var text = "\nStarted test: \(result.name) at time: \(result.startTime)"
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
        print(text)
    }

}
