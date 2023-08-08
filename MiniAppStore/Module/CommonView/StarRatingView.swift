//
//  StarRatingView.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/03.
//

import UIKit

final class StarRatingView: UIView {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let imageFill = UIImage(systemName: "star.fill")?
        .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
    private let imageHalf = UIImage(systemName: "star.leadinghalf.fill")?
        .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
    private let imageEmpty = UIImage(systemName: "star")?
        .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
    private let maxRating: Int = 5
    
    init() {
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with value: Double) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for rating in (1...maxRating) {
            let imageView = UIImageView()
            stackView.addArrangedSubview(imageView)
            
            if value >= CGFloat(rating) {
                imageView.image = imageFill
            } else if value <= CGFloat(rating - 1) {
                imageView.image = imageEmpty
            } else {
                imageView.image = imageHalf
            }
        }
    }
    
    private func setupViews() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
