//
//  AppDetailMainView.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/02.
//

import UIKit
import SDWebImage

final class AppDetailMainView: UIView {
    
    struct ViewModel {
        let software: Software
        
        var artwortUrl: URL? {
            URL(string: software.artworkUrl100 ?? "")
        }
        var title: String? {
            software.trackName
        }
        var description: String? {
            software.genres?.first
        }
        
        init(_ software: Software) {
            self.software = software
        }
    }

    private let imageViewTitle: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    private let stackViewContent: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .top
        return stackView
    }()
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    private let labelDescription: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private var viewModel: ViewModel

    init(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        setupViews()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        if let url = viewModel.artwortUrl {
            imageViewTitle.sd_setImage(with: url)
        }
        labelTitle.text = viewModel.title
        labelDescription.text = viewModel.description
    }
    
    private func setupViews() {
        [imageViewTitle, stackViewContent].forEach {
            addSubview($0)
        }
        
        imageViewTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(16)
            make.width.height.equalTo(84)
        }
        stackViewContent.snp.makeConstraints { make in
            make.top.equalTo(2)
            make.leading.equalTo(imageViewTitle.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        [labelTitle, labelDescription].forEach {
            stackViewContent.addArrangedSubview($0)
        }
    }

}
