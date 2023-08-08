//
//  AppDetailScreenshotsView.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/03.
//

import UIKit

final class AppDetailScreenshotsView: UIView {
    
    static func height(with availableWidth: CGFloat) -> CGFloat {
        let cellHeight = ScreenshotImageCell.size(with: availableWidth).height
        return cellHeight + 16
    }
    
    struct ViewModel {
        let software: Software
        
        var screenshotUrls: [URL] {
            return software.screenshotUrls?.compactMap { URL(string: $0) } ?? []
        }
        
        init(_ software: Software) {
            self.software = software
        }
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ScreenshotImageCell.self, forCellWithReuseIdentifier: ScreenshotImageCell.identifier)
        return collectionView
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
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension AppDetailScreenshotsView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.screenshotUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScreenshotImageCell.identifier, for: indexPath) as? ScreenshotImageCell else {
            fatalError("Failed to dequeue ScreenshotImageCell.")
        }
        let urls = viewModel.screenshotUrls
        if urls.count > indexPath.item {
            cell.configure(with: urls[indexPath.item])
        }
        return cell
    }
    
}

extension AppDetailScreenshotsView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return ScreenshotImageCell.size(with: collectionView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 16, bottom: 0, right: 16)
    }
    
}

extension AppDetailScreenshotsView: UIScrollViewDelegate {
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
 
        let cellWidth = ScreenshotImageCell.size(with: collectionView.frame.width).width + 8
 
        let estimatedIndex = (scrollView.contentOffset.x - layout.sectionInset.left) / cellWidth
        var index: Int
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
        } else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
        } else {
            index = Int(round(estimatedIndex))
        }
 
        index = max(min(collectionView.numberOfItems(inSection: 0) - 1, index), 0)
        targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidth, y: 0)
    }
}
