//
//  APIRequestBuilder.swift
//  VIAFIK
//
//  Created by Plamen Iliev on 20.11.18.
//  Copyright © 2018 Flat Rock Technology. All rights reserved.
//

import Foundation

class APIRequestBuilder {

    private var components = URLComponents(string: "")

    @discardableResult
    func appendScheme(scheme: String) -> APIRequestBuilder {
        components?.scheme = scheme
        return self
    }
    
    @discardableResult
    func appendHost(host: String) -> APIRequestBuilder {
        components?.host = host
        return self
    }
    
    @discardableResult
    func appendPath(path: String) -> APIRequestBuilder {
        components?.path = path
        return self
    }
    
    @discardableResult
    func appendQueryParameters(parameters: [String : String]) -> APIRequestBuilder {
        components?.queryItems = parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        return self
    }
    
    func buildURL() -> URL? {
        guard let urlComponets = components, let url = urlComponets.url else { return nil }
        components = URLComponents(string: "")
        return url
    }
}

//MARK: Foursquare API
extension APIRequestBuilder {
    
    private var foursquareRequiredQueryParameters: [String: String] {
        get {
            var requiredParams = [APIConstants.QueryKeys.kClientId: APIConstants.QueryValues.kClientId,
                              APIConstants.QueryKeys.kClientSecret: APIConstants.QueryValues.kClientSecret]
            
            let now = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyymmdd"
            let versionFormattedDate = dateFormatter.string(from: now)
            requiredParams[APIConstants.QueryKeys.kVersion] = versionFormattedDate
            
            return requiredParams
        }
    }
    
    func appendFoursquareBaseURL() -> APIRequestBuilder {
        return appendScheme(scheme: APIConstants.kScheme)
            .appendHost(host: APIConstants.kHost)
    }
    
    func buildTrendingVenuesURL(with parameters: [String: String]) -> URL? {
        let queryParameters = parameters.merging(foursquareRequiredQueryParameters) { $1 }
        return appendFoursquareBaseURL()
            .appendPath(path: "\(APIConstants.kApiVer)\(APIConstants.kVenues)\(APIConstants.kTrending)")
            .appendQueryParameters(parameters: queryParameters)
            .buildURL()
    }
    
    func buildGetVenueDetailsURL(with venueId: String) -> URL? {
        return appendFoursquareBaseURL()
            .appendPath(path: "\(APIConstants.kApiVer)\(APIConstants.kVenues)/\(venueId)")
            .appendQueryParameters(parameters: foursquareRequiredQueryParameters)
            .buildURL()
    }
}
