//
//  HomeViewController.swift
//  Netflix UIKit
//
//  Created by Егор Аблогин on 21.04.2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    let sectionTitles = [
        "Trending Movies",
        "Trending TV",
        "Popular",
        "Upcoming movies",
        "Top rated"
    ]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.register(
            CollectionViewTableViewCell.self,
            forCellReuseIdentifier: CollectionViewTableViewCell.identifier
        )
        
        
        return table
    }()

    // MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self

        configureNavBar()
        
        let headerView = HeroHeaderUIView(
            frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 459)
        )
        
        homeFeedTable.tableHeaderView = headerView
        getTrendingTitle()
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    // MARK: - Configure UI
    private func configureNavBar() {
        var image = UIImage(named: "logo")
        image = image?.withRenderingMode(.alwaysOriginal)
  
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: image, style: .done, target: self, action: nil
        )
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .label
    }

    // MARK: - getTrendingMovies
    private func getTrendingTitle() {
        NetworkManager.shared.fetchTrendingMovies { result in
            switch result {
                case .success(let movies):
                    print(movies)
                case .failure(let failure):
                    print(failure.localizedDescription)
            }
        }
    }

}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CollectionViewTableViewCell.identifier,
            for: indexPath
        ) as? CollectionViewTableViewCell
        else { return UITableViewCell() }
        
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 40))
        header.backgroundColor = .clear
        // Создаем и настраиваем UILabel
        let label = UILabel()
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = sectionTitles[section].capitalizeFirstLetter()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        
        header.addSubview(label)
        
        // Устанавливаем констрейнты для отступов
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16), // Отступ слева
            label.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -8),   // Отступ снизу
            label.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -16) // Отступ справа, если нужно
        ])
        
        return header
    }

}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionTitles.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset

        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
}
