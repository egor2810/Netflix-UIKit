//
//  YTSearchResponce.swift
//  Netflix UIKit
//
//  Created by Егор Аблогин on 23.04.2024.
//

import Foundation

struct YTSearchResponce: Decodable {
    let items: [YTResponceItem]
}

struct YTResponceItem: Decodable {
    let id: YTItemID
}

struct YTItemID: Decodable {
    let videoId: String
}
