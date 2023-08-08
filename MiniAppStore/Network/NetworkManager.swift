//
//  NetworkManager.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/01.
//

import Foundation

enum HTTPMethod: String {
    case GET
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

final class NetworkManager {
    
    typealias Completion = (Data?, URLResponse?, Error?) -> Void
    
    private let session: URLSessionProtocol
    private let urlMaker = URLMaker()
    
    init(session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func search(_ keyword: String, limit: Int, completion: @escaping Completion) {
        let urlString = URLBuilder(url: urlMaker.search)
            .addTerm(keyword)
            .addLimit(limit)
            .addEntity("software")
            .addCountry("kr")
            .build()
        
        print("Request started::: \(urlString)")
        
        guard let url = URL(string: urlString) else { return }
                
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue

        session
            .dataTask(with: request, completionHandler: completion)
            .resume()
    }
    
}
