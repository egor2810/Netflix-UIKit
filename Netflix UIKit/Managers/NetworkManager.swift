//
//  NetworkManager.swift
//  Netflix UIKit
//
//  Created by Егор Аблогин on 21.04.2024.
//

import Foundation

struct Constants {
    static let API_KEY = "0d2c20a7a13fa5f093b2a33f4ed48247"
    static let baseURL = "https://api.themoviedb.org"
}

enum APIError: Error {
    case failedToReturnData
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day") else {
            print("Invalid URL")
            return
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        // Добавление необходимых параметров запроса
        let queryItems = [
            URLQueryItem(name: "api_key", value: Constants.API_KEY),
            URLQueryItem(name: "language", value: "en-US"), // Включаем если требуется
            URLQueryItem(name: "page", value: "1") // Включаем если требуется
        ]
        components.queryItems = (components.queryItems ?? []) + queryItems
        
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
                let results = try JSONDecoder().decode(TrendingMovieResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

}
