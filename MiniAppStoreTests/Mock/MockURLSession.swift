//
//  MockURLSession.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/04.
//

import Foundation

class MockURLSession: URLSessionProtocol {
    
    typealias Response = (data: Data?, response: URLResponse?, error: Error?)

    var response: Response

    init(response: Response) {
        self.response = response
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return MockURLSessionDataTask(resumeHandler: {
            completionHandler(self.response.data,
                              self.response.response,
                              self.response.error)
        })
    }

}

