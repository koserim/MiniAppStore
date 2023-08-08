//
//  EmptyCell.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/03.
//

import UIKit

final class EmptyCell: UITableViewCell {

    static let identifier: String = "EmptyCell"
    static let height: CGFloat = 200
    
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
        label.text = "검색 결과가 없습니다."
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        labelTitle.text = title
    }
    
    private func setupViews() {
        selectionStyle = .none
        
        contentView.addSubview(labelTitle)
        labelTitle.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}
