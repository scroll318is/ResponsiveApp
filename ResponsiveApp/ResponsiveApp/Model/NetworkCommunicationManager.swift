//
//  NetworkCommunicationManager.swift
//  ResponsiveApp
//
//  Created by Stoyan Kostov on 1.02.18.
//  Copyright © 2018 Stoyan Kostov. All rights reserved.
//

import Foundation

typealias CompletionSuccessHandler = (_ feed:Feed) -> Void
typealias CompletionErrorHandler = (_ error:Error) -> Void

enum NetworkError: Error {
    case statusCodeError(String)
    case noDataError
    case jsonDecodingError(Error)
}

private struct Response: Codable {
    let feed:Feed?
}

class NetworkCommunicationManager {
    
    private let session = URLSession.shared
    
    
    static let shared = NetworkCommunicationManager()
    
    public func fetchFeed(completionSuccess:@escaping CompletionSuccessHandler,
                          completionError:@escaping CompletionErrorHandler)
    {
        var request = URLRequest(url: EndPoints.getFeedURL())
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionError(error!)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                !(response.statusCode >= 200 && response.statusCode <= 299) {
                let message = "\(response.statusCode) status code is not in range of 200...299"
                completionError(NetworkError.statusCodeError(message))
                return
            }
            
            guard let data = data else {
                completionError(NetworkError.noDataError)
                return
            }
            
            do {
                if let feed = try JSONDecoder().decode(Response.self, from: data).feed {
                    completionSuccess(feed)
                } else {
                    completionError(NetworkError.noDataError)
                }
             } catch let error {
                completionError(NetworkError.jsonDecodingError(error))
             }
            
        }
        task.resume()
    }
    
}
