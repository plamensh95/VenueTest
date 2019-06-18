//
//  Venue.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 14.06.19.
//  Copyright © 2019 Plamen SH. All rights reserved.
//

import Foundation

struct Venue: Codable {
    
    let id: String
    let name: String?
    let description: String?
    let url: String?
    let rating: Double?
    let hours: Hours?
    let menu: Menu?
    let contact: Contact?
    let location: Location?
    
    init(id: String = UUID().uuidString, name: String?, description: String?, url: String?,
         rating: Double?, hours: Hours?, menu: Menu?, contact: Contact?, location: Location?) {
        self.id = id
        self.name = name
        self.description = description
        self.url = url
        self.rating = rating
        self.menu = menu
        self.hours = hours
        self.contact = contact
        self.location = location
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? CodableConstants.kDefaultFallbackString
        description = try container.decodeIfPresent(String.self, forKey: .description)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        rating = try container.decodeIfPresent(Double.self, forKey: .rating)
        menu = try container.decodeIfPresent(Menu.self, forKey: .menu)
        hours = try container.decodeIfPresent(Hours.self, forKey: .hours)
        contact = try container.decodeIfPresent(Contact.self, forKey: .contact)
        location = try container.decodeIfPresent(Location.self, forKey: .location)
    }
}
