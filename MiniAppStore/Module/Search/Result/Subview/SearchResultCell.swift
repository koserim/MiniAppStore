//
//  SearchResultCell.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/02.
//

import UIKit
import SnapKit
import SDWebImage

final class SearchResultCell: UITableViewCell {

    static let identifier: String = "SearchResultCell"
    static func height(_ viewModel: ViewModel, availableWidth: CGFloat) -> CGFloat {
        let height: CGFloat = 100
        if viewModel.screenshotUrls.isEmpty {
            return height
        }
        
        let spacing: CGFloat = 8
        let inset: CGFloat = 16
        let screenshotWidth = (availableWidth - spacing * 2 - inset * 2) / 3
        return height + screenshotWidth * ScreenshotImageView.ratio
    }
    
    struct ViewModel {
        let software: Software
        let screenshotCount: Int = 3
        
        var artwortUrl: URL? {
            URL(string: software.artworkUrl100 ?? "")
        }
        var title: String? {
            software.trackName
        }
        var description: String? {
            software.genres?.first
        }
        var rating: Double {
            software.averageUserRating ?? 0
        }
        var ratingCountText: String? {
            guard let count = software.userRatingCount else {
                return nil
            }
            return count.toString()
        }
        var screenshotUrls: [URL] {
            return software.screenshotUrls?.compactMap { URL(string: $0) } ?? []
        }
        
        init(_ software: Software) {
            self.software = software
        }
    }
    
    private let imageViewTitle: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    private let stackViewContent: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .top
        return stackView
    }()
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private let labelDescription: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    private let viewRatingContainer = UIView()
    private let viewRating = StarRatingView()
    private let stackViewRating: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let labelRating: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    private let stackViewScreenshots = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
       
    private var viewModel: ViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        
        if let url = viewModel.artwortUrl {
            imageViewTitle.sd_setImage(with: url)
        }
        labelTitle.text = viewModel.title
        labelDescription.text = viewModel.description
        viewRating.configure(with: viewModel.rating)
        labelRating.text = viewModel.ratingCountText
        configureStackViewScreenshots(with: viewModel)
    }
    
    private func configureStackViewScreenshots(with viewModel: ViewModel) {
        stackViewScreenshots.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        let urls = viewModel.screenshotUrls
        guard urls.isEmpty == false else { return }
        
        for index in (0..<viewModel.screenshotCount) {
            if index >= urls.count {
                stackViewScreenshots.addArrangedSubview(UIView())
            } else {
                let imageView = ScreenshotImageView(url: urls[index])
                stackViewScreenshots.addArrangedSubview(imageView)
            }
        }
    }
    
    private func setupViews() {
        selectionStyle = .none

        [imageViewTitle, stackViewContent, stackViewScreenshots].forEach {
            contentView.addSubview($0)
        }
        
        imageViewTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(16)
            make.width.height.equalTo(56)
        }
        stackViewContent.snp.makeConstraints { make in
            make.top.equalTo(2)
            make.leading.equalTo(imageViewTitle.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-16)
        }
        stackViewScreenshots.snp.makeConstraints { make in
            make.top.equalTo(imageViewTitle.snp.bottom).offset(16)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.bottom.equalTo(-16)
        }
        
        [labelTitle, labelDescription, viewRatingContainer].forEach {
            stackViewContent.addArrangedSubview($0)
        }
        
        [viewRating, labelRating].forEach {
            viewRatingContainer.addSubview($0)
        }
        viewRating.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(12 * 5)
            make.height.equalTo(12)
        }
        labelRating.snp.makeConstraints { make in
            make.leading.equalTo(viewRating.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
    }

}
