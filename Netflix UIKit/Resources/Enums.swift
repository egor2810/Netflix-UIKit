//
//  Enums.swift
//  Netflix UIKit
//
//  Created by Егор Аблогин on 23.04.2024.
//

import Foundation

// MARK: - errors types
enum APIError: Error {
    case failedToDecodeData
}

// MARK: - query components
enum Components {
    case tmdbSearch
    case tmdbDiscover
    case youtubeSearch
    
    func value(for url: URL, query: String? = nil) -> URLComponents {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!

        var queryItems: [URLQueryItem] = []

        switch self {
            case .tmdbDiscover, .tmdbSearch:
                queryItems = [
                    URLQueryItem(name: "api_key", value: Constants.tmdbApiKey),
                    URLQueryItem(name: "language", value: "en-US"),
                    URLQueryItem(name: "page", value: "1")
                    
                ]
                if let query {
                    queryItems.append(URLQueryItem(name: "query", value: query))
                }
            case .youtubeSearch:
                queryItems = [
                    URLQueryItem(name: "q", value: query),
                    URLQueryItem(name: "key", value: Constants.youtubeApiKey)
                ]
        }
        components.queryItems = (components.queryItems ?? []) + queryItems
        
        return components
    }
}

// MARK: - movies sections
enum Sections: Int, CaseIterable {
    case trendingMovies
    case trendingTv
    case popular
    case upcomingMovies
    case topRated
    
    var description: String {
        switch self {
        case .trendingMovies:
            "Trending Movies"
        case .trendingTv:
            "Trending TV"
        case .popular:
            "Popular"
        case .upcomingMovies:
            "Upcoming movies"
        case .topRated:
            "Top rated"
        }
    }
    
    var path: String {
        switch self {
        case .trendingMovies:
            "/trending/movie/week"
        case .trendingTv:
            "/trending/tv/day"
        case .popular:
            "/movie/popular"
        case .upcomingMovies:
            "/movie/upcoming"
        case .topRated:
            "/movie/top_rated"
        }
    }
    
    
}
