//
//  Location.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 14.06.19.
//  Copyright © 2019 Plamen SH. All rights reserved.
//

import Foundation

struct Location: Codable {
    
    let lat: Double
    let lng: Double
    let distance: Double?
    let address: String?
    let city: String?
    let country: String?
    
    init(lat: Double, lng: Double, distance: Double?,
         address: String?, city: String?, country: String?) {
        self.address = address
        self.city = city
        self.country = country
        self.lat = lat
        self.lng = lng
        self.distance = distance
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lat = try container.decodeIfPresent(Double.self, forKey: .lat) ?? CodableConstants.kDefaultFallbackLattitude
        lng = try container.decodeIfPresent(Double.self, forKey: .lng) ?? CodableConstants.kDefaultFallbackLongitude
        distance = try container.decodeIfPresent(Double.self, forKey: .distance)
        address = try container.decodeIfPresent(String.self, forKey: .address) ?? CodableConstants.kDefaultFallbackString
        city = try container.decodeIfPresent(String.self, forKey: .city)
        country = try container.decodeIfPresent(String.self, forKey: .country)
    }
}

// MARK: Computed properties
extension Location {
    var fullAddress: String {
        get {
            var safeFullAddress = address ?? CodableConstants.kDefaultFallbackString
            
            if let safeCity = city {
                safeFullAddress.append(", \(safeCity)")
            }
            if let safeCountry = country {
                safeFullAddress.append(", \(safeCountry)")
            }
            return safeFullAddress
        }
    }
    
    var cityAndCountry: String {
        var cityCountry = city ?? CodableConstants.kDefaultFallbackString
        
        if let safeCountry = country {
            cityCountry.append(", \(safeCountry)")
        }
        return cityCountry
    }
    
    var distanceAway: String? {
        get {
            if let safeDistanceInAppropriateUnits = distanceInAppropriateUnits {
                return "\(safeDistanceInAppropriateUnits) away"
            } else {
                return nil
            }
        }
    }
    
    var distanceInAppropriateUnits: Measurement<UnitLength>? {
        get {
            if let safeDistance = distance {
                return Measurement(value: safeDistance, unit: safeDistance < 1000 ? UnitLength.meters : UnitLength.kilometers)
            } else {
                return nil
            }
        }
    }
}
