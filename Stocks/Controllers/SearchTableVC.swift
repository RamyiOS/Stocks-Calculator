//
//  SearchTableVC.swift
//  Stocks
//
//  Created by Mac on 6/25/22.
//  Copyright © 2022 ramy. All rights reserved.
//

import UIKit
import Combine
import MBProgressHUD

class SearchTableVC: UITableViewController, UIAnimatable {
    
    private enum Mode {
        case onboarding
        case search
    }
    
    private var stocksResults: StocksResults?
    private let networkManager = NetworkManager()
    /// Search Observer
    private var subscribers = Set<AnyCancellable>()
    @Published private var searchQuery = String()
    @Published private var mode: Mode = .onboarding
    
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.tintColor = .systemGreen
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Placeholder.searchBarPlaceholder
        searchController.searchBar.autocapitalizationType = .allCharacters
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configer()
        configerNavBar()
        observe()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifier.claculatoerSegue,
            let destination = segue.destination as? CalculatorTableVC,
            let asset = sender as? Asset {
            destination.asset = asset
        }
    }
    
    
    private func configerNavBar() {
        navigationItem.searchController = searchController
        navigationItem.title = Title.search
    }
    
    /// Combining
    private func configer() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 140
    }
    
    private func observeSearchQuery() {
        $searchQuery.debounce(for: .milliseconds(600), scheduler: RunLoop.main).sink { [weak self] searchQuery in
            guard let self = self, !searchQuery.isEmpty else { return }
            self.showLoadingAnimation()
            self.networkManager.fetchPublisher(keywords: searchQuery).sink(receiveCompletion: { completion in
                self.hideLoadingAnimation()
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { (stocksResults) in
                self.stocksResults = stocksResults
                self.tableView.reloadData()
            }).store(in: &self.subscribers)
        }.store(in: &subscribers)
    }
    
    private func observeMode() {
        $mode.sink { (mode) in
            switch mode {
            case .onboarding:
                self.tableView.backgroundView = EmptyStatment()
            case .search:
                self.tableView.backgroundView = nil
            }
        }.store(in: &subscribers)
    }
    
    private func observe() {
        self.observeSearchQuery()
        self.observeMode()
    }
    
    private func handleSelection(for symbol: String, stocksResult: StocksResult) {
        showLoadingAnimation()
        networkManager.fetchTimeSeriesMonthlyAdjustedPublisher(keywords: symbol).sink(receiveCompletion: { [weak self] (completionResult) in
            guard let self = self else { return }
            self.hideLoadingAnimation()
            
            switch completionResult {
            case .failure(let error):
                print(error)
            case .finished: break
            }
            }, receiveValue: { [weak self] (timeSeriesMonthlyAdjusted) in
                guard let self = self else { return }
                self.hideLoadingAnimation()
                
                let asset = Asset(stocksResult: stocksResult, timeSeriesMonthlyAdjusted: timeSeriesMonthlyAdjusted)
                self.performSegue(withIdentifier: Identifier.claculatoerSegue, sender: asset)
                self.searchController.searchBar.text = nil
        }).store(in: &subscribers)
    }
}

/// Configer searchController
extension SearchTableVC: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text, !searchQuery.isEmpty else {
            
            return }
        self.searchQuery = searchQuery
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        mode = .onboarding
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        mode = .search
    }
}

/// Configer tableView
extension SearchTableVC {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.stockCellId, for: indexPath) as! StocksCell
        
        if let stocksResults = self.stocksResults {
            let stocksResult = stocksResults.item[indexPath.row]
            cell.configer(stocksResult: stocksResult)
            cell.layoutCell()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocksResults?.item.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let stocksResults = self.stocksResults {
            let stocksResult = stocksResults.item[indexPath.item]
            let symbol = stocksResult.symbol
            handleSelection(for: symbol, stocksResult: stocksResult)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
