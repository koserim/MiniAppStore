//
//  MockURLSessionDataTask.swift
//  MiniAppStoreTests
//
//  Created by 림고세 on 2023/07/02.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    
    private let resumeHandler: () -> Void
    
    init(resumeHandler: @escaping () -> Void) {
        self.resumeHandler = resumeHandler
    }
    
    func resume() {
        resumeHandler()
    }
    
}
