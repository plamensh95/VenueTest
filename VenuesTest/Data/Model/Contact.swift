//
//  Contact.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 17.06.19.
//  Copyright © 2019 Plamen SH. All rights reserved.
//
import Foundation

struct Contact: Codable {
    let phone: String?
    let formattedPhone: String?
    let twitter: String?
    let facebook: String?
    let facebookUsername: String?
    
    init(phone: String?, formattedPhone: String?, twitter: String?,
         facebook: String?, facebookUsername: String?) {
        self.phone = phone
        self.formattedPhone = formattedPhone
        self.twitter = twitter
        self.facebook = facebook
        self.facebookUsername = facebookUsername
    }
}

// MARK: Computed properties
extension Contact {
    
    var availableHyperlinks: [Hyperlink] {
        get {
            return [phoneHyperlink, twitterHyperlink, facebookHyperlink].compactMap { $0 }
        }
    }
    
    var phoneHyperlink: Hyperlink? {
        get {
            let phoneNumber =  formattedPhone ?? phone
            if let safePhoneNumber = phoneNumber, let url = URL(string: "\(ContactConstants.kPhoneScheme)\(safePhoneNumber)") {
                return ("Phone - \(safePhoneNumber)", url)
            } else {
                return nil
            }
        }
    }
    
    var twitterHyperlink: Hyperlink? {
        get {
            if let safeProfilePath = twitter, let url = URL(string: "\(ContactConstants.kTwitterBaseURL)\(safeProfilePath)") {
                return ("Twitter - \(url)", url)
            } else {
                return nil
            }
        }
    }
    
    var facebookHyperlink: Hyperlink? {
        get {
            let profilePath = facebookUsername ?? facebook
            if let safeProfilePath = profilePath, let url = URL(string: "\(ContactConstants.kFacebookBaseURL)\(safeProfilePath)") {
                return ("Facebook - \(url)", url)
            } else {
                return nil
            }
        }
    }
}
