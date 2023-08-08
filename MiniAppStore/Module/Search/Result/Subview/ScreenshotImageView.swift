//
//  ScreenshotImageView.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/02.
//

import UIKit
import SDWebImage

final class ScreenshotImageView: UIImageView {
    
    static let ratio: CGFloat = 20 / 11
    
    init(url: URL) {
        super.init(frame: .zero)
        sd_setImage(with: url)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.cornerRadius = 12
        layer.borderColor = UIColor.systemGray3.cgColor
        layer.borderWidth = 1
        layer.masksToBounds = true
        
        clipsToBounds = true
        contentMode = .scaleAspectFill
    }
    
}
