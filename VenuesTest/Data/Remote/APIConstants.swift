//
//  APIConstants.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 18.06.19.
//  Copyright © 2019 Plamen SH. All rights reserved.
//

struct APIConstants {
    static let kScheme = "https"
    static let kHost = "api.foursquare.com"
    static let kApiVer = "/v2"
    static let kVenues = "/venues"
    static let kTrending = "/search"
    
    struct QueryKeys {
        static let kClientId = "client_id"
        static let kClientSecret = "client_secret"
        
        static let kNear = "near"
        static let kLimit = "limit"
        static let kRadius = "radius"
        static let kCoordinates = "ll"
        static let kVersion = "v"
    }
    
    struct QueryValues {
        static let kClientId = "MFOERJESKA33ZANQJWMSHMYUQQLOSSXH1V03QZ3CCIFBM3DH"
        static let kClientSecret = "Z0LET45WQQKBUZKBDSXTUUM5ICVABEQQVTW0X4X22ASGT4MP"
        static let kDefaultLimit = 100
        static let kDefaultRadius = 1000
    }
    
    struct ResponseKeys {
        static let kMeta = "meta"
        static let kErrorCode = "code"
        static let kResponse = "response"
        static let kVenues = "venues"
        static let kVenue = "venue"
    }
    
    enum ErrorCodes: Int {
        case quotaExceeded = 429
    }
}
