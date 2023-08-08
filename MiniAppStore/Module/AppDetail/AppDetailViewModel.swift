//
//  AppDetailViewModel.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/02.
//

import Foundation

protocol AppDetailDataProvider: AnyObject {
    var appDetail: Software { get }
}

final class AppDetailViewModel: AppDetailDataProvider {
    
    var appDetail: Software
    
    init(appDetail: Software) {
        self.appDetail = appDetail
    }
    
}
