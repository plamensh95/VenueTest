//
//  Menu.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 17.06.19.
//  Copyright © 2019 Plamen SH. All rights reserved.
//

struct Menu: Codable {
    let url: String?
    let mobileUrl: String?
    
    init(url: String?, mobileUrl: String?) {
        self.url = url
        self.mobileUrl = mobileUrl
    }
}

// MARK: Computed properties
extension Menu {
    var menuURL: String? {
        get {
            return mobileUrl ?? url ?? nil
        }
    }
}

