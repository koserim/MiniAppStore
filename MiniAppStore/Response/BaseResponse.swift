//
//  BaseResponse.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/02.
//

import Foundation

struct Response<T: Codable>: Codable {
    
    let resultCount: Int?
    let results: [T]?
    
}
