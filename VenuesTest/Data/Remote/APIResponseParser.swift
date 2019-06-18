//
//  APIResponseParser.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 14.06.19.
//  Copyright © 2019 Plamen SH. All rights reserved.
//

import Foundation

class APIResponseParser {
    
    lazy var decoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    func parseBaseJsonResponse(_ jsonData: Any) -> Result {
        guard let wrapperDictionary = jsonData as? [String: Any] else { return .failure(.couldntParse) }
        
        if let metaDictionary = wrapperDictionary[APIConstants.ResponseKeys.kMeta] as? [String: Any],
            let errorCode = metaDictionary[APIConstants.ResponseKeys.kErrorCode] as? Int,
            errorCode == APIConstants.ErrorCodes.quotaExceeded.rawValue {
            return .failure(.quotaExceeded)
        } else if let responseDictionary = wrapperDictionary[APIConstants.ResponseKeys.kResponse] as? [String: Any] {
            return .success(responseDictionary)
        } else {
            return .failure(.couldntParse)
        }
    }
    
    func decodeJsonDictionary<T: Decodable>(_ jsonDictionary: [String: Any], returning type: T.Type) -> T? {
        do {
            guard JSONSerialization.isValidJSONObject(jsonDictionary),
                let jsonData = try? JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted) else {
                return nil
            }

            return try decoder.decode(T.self, from: jsonData)
        } catch (let error){
            print(error.localizedDescription)
            return nil
        }
    }
}
