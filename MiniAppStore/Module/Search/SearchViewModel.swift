//
//  SearchViewModel.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/01.
//

import Foundation
import Combine

enum SearchResultView {
    case matchedKeyword
    case searchResult
}

protocol SearchDataProvider: AnyObject {
    var reversedKeywords: CurrentValueSubject<[Keyword], Never> { get }
    var searchResult: CurrentValueSubject<[Software], Never> { get }
    var matchedKeywords: CurrentValueSubject<[Keyword], Never> { get }
    var resultType: SearchResultView { get }
    var emptyValue: [String] { get }
    
    func search(with keyword: String)
    func updateMatchedKeyword(with keyword: String)
}

final class SearchViewModel: SearchDataProvider {
    
    private let persistenceManager = PersistenceManager.shared
    private let networkManager: NetworkManager
    private let limit: Int = 10
    private let keywordMaxCount: Int = 10
    
    var reversedKeywords: CurrentValueSubject<[Keyword], Never> = .init([])
    var matchedKeywords: CurrentValueSubject<[Keyword], Never> = .init([])
    var searchResult: CurrentValueSubject<[Software], Never> = .init([])
    var resultType: SearchResultView = .matchedKeyword
    var emptyValue: [String] = ["empty"]
    
    private var recentKeywords: CurrentValueSubject<[Keyword], Never> = .init([])
    private var cancellables = Set<AnyCancellable>()
    
    init(_ networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
        
        recentKeywords
            .send(persistenceManager.getKeywords())
        
        bind()
    }
    
    func updateMatchedKeyword(with keyword: String) {
        resultType = .matchedKeyword
        
        let matchedValue = recentKeywords.value.filter {
            $0.value.hasPrefix(keyword)
        }
        matchedKeywords
            .send(matchedValue.reversed())
    }
    
    func search(with keyword: String) {
        addRecentKeyword(keyword)
        
        networkManager
            .search(keyword, limit: limit) { [weak self] data, response, error in
                guard let data = data else { return }
                                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601

                    let result = try decoder.decode(Response<Software>.self, from: data)

                    self?.resultType = .searchResult
                    self?.searchResult
                        .send(result.results ?? [])
                } catch {
                    self?.searchResult
                        .send([])
                }
            }
    }
    
    private func bind() {
        recentKeywords
            .sink { [weak self] value in
                self?.reversedKeywords.send(value.reversed())
            }
            .store(in: &cancellables)
        
        persistenceManager
            .updated
            .sink { [weak self] in
                guard let self = self else { return }
                
                let value = persistenceManager.getKeywords()
                recentKeywords.send(value)
            }
            .store(in: &cancellables)
    }
    
    private func addRecentKeyword(_ keyword: String) {
        removeFirstKeywordIfNeeded()
        
        if let duplicatedKeyword = recentKeywords.value.first(where: { $0.value == keyword }) {
            persistenceManager.delete(keyword: duplicatedKeyword)
        }
        
        let keyword = Keyword(value: keyword)
        persistenceManager.insert(keyword: keyword)
    }
    
    private func removeFirstKeywordIfNeeded() {
        guard recentKeywords.value.count >= keywordMaxCount else { return }
        
        if let firstKeyword = recentKeywords.value.first {
            persistenceManager.delete(keyword: firstKeyword)
        }
    }
    
}
