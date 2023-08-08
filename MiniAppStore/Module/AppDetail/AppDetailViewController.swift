//
//  AppDetailViewController.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/02.
//

import UIKit

final class AppDetailViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInset = .init(top: 16, left: 0, bottom: 0, right: 0)
        return scrollView
    }()
    private let viewContent = UIView()
    private lazy var viewMainContainer: AppDetailMainView = {
        [unowned self] in
        let viewModel = AppDetailMainView.ViewModel(self.viewModel.appDetail)
        return AppDetailMainView(viewModel)
    }()
    private lazy var viewSubContainer: AppDetailSubView = {
        let viewModel = AppDetailSubView.ViewModel(viewModel.appDetail)
        return AppDetailSubView(viewModel)
    }()
    private lazy var viewScreenshotsContainer: AppDetailScreenshotsView = {
        let viewModel = AppDetailScreenshotsView.ViewModel(viewModel.appDetail)
        return AppDetailScreenshotsView(viewModel)
    }()
    private lazy var viewDescriptionContainer: AppDetailDescriptionView = {
        let viewModel = AppDetailDescriptionView.ViewModel(viewModel.appDetail)
        return AppDetailDescriptionView(viewModel, delegate: self)
    }()
    
    private var viewModel: AppDetailDataProvider
    
    init(viewModel: AppDetailDataProvider) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(viewContent)
        viewContent.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
        
        [viewMainContainer, viewSubContainer, viewScreenshotsContainer, viewDescriptionContainer].forEach {
            viewContent.addSubview($0)
        }
        viewMainContainer.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        viewSubContainer.snp.makeConstraints { make in
            make.top.equalTo(viewMainContainer.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        
        let height = AppDetailScreenshotsView.height(with: view.frame.width)
        viewScreenshotsContainer.snp.makeConstraints { make in
            make.top.equalTo(viewSubContainer.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(height)
        }
        viewDescriptionContainer.snp.makeConstraints { make in
            make.top.equalTo(viewScreenshotsContainer.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(AppDetailDescriptionView.height())
            make.bottom.equalTo(-48)
        }
    }

}

extension AppDetailViewController: AppDetailDescriptionViewDelegate {
    
    func viewMoreTapped(with height: CGFloat) {
        viewDescriptionContainer.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }
    
}
