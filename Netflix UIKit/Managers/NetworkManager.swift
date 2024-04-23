//
//  NetworkManager.swift
//  Netflix UIKit
//
//  Created by Егор Аблогин on 21.04.2024.
//

import Foundation

enum APIError: Error {
    case failedToDecodeData
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchTrendingTitles(for section: Sections, completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3\(section.path)") else {
            print("Invalid URL")
            return
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        // Добавление необходимых параметров запроса
        let queryItems = [
            URLQueryItem(name: "api_key", value: Constants.API_KEY),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1")
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
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToDecodeData))
            }
        }
        
        task.resume()
    }
    
    // MARK: -  Discover titles
    func fetchDiscoverTitles(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie") else {
            print("Invalid URL")
            return
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        // Добавление необходимых параметров запроса
        let queryItems = [
            URLQueryItem(name: "api_key", value: Constants.API_KEY),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1")
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
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToDecodeData))
            }
        }
        
        task.resume()
    }
    
    func searchTitles(query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        else {return}
        
        guard let url = URL(string: "https://api.themoviedb.org/3/search/movie") else {
            print("Invalid URL")
            return
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        // Добавление необходимых параметров запроса
        let queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "api_key", value: Constants.API_KEY)
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
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToDecodeData))
            }
        }
        
        task.resume()
    }

}
