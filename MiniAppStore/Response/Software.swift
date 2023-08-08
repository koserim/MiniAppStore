//
//  Software.swift
//  MiniAppStore
//
//  Created by 림고세 on 2023/07/01.
//

import Foundation

struct Software: Codable, Hashable, Equatable {
    
    let trackName: String?
    let artworkUrl100: String?
    let screenshotUrls: [String]?
    let description: String?
    let genres: [String]?
    let userRatingCount: Int?
    let averageUserRating: Double?
    let contentAdvisoryRating: String?
    let sellerName: String?
    let languageCodesISO2A: [String]?
    
    let releaseNotes: String?
    let currentVersionReleaseDate: String?
    let currency: String?
    let version: String?
    let releaseDate: String?
    let price: Double?

}

