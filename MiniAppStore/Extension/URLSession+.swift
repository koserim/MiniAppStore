//
//  URLSession+.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/04.
//

import Foundation

extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

