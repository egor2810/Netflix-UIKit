//
//  TitleCollectionViewCell.swift
//  Netflix UIKit
//
//  Created by Егор Аблогин on 21.04.2024.
//

import UIKit
import SDWebImage

final class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    
    private let posterImageView: UIImageView = {
       
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    func configure(with model: String) {
        guard let url = URL(string: "\(Constants.imageBaseURL)\(model)") 
        else {return}

        posterImageView.sd_setImage(with: url, completed: nil)
        
    }
}
