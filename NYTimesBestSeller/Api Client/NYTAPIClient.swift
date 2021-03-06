//
//  NYTAPIClient.swift
//  NYTimesBestSeller
//
//  Created by Tsering Lama on 2/5/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import Foundation
import NetworkHelper

// Kelby TODO: Make API Client

struct NYTAPIClient {
    
    static func getBooks(for category: String, completion: @escaping (Result<[Book], AppError>) -> ()) {
        
        let list = category.replacingOccurrences(of: " ", with: "-")
        
        let nytEndpointURL = "https://api.nytimes.com/svc/books/v3/lists/current/\(list).json?api-key=\(APIKey.nYTKey)"
        
        guard let url = URL(string: nytEndpointURL) else {
            completion(.failure(.badURL(nytEndpointURL)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let bookSearch = try JSONDecoder().decode(BookSearch.self, from: data)
                    let bookHits = bookSearch.results.books
                    completion(.success(bookHits))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
}
