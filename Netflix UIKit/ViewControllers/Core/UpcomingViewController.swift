//
//  UpcomingViewController.swift
//  Netflix UIKit
//
//  Created by Егор Аблогин on 21.04.2024.
//

import UIKit

final class UpcomingViewController: UIViewController {

    private let sectionConst = Sections.upcomingMovies
    private var titles: [Title] = []
    
    
    private let upcomingTable: UITableView = {
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
        getUpcomingTitles()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = sectionConst.description
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupTableView() {
        view.addSubview(upcomingTable)
        
        
        upcomingTable.dataSource = self
        upcomingTable.delegate = self
    }
    
    private func getUpcomingTitles() {
        NetworkManager.shared.tmdbGetTrendingTitles(for: sectionConst) {[weak self] result in
            guard let self else {return}
            
            switch result {
            case .success(let titles):
                    self.titles = titles.results
                DispatchQueue.main.async {
                    self.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }            
        }
    }
    
}

// MARK: - UITableViewDataSource
extension UpcomingViewController: UITableViewDataSource {
    
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
extension UpcomingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
