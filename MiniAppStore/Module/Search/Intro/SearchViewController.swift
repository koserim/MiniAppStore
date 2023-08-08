//
//  SearchViewController.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/01.
//

import UIKit
import SnapKit
import Combine

final class SearchViewController: UIViewController {
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = searchResultController as? any UISearchResultsUpdating
        return searchController
    }()
    private lazy var searchResultController: UIViewController = {
        let viewController = SearchResultViewController(viewModel, delegate: self)
        return viewController
    }()
    private lazy var tableViewRecentKeyword: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = tableViewDataSource
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(RecentKeywordCell.self, forCellReuseIdentifier: RecentKeywordCell.identifier)
        tableView.register(RecentKeywordHeader.self, forHeaderFooterViewReuseIdentifier: RecentKeywordHeader.identifier)
        tableView.register(EmptyCell.self, forCellReuseIdentifier: EmptyCell.identifier)
        return tableView
    }()
    
    private var tableViewDataSource: UITableViewDiffableDataSource<Section, AnyHashable>?
    private var viewModel: SearchDataProvider = SearchViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupDataSource()
        bind()
    }
    
    private func bind() {
        viewModel
            .reversedKeywords
            .sink { [weak self] value in
                guard let dataSource = self?.tableViewDataSource
                        , let viewModel = self?.viewModel
                else { return }
                
                var snapshot = dataSource.snapshot()
                snapshot.deleteAllItems()
                snapshot.appendSections(Section.allCases)
                
                if value.isEmpty {
                    snapshot.appendItems(viewModel.emptyValue, toSection: .empty)
                }
                snapshot.appendItems(value, toSection: .recentKeyword)
                
                dataSource.apply(snapshot)
                
//                DispatchQueue.main.async {
//                    dataSource.apply(snapshot)
//                }
            }
            .store(in: &cancellables)
    }
    
}

// MARK: - Implement UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        
        viewModel.search(with: keyword)
    }
    
}

// MARK: - Implement UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keyword = viewModel.reversedKeywords.value[indexPath.item].value
        
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.text = keyword
        searchController.searchBar.endEditing(true)
        
        viewModel.search(with: keyword)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch Section(rawValue: section) {
        case .recentKeyword:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecentKeywordHeader.identifier)
            return header
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch Section(rawValue: section) {
        case .recentKeyword:
            return RecentKeywordHeader.height
        default:
            return .zero
        }
    }
    
}

// MARK: - Implement SearchResultViewControllerDelegate
extension SearchViewController: SearchResultViewControllerDelegate {
    
    func resultCellTapped(_ result: Software) {
        let viewModel = AppDetailViewModel(appDetail: result)
        let detailVC = AppDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func matchedKeywordCellTapped() {
        searchController.searchBar.resignFirstResponder()
    }
    
}

// MARK: - Set up v
extension SearchViewController {
    
    enum Section: Int, CaseIterable {
        case recentKeyword
        case empty
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        navigationItem.searchController = searchController
        navigationItem.title = "검색"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableViewRecentKeyword)
        tableViewRecentKeyword.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupDataSource() {
        tableViewDataSource = UITableViewDiffableDataSource<Section, AnyHashable>(tableView: tableViewRecentKeyword, cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            guard let self = self else { return .init() }
            
            switch Section(rawValue: indexPath.section) {
            case .recentKeyword:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentKeywordCell.identifier, for: indexPath) as? RecentKeywordCell else {
                    fatalError("Failed to dequeue RecentKeywordCell.")
                }
                
                let keywords = self.viewModel.reversedKeywords.value
                if keywords.count > indexPath.item {
                    cell.configure(keywords[indexPath.item])
                }
                
                return cell
            
            case .empty:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyCell.identifier) as? EmptyCell else {
                    fatalError("Failed to dequeue EmptyCell.")
                }
                cell.configure(with: "관심사를 검색해 보세요.")
                return cell

            case .none:
                return .init()
            }
        })
    }
    
}

