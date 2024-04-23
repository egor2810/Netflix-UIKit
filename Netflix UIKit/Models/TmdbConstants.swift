//
//  TmdbConstants.swift
//  Netflix UIKit
//
//  Created by Егор Аблогин on 21.04.2024.
//

import Foundation

struct Constants {
    static let API_KEY = "0d2c20a7a13fa5f093b2a33f4ed48247"
    static let baseURL = "https://api.themoviedb.org"
    static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
}

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


