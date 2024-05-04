//
//  TitlePreviewViewController.swift
//  Netflix UIKit
//
//  Created by Егор Аблогин on 30.04.2024.
//

import UIKit
import WebKit

final class TitlePreviewViewController: UIViewController {
    
    var titleItem: Title?
    var titleYTLinks: [String] = []
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = titleItem?.titleName ?? "unknownqew qweqwe qweqweqweqe"
        label.numberOfLines = 0
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back", for: .normal)
        return button
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupSubviews()
        setupConstraints()
        
        toggleNavigationBar()
        
        getYTLinks()
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
        toggleNavigationBar()
    }
    
    private func setupSubviews() {
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        
        view.addSubview(webView)
        webView.backgroundColor = .red
    }
    
    private func setupConstraints() {
        let backButtonConstraints = [
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 50)
        ]
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: backButton.topAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor)
        ]
        
        let webViewConstraints = [
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            webView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        NSLayoutConstraint.activate(backButtonConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(webViewConstraints)
        
        
    }
 
    // MARK: - get youtube information
    private func getYTLinks() {
        guard let titleItem,
              let titleName = titleItem.name ?? titleItem.title
        else {return}
        
        NetworkManager.shared.ytGetMovie(query: titleName + " trailer") {[weak self] result in
            guard let self else { return }
            switch result {
                case .success(let result):
                    self.titleYTLinks = result.items.map {$0.id.videoId }
                    DispatchQueue.main.async {
                        self.configureWebView(with: self.titleYTLinks[0])
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    private func toggleNavigationBar() {
        navigationController?.navigationBar.isHidden.toggle()
        navigationController?.navigationBar.backItem?.hidesBackButton.toggle()
    }
    
    private func configureWebView(with trailer: String) {
        guard let url = URL(string: "https://www.youtube.com/embed/\(trailer)") else { return }
        
        webView.load(URLRequest(url: url))
    }
}

#Preview("TitlePreviewViewController") {
    TitlePreviewViewController()
}
