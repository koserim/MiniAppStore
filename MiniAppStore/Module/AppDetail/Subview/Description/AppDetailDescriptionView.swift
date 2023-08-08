//
//  AppDetailDescriptionView.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/03.
//

import UIKit

protocol AppDetailDescriptionViewDelegate: AnyObject {
    func viewMoreTapped(with height: CGFloat)
}

final class AppDetailDescriptionView: UIView {
    
    static let textViewDefaultHeight: CGFloat = 60 + 18.5 * 2
    
    static func height() -> CGFloat {
        return 16 + textViewDefaultHeight + 1
    }
    
    struct ViewModel {
        let software: Software
        
        var description: String {
            software.description ?? ""
        }
        
        init(_ software: Software) {
            self.software = software
        }
    }
    
    private let viewSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    private lazy var textViewDescription: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 14)
        textView.textColor = .black
        textView.isScrollEnabled = false
        return textView
    }()
    private lazy var viewMoreContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private lazy var labelMore: UILabel = {
        let label = UILabel()
        label.text = "더 보기"
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private var viewModel: ViewModel
    private weak var delegate: AppDetailDescriptionViewDelegate?
    private var openedTextViewHeight: CGFloat = 0

    init(_ viewModel: ViewModel, delegate: AppDetailDescriptionViewDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(frame: .zero)
        
        setupViews()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func viewMoreTapped() {
        viewMoreContainer.isHidden = true
        delegate?.viewMoreTapped(with: openedTextViewHeight)
    }
    
    private func configure() {
        let font = UIFont.systemFont(ofSize: 14)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 20
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedString = NSMutableAttributedString(string: viewModel.description, attributes: attributes)
        textViewDescription.attributedText = attributedString
        
        showViewMoreIfNeeded()
    }
    
    private func showViewMoreIfNeeded() {
        textViewDescription.sizeToFit()
        if textViewDescription.frame.height > AppDetailDescriptionView.textViewDefaultHeight {
            openedTextViewHeight = textViewDescription.frame.height
            viewMoreContainer.isHidden = false
        } else {
            viewMoreContainer.isHidden = true
        }
    }
    
    private func setupViews() {
        [viewSeparator, textViewDescription, viewMoreContainer].forEach {
            addSubview($0)
        }
        
        viewSeparator.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.height.equalTo(1)
        }
        textViewDescription.snp.makeConstraints { make in
            make.top.equalTo(viewSeparator.snp.bottom)
            make.leading.equalTo(16)
            make.trailing.bottom.equalTo(-16)
        }
        viewMoreContainer.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.height.equalTo(18)
            make.trailing.equalTo(-16)
            make.bottom.equalTo(-24)
        }
        
        viewMoreContainer.addSubview(labelMore)
        labelMore.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        viewMoreContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewMoreTapped)))
    }

}
