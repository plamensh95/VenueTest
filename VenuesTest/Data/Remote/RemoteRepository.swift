//
//  RemoteRepository.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 14.06.19.
//  Copyright © 2019 Plamen SH. All rights reserved.
//

import Foundation

class RemoteRepository {
    private let apiClient: APIClient
    private let apiResponseParser: APIResponseParser
        
    // MARK: - Initialization
    init(apiClient: APIClient = Injector.injectAPIClientDependency(),
         apiResponseParser: APIResponseParser = Injector.injectAPIResponseParserDependency()) {
        self.apiClient = apiClient
        self.apiResponseParser = apiResponseParser
    }
    
    // MARK: - API Calls
    func searchVenues(with parameters: [String: String], completion: @escaping (Result) -> ()) {
        apiClient.getTrendingVenues(with: parameters) { [weak self] result in
            guard let safeSelf = self else { return }
            
            switch result {
            case .success(let value):
                if let data = value as? Data {
                    completion(safeSelf.parseMultipleVenuesResponseData(data))
                } else {
                    completion(.failure(.couldntParse))
                }
            case .failure:
                completion(result)
            }
        }
    }
    
    func getVenueDetails(with venueId: String, completion: @escaping (Result) -> ()) {
        apiClient.getVenueDetails(with: venueId) { [weak self] result in
            guard let safeSelf = self else { return }
            
            switch result {
            case .success(let value):
                if let data = value as? Data {
                    completion(safeSelf.parseSingleVenueResponseData(data))
                } else {
                    completion(.failure(.couldntParse))
                }
            case .failure:
                completion(result)
            }
        }
    }
    
    // MARK: - API Response parse
    private func parseMultipleVenuesResponseData(_ data: Data) -> Result {
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            let responseResult = apiResponseParser.parseBaseJsonResponse(jsonData)
            
            switch responseResult {
            case .success(let response):
                if let responseDictionary = response as? [String: Any],
                    let venuesJsonArray = responseDictionary[APIConstants.ResponseKeys.kVenues] as? [[String: Any]] {
                    
                    var venues = [Venue]()
                    venuesJsonArray.forEach {
                        if let venue = apiResponseParser.decodeJsonDictionary($0, returning: Venue.self) {
                            venues.append(venue)
                        }
                    }
                    
                    return .success(venues)
                } else {
                    return .failure(.couldntParse)
                }
            case .failure:
                return responseResult
            }
        } catch (let error) {
            print(error.localizedDescription)
            return .failure(.couldntParse)
        }
    }
    
    private func parseSingleVenueResponseData(_ data: Data) -> Result {
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            let responseResult = apiResponseParser.parseBaseJsonResponse(jsonData)
            
            switch responseResult {
            case .success(let response):
                if let responseDictionary = response as? [String: Any],
                    let venueJson = responseDictionary[APIConstants.ResponseKeys.kVenue] as? [String: Any],
                    let venue = apiResponseParser.decodeJsonDictionary(venueJson, returning: Venue.self) {
                    return .success(venue)
                } else {
                    return .failure(.couldntParse)
                }
            case .failure:
                return responseResult
            }
        } catch (let error) {
            print(error.localizedDescription)
            return .failure(.couldntParse)
        }
    }
    
}
