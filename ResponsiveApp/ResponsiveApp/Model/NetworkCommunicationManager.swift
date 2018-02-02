//
//  NetworkCommunicationManager.swift
//  ResponsiveApp
//
//  Created by Stoyan Kostov on 1.02.18.
//  Copyright © 2018 Stoyan Kostov. All rights reserved.
//

import UIKit

typealias CompletionSuccessHandler = (_ feed:Feed) -> Void
typealias CompletionErrorHandler = (_ error:Error) -> Void
typealias ImageCacheCompletion = (UIImage?, Error?) -> Void

enum NetworkError: Error {
    case statusCodeError(String)
    case noDataError
    case jsonDecodingError(Error)
}

private struct Response: Codable {
    let feed:Feed?
}

class NetworkCommunicationManager {
    
    // MARK: Private
    private let session = URLSession.shared
    
    // MARK: Public
    public static let shared = NetworkCommunicationManager()
    
    public func fetchFeed(completionSuccess:@escaping CompletionSuccessHandler,
                          completionError:@escaping CompletionErrorHandler)
    {
        let _completionSuccess = { (feed:Feed) in
            DispatchQueue.main.async {
                completionSuccess(feed)
            }
        }
        
        let _completionError = { (error:Error) in
            DispatchQueue.main.async {
                completionError(error)
            }
        }
        
        var request = URLRequest(url: EndPoints.getFeedURL())
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                _completionError(error!)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                !(response.statusCode >= 200 && response.statusCode <= 299) {
                let message = "\(response.statusCode) status code is not in range of 200...299"
                _completionError(NetworkError.statusCodeError(message))
                return
            }
            
            guard let data = data else {
                _completionError(NetworkError.noDataError)
                return
            }
            
            do {
                if let feed = try JSONDecoder().decode(Response.self, from: data).feed {
                    _completionSuccess(feed)
                } else {
                    _completionError(NetworkError.noDataError)
                }
             } catch let error {
                _completionError(NetworkError.jsonDecodingError(error))
             }
            
        }
        task.resume()
    }
    
    public func getImage(url:URL, completion: @escaping ImageCacheCompletion) {
        let _completion = { (_ image:UIImage?,_ error: Error?) in
            DispatchQueue.main.async {
                completion(image, error)
            }
        }
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            guard error == nil else {
                _completion(nil, error)
                return
            }
            
            if let data = data,
                let image = UIImage(data:data)
            {
                _completion(image, nil)
            } else {
                _completion(nil, NetworkError.noDataError)
            }
        })
        task.resume()
    }
    
}
