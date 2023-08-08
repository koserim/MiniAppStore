//
//  MatchedKeywordCell.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/02.
//

import UIKit
import SnapKit

final class MatchedKeywordCell: UITableViewCell {

    static let identifier: String = "MatchedKeywordCell"
    static let height: CGFloat = 42
    
    private let imageViewTitle: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .init(systemName: "magnifyingglass")?
        return imageView
    }()
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
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
    
    func configure(_ keyword: Keyword, isFirst: Bool = false) {
        labelTitle.text = keyword.value
        viewSeparator.isHidden = isFirst
    }
    
    private func setupViews() {
        selectionStyle = .none

        [imageViewTitle, labelTitle, viewSeparator].forEach {
            contentView.addSubview($0)
        }
        
        imageViewTitle.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        labelTitle.snp.makeConstraints { make in
            make.leading.equalTo(imageViewTitle.snp.trailing).offset(8)
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
