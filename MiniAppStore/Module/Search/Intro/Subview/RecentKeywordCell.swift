//
//  RecentKeywordCell.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/01.
//

import UIKit
import SnapKit

final class RecentKeywordCell: UITableViewCell {
    
    static let identifier: String = "RecentKeywordCell"
    
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    private let viewSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ keyword: Keyword) {
        labelTitle.text = keyword.value
    }
    
    private func setupViews() {
        selectionStyle = .none

        [labelTitle, viewSeparator].forEach {
            contentView.addSubview($0)
        }
        
        labelTitle.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.centerY.equalToSuperview().offset(-0.5)
        }
        viewSeparator.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
}
