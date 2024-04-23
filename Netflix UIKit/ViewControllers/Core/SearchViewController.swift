//
//  SearchViewController.swift
//  Netflix UIKit
//
//  Created by Егор Аблогин on 21.04.2024.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private var titles: [Title] = []
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search"
        controller.searchBar.searchBarStyle = .minimal
        
        return controller
    }()
    
    private let searchTable: UITableView = {
        let table = UITableView()
        
        table.register(
            UpcomingTitleTableViewCell.self,
            forCellReuseIdentifier: UpcomingTitleTableViewCell.identifier
        )
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTableView()
        getDiscoverTitles()
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTable.frame = view.bounds
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Search"
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupTableView() {
        view.addSubview(searchTable)
        
        
        searchTable.dataSource = self
        searchTable.delegate = self
        
        navigationItem.searchController = searchController
    }
    
    private func getDiscoverTitles() {
        NetworkManager.shared.tmdbDiscoverTitles {[weak self] result in
            guard let self else {return}
            
            switch result {
            case .success(let titles):
                    self.titles = titles.results
                    DispatchQueue.main.async {
                        self.searchTable.reloadData()
                    }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    

}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UpcomingTitleTableViewCell.identifier,
            for: indexPath
        ) as? UpcomingTitleTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.configure(with: titles[indexPath.row])
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultViewController
                
        else { return }
            
        NetworkManager.shared.tmdbSearchTitles(query: query) { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let movies):
                        resultsController.titles = movies.results
                        resultsController.searchResultsCollectionView.reloadData()
                    case .failure(let failure):
                        print(failure.localizedDescription)
                }
                
            }
        }
    }
}
