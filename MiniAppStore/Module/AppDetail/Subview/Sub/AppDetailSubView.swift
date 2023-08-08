//
//  AppDetailSubView.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/03.
//

import UIKit

final class AppDetailSubView: UIView {

    struct ViewModel {
        let software: Software
        
        var rating: Double {
            software.averageUserRating ?? 0
        }
        var ratingText: String? {
            guard let rating = software.averageUserRating else {
                return nil
            }
            return String(format: "%.1f", rating)
        }
        var ratingCountText: String {
            guard let count = software.userRatingCount else {
                return "평가"
            }
            return count.toString() + "개 평가"
        }
        var age: String? {
            return software.contentAdvisoryRating
        }
        var seller: String? {
            return software.sellerName
        }
        var language: String? {
            if let language = software.languageCodesISO2A?.first {
                return language
            }
            return nil
        }
        var languageCount: String? {
            if let languages = software.languageCodesISO2A
                , languages.count > 1 {
                return "+ \(languages.count - 1)개 언어"
            }
            return nil
        }
        
        init(_ software: Software) {
            self.software = software
        }
    }

    private let viewSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = false
        return scrollView
    }()
    private let viewContent = UIView()
    private let stackViewContent: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        return stackView
    }()
    private lazy var viewRating: VerticalInfoView = {
        let title = viewModel.ratingCountText
        let view = VerticalInfoView(title: title)
        view.add(text: viewModel.ratingText, on: .center)
        let viewRating = StarRatingView()
        viewRating.configure(with: viewModel.rating)
        view.add(view: viewRating, on: .bottom)
        return view
    }()
    private lazy var viewAge: VerticalInfoView = {
        let title = "연령"
        let view = VerticalInfoView(title: title)
        view.add(text: viewModel.age, on: .center)
        view.add(text: "세", on: .bottom)
        return view
    }()
    private lazy var viewSeller: VerticalInfoView = {
        let title = "개발자"
        let view = VerticalInfoView(title: title)
        let centerView = UIView()
        let imageView = UIImageView(
            image: UIImage(systemName: "person.fill.viewfinder")?
                .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        )
        centerView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.center.equalToSuperview()
        }
        view.add(view: centerView, on: .center)
        view.add(text: viewModel.seller, on: .bottom)
        return view
    }()
    private lazy var viewLanguage: VerticalInfoView = {
        let title = "언어"
        let view = VerticalInfoView(title: title)
        view.add(text: viewModel.language, on: .center)
        view.add(text: viewModel.languageCount, on: .bottom)
        return view
    }()
    
    private var viewModel: ViewModel

    init(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [scrollView].forEach {
            addSubview($0)
        }
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(viewContent)
        viewContent.snp.makeConstraints { make in
            make.edges.height.equalToSuperview()
        }
        
        [viewSeparator, stackViewContent].forEach {
            viewContent.addSubview($0)
        }
        viewSeparator.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.height.equalTo(1)
        }
        stackViewContent.snp.makeConstraints { make in
            make.top.equalTo(viewSeparator.snp.bottom)
            make.bottom.equalToSuperview()
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
        }
        
        [viewRating, viewAge, viewSeller, viewLanguage].forEach {
            stackViewContent.addArrangedSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(100)
            }
        }
    }
}
