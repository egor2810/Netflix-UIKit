//
//  UpcomingTitleTableViewCell.swift
//  Netflix UIKit
//
//  Created by Егор Аблогин on 22.04.2024.
//

import UIKit
import SDWebImage

class UpcomingTitleTableViewCell: UITableViewCell {
    
    static let identifier = "UpcomingTitleCell"
    
    private let titlePosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "arrow.down.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titlePosterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playButton)
        contentView.addSubview(downloadButton)
        
    }
    
    override func layoutSubviews() {
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with title: Title) {
        
        guard let url = URL(string: "\(Constants.tmdbImageBaseUrl)\(title.poster_path ?? "")")
        else {return}
        titleLabel.text = title.name ?? title.title ?? "Unknown"
        
        titlePosterImageView.sd_setImage(with: url, completed: nil)
    }
    
    private func applyConstraints() {
        let titlePosterImageViewConstraints = [
            titlePosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            titlePosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titlePosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            titlePosterImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 100)
        ]
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: titlePosterImageView.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: 0)
        ]
        
        let playButtonConstraints = [
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            
        ]
        
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -30),
            downloadButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(titlePosterImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
}
