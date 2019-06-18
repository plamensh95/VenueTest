//
//  Hours.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 17.06.19.
//  Copyright © 2019 Plamen SH. All rights reserved.
//

struct Hours: Codable {
    let status: String?
    let isOpen: Bool?
    
    init(status: String?, isOpen: Bool?) {
        self.status = status
        self.isOpen = isOpen
    }
}
