//
//  ViewController.swift
//  DogProject
//
//  Created by Vijay Adhikari on 18/9/21.
//

import UIKit
import Foundation


class ViewController: UIViewController {

    private var viewModel:DogResultViewModel!
    @IBOutlet weak var dogTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DogResultViewModel()
        viewModel.delegate = self
        viewModel.fetchItems()
    }
}

// MARK: - Handle navigation item click events - Refresh and sorting
extension ViewController {
    @IBAction func refreshDogList(_ sender: Any) {
        viewModel.fetchItems()
    }
    
    @IBAction func changeOrder(_ sender: UISegmentedControl) {
        sender.selectedSegmentIndex == 0
            ? self.viewModel.sort(by: DogResultViewModel.SortByLifeSpan.ascending)
            : self.viewModel.sort(by: DogResultViewModel.SortByLifeSpan.descending)
    }
}

// MARK: - UITableView Datasource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dogTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DogListCell
        let item = viewModel.items[indexPath.row]
        cell.configureDogCell(with: item)
        return cell
    }
    
}

// MARK: - Implementation of  DogApiViewModelDelegate - Reload , Error, Loading Indicator
extension ViewController: DogApiViewModelDelegate {
    func reloadData() {
        dogTableView.reloadData()
        let indexPath = IndexPath(row: 0, section: 0)
        self.dogTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    func showError(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func isLoading(status: Bool) {
        status ? showCustomSpinner() : hideSpinner()
    }
}

// MARK: - Custom Spinner
extension ViewController {
    func hideSpinner() {
        DispatchQueue.main.async {
            let customSpinner = LoadingSpinner()
            customSpinner.hideIndicator(spinnerView: self.view)
        }
    }
    
    func showCustomSpinner() {
        DispatchQueue.main.async {
            let customSpinner = LoadingSpinner()
            customSpinner.showIndicator(spinnerView:self.view, withTitle:"Please wait..")
        }
    }
}
