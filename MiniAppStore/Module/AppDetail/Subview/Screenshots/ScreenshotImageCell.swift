//
//  ScreenshotImageCell.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/03.
//

import UIKit
import SDWebImage

final class ScreenshotImageCell: UICollectionViewCell {
    
    static let identifier: String = "ScreenshotImageCell"
    static let ratio: CGFloat = 20 / 11
    
    static func size(with availableWidth: CGFloat) -> CGSize {
        let inset: CGFloat = 16
        let spacing: CGFloat = 8
        let width = (availableWidth - inset - spacing) / 1.6
        let height = width * ratio
        return .init(width: width, height: height)
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.borderColor = UIColor.systemGray3.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with url: URL) {
        imageView.sd_setImage(with: url)
    }
    
    private func setupView() {
        contentView.backgroundColor = .white
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
