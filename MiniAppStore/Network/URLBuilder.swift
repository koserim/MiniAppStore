//
//  URLBuilder.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/01.
//

import Foundation

struct URLMaker {
    
    enum BaseURL: String {
        case base = "https://itunes.apple.com"
    }
    
    enum Path: String {
        case search = "/search"
        case lookup = "/lookup"
    }
    
    let search: String = BaseURL.base.rawValue + Path.search.rawValue
    
}

/**
    https://itunes.apple.com/search?term=kakao&country=kr&entity=software&limit=10
 */

final class URLBuilder {
    
    private let url: String
    var parameters: [String] = []
    
    init(url: String) {
        self.url = url
    }
    
    func addTerm(_ query: String) -> URLBuilder {
        parameters.append("term=\(query)")
        return self
    }
    
    func addCountry(_ query: String) -> URLBuilder {
        parameters.append("country=\(query)")
        return self
    }
    
    func addEntity(_ query: String) -> URLBuilder {
        parameters.append("entity=\(query)")
        return self
    }
    
    func addLimit(_ query: Int) -> URLBuilder {
        parameters.append("limit=\(query)")
        return self
    }
    
    func build() -> String {
        var url = self.url
        for (index, parameter) in parameters.enumerated() {
            url.append(index == 0 ? "?" : "&")
            url.append(parameter)
        }
        return url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? url
    }
    
}
