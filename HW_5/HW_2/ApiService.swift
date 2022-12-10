//
//  ApiService.swift
//  HW_2
//
//  Created by Lebedev A on 10.12.2022.
//

import Foundation

final class ApiService {
    static let shared = ApiService()
    
    struct  Constants {
        static let topHeadlinesURL = URL(string:
                                            "https://newsapi.org/v2/everything?q=Apple&from=2022-12-09&sortBy=popularity&apiKey=1c96d90b56d24348b06e2cc5b8e43a8f")
    }
    private init() {}
    
    public func getTopStories (completion: @escaping (Result<APIResponse,Error>) -> Void) {
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
struct APIResponse: Codable {
    let articles:[Article]
}
struct Article: Codable {
    let source: Source
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
}
struct Source: Codable {
    let name: String
}
