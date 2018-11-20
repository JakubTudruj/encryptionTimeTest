//
//  EncryptionTestViewController.swift
//  encryptionTimeTest
//
//  Created by Jakub Tudruj on 28/06/2018.
//  Copyright © 2018 Jakub Tudruj. All rights reserved.
//

import UIKit

class EncryptionTestViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var startTestButton: UIButton!
    
    private let viewModel = EncryptionTestViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupActivityIndicator()
        viewModel.delegate = self
    }

    private func setupTableView() {
        tableView.estimatedRowHeight = 185.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    private func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
    }
    
    @IBAction private func startTestButtonTapped(_ sender: Any) {
        activityIndicator.startAnimating()
        startTestButton.isEnabled = false
        viewModel.runAllTests()
    }
    
}

extension EncryptionTestViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EncryptionTestTableViewCell", for: indexPath) as? EncryptionTestTableViewCell ?? EncryptionTestTableViewCell()
        cell.entity = viewModel.results[indexPath.row]
        cell.setNeedsLayout()
        cell.updateConstraints()
        return cell
    }

}

extension EncryptionTestViewController: EncryptionTestViewModelDelegate {
    
    func viewModelDidEndAllTest() {
        activityIndicator.stopAnimating()
        startTestButton.isEnabled = true
        tableView.layoutSubviews()
    }
    
    func viewModelDidEndClearingResults() {
        tableView.reloadData()
        tableView.layoutSubviews()
    }
    
    func viewModelDidEndTest(with result: ResultEntity) {
        let indexPath = IndexPath(row: viewModel.results.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .right)
        print(result)
    }

}
