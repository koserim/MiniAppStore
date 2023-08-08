//
//  SearchResultViewController.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/01.
//

import UIKit
import SnapKit
import Combine

protocol SearchResultViewControllerDelegate: AnyObject {
    func matchedKeywordCellTapped()
    func resultCellTapped(_ result: Software)
}

final class SearchResultViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = tableViewDataSource
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.contentInset = .init(top: 16, left: 0, bottom: 0, right: 0)
        tableView.register(MatchedKeywordCell.self, forCellReuseIdentifier: MatchedKeywordCell.identifier)
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.identifier)
        tableView.register(EmptyCell.self, forCellReuseIdentifier: EmptyCell.identifier)
        return tableView
    }()
    private var tableViewDataSource: UITableViewDiffableDataSource<Section, AnyHashable>?
    private var viewModel: SearchDataProvider
    private weak var delegate: SearchResultViewControllerDelegate?
    private var cancellables = Set<AnyCancellable>()

    init(_ viewModel: SearchDataProvider, delegate: SearchResultViewControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupTableViewDataSource()
        bind()
    }
    
    private func bind() {
        viewModel
            .matchedKeywords
            .combineLatest(viewModel.searchResult)
            .sink { [weak self] (keyword, result) in
                guard let dataSource = self?.tableViewDataSource
                        , let viewModel = self?.viewModel
                else { return }

                var snapshot = dataSource.snapshot()
                snapshot.deleteAllItems()
                snapshot.appendSections(Section.allCases)
                
                if self?.viewModel.resultType == .matchedKeyword {
                    snapshot.appendItems(keyword, toSection: .matchedKeyword)
                } else {
                    if result.isEmpty {
                        snapshot.appendItems(viewModel.emptyValue, toSection: .empty)
                    }
                    snapshot.appendItems(result, toSection: .searchResult)
                }
                DispatchQueue.main.async {
                    dataSource.apply(snapshot)
                }
            }
            .store(in: &cancellables)
    }

}

// MARK: - Set up view
extension SearchResultViewController {
    
    enum Section: Int, CaseIterable {
        case matchedKeyword
        case searchResult
        case empty
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        [tableView].forEach {
            view.addSubview($0)
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupTableViewDataSource() {
        tableViewDataSource = UITableViewDiffableDataSource<Section, AnyHashable>(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            guard let self = self else { return .init() }
            
            switch Section(rawValue: indexPath.section) {
            case .matchedKeyword:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MatchedKeywordCell.identifier, for: indexPath) as? MatchedKeywordCell else {
                    fatalError("Failed to dequeue MatchedKeywordCell.")
                }
                
                let keywords = self.viewModel.matchedKeywords.value
                if keywords.count > indexPath.item {
                    cell.configure(keywords[indexPath.item], isFirst: indexPath.item == .zero)
                }
                return cell
                
            case .searchResult:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier, for: indexPath) as? SearchResultCell else {
                    fatalError("Failed to dequeue SearchResultCell.")
                }
                
                let results = self.viewModel.searchResult.value
                if results.count > indexPath.item {
                    cell.configure(.init(results[indexPath.item]))
                }
                return cell
                
            case .empty:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyCell.identifier) as? EmptyCell else {
                    fatalError("Failed to dequeue EmptyCell.")
                }
                cell.configure(with: "검색 결과가 없습니다.")
                return cell
            case .none:
                return .init()
            }
        })
    }
}

// MARK: - Implement UITableViewDelegate
extension SearchResultViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section) {
        case .matchedKeyword:
            delegate?.matchedKeywordCellTapped()
            
            let keywords = viewModel.matchedKeywords.value
            if keywords.count > indexPath.item {
                viewModel.search(with: keywords[indexPath.item].value)
            }
        case .searchResult:
            let results = viewModel.searchResult.value
            if results.count > indexPath.item {
                delegate?.resultCellTapped(results[indexPath.item])
            }
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch Section(rawValue: indexPath.section) {
        case .matchedKeyword:
            return MatchedKeywordCell.height
        case .searchResult:
            let results = self.viewModel.searchResult.value
            if results.count > indexPath.item {
                return SearchResultCell
                    .height(.init(results[indexPath.item]),
                            availableWidth: tableView.frame.width)
            }
            return .zero
        case .empty:
            return EmptyCell.height
        case .none:
            return .zero
        }
    }
    
}

// MARK: - Implement UISearchResultsUpdating
extension SearchResultViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let keyword = searchController.searchBar.text,
                keyword.isEmpty == false else { return }
        viewModel.updateMatchedKeyword(with: keyword)
    }
    
}

