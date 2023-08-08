//
//  RecentKeywordHeader.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/01.
//

import UIKit
import SnapKit

final class RecentKeywordHeader: UITableViewHeaderFooterView {
    
    static let identifier: String = "RecentKeywordHeader"
    static let height: CGFloat = 48
    
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어"
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(labelTitle)
        labelTitle.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.centerY.equalToSuperview()
        }
    }
    
}
