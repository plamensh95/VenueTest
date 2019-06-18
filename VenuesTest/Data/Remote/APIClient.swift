//
//  APIClient.swift
//  WeatherApp
//
//  Created by Plamen Iliev on 30.05.19.
//  Copyright © 2019 Plamen SH. All rights reserved.
//
import Foundation

class APIClient {
    
    private let requestBuilder: APIRequestBuilder
    
    init(requestBuilder: APIRequestBuilder = Injector.injectAPIRequestBuilderDependency()) {
        self.requestBuilder = requestBuilder
    }
    
    func getTrendingVenues(with parameters: [String: String], completion: @escaping (Result) -> ()) {

        guard let url = requestBuilder.buildTrendingVenuesURL(with: parameters) else {
            completion(.failure(.couldntReach))
            return
        }
        
        sendGetRequest(with: url, completion: { result in
            completion(result)
        })
    }
    
    func getVenueDetails(with venueId: String, completion: @escaping (Result) -> ()) {
        
        guard let url = requestBuilder.buildGetVenueDetailsURL(with: venueId) else {
            completion(.failure(.couldntReach))
            return
        }
        
        print(url)
        
        sendGetRequest(with: url, completion: { result in
            completion(result)
        })
    }
    
    // MARK: - API Requests
    private func sendGetRequest(with url: URL, completion: @escaping (Result) -> ()) {

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error {
                completion(.failure(.error(err)))
            } else if let safeData = data {
                completion(.success(safeData))
            } else {
                completion(.failure(.couldntParse))
            }
            
            }.resume()
    }
}
