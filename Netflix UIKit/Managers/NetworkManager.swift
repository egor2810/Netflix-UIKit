//
//  NetworkManager.swift
//  Netflix UIKit
//
//  Created by Егор Аблогин on 21.04.2024.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    // MARK: - tmdb methods
    func tmdbGetTrendingTitles(for section: Sections, completion: @escaping (Result<TrendingTitleResponse, Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.tmdbBaseUrl)/3\(section.path)") else {
            print("Invalid URL")
            return
        }
        
        let components = Components.tmdbDiscover.value(for: url)
        
        request(for: TrendingTitleResponse.self, with: components, completion: completion)
    }
    
    func tmdbDiscoverTitles(completion: @escaping (Result<TrendingTitleResponse, Error>) -> Void) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie") else {
            print("Invalid URL")
            return
        }
        
        let components = Components.tmdbDiscover.value(for: url)
        
        request(for: TrendingTitleResponse.self, with: components, completion: completion)
    }
    
    func tmdbSearchTitles(query: String, completion: @escaping (Result<TrendingTitleResponse, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        else {return}
        
        guard let url = URL(string: "https://api.themoviedb.org/3/search/movie") else {
            print("Invalid URL")
            return
        }
        
        let components = Components.tmdbSearch.value(for: url, query: query)
        
        request(for: TrendingTitleResponse.self, with: components, completion: completion)
    }
        
    // MARK: - YouTube api methods
    func ytGetMovie(query: String, completion: @escaping (Result<TrendingTitleResponse, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        else {return}
        
        guard let url = URL(string: Constants.youtubeBaseUrl) else {
            print("Invalid URL")
            return
        }
        
        let components = Components.youtubeSearch.value(for: url, query: query)
        
        request(for: TrendingTitleResponse.self, with: components, completion: completion)
    }
    
    // MARK: - main request method
    private func request<T>(for: T.Type, with components: URLComponents, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        guard let finalURL = components.url else {
            print("Invalid URL components")
            return
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.addValue("application/json", forHTTPHeaderField: "accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(T.self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(APIError.failedToDecodeData))
            }
        }
        
        task.resume()
    }
    

}
