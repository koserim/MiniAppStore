//
//  VerticalInfoView.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/03.
//

import UIKit

final class VerticalInfoView: UIView {
    
    enum Position {
        case center, bottom
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 2
        return stackView
    }()
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    private let viewCenter = UIView()
    private let viewBottom = UIView()
    
    init(title: String) {
        super.init(frame: .zero)
        
        setupViews(with: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add(text: String?, on position: Position) {
        switch position {
        case .center:
            let labelCenter: UILabel = {
                let label = UILabel()
                label.text = text
                label.font = .systemFont(ofSize: 18, weight: .bold)
                label.textColor = .systemGray
                label.textAlignment = .center
                return label
            }()
            viewCenter.addSubview(labelCenter)
            labelCenter.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        case .bottom:
            let labelBottom: UILabel = {
                let label = UILabel()
                label.text = text
                label.font = .systemFont(ofSize: 12)
                label.textColor = .systemGray
                label.textAlignment = .center
                return label
            }()
            viewBottom.addSubview(labelBottom)
            labelBottom.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.trailing.equalToSuperview()
            }
        }
    }
    
    func add(view: UIView, on position: Position) {
        switch position {
        case .center:
            viewCenter.addSubview(view)
        case .bottom:
            viewBottom.addSubview(view)
        }
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupViews(with title: String) {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        [labelTitle, viewCenter, viewBottom].forEach {
            stackView.addArrangedSubview($0)
        }
        viewCenter.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        viewBottom.snp.makeConstraints { make in
            make.width.equalTo(75)
            make.height.equalTo(15)
        }
        
        labelTitle.text = title
    }
    
}
