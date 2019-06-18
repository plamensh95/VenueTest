//
//  Constants.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 14.06.19.
//  Copyright © 2019 Plamen SH. All rights reserved.
//
import Foundation

typealias Hyperlink = (text: String, url: URL)

struct ContactConstants {
    static let kTwitterBaseURL = "https://twitter.com/"
    static let kFacebookBaseURL = "https://www.facebook.com/"
    static let kPhoneScheme = "tel://"
}

struct CodableConstants {
    static let kDefaultFallbackString = "Unknown"
    static let kDefaultFallbackLattitude = 34.8
    static let kDefaultFallbackLongitude = -48.3
    static let kDefaultFallbackDistance = 0.0
}

struct Title {
    static let kOK = "OK"
    static let kTryAgain = "Try Again"
    static let kCancel = "Cancel"
    static let kErrorOccured = "An Error Occured"
    static let kNoResultsFound = "No results found"
    static let kNoDetails = "No details for this venue"
    static let kSearchVenues = "Search Venues..."
    static let kDetectingCurrentLocation = "Detecting current location..."
    static let kStopDetecting = "Stop Detecting"
    static let kMenu = "Menu"
    static let kOpen = "Open"
    static let kClosed = "Closed"
    
    struct Error {
        static let kFailedToDetectLocation = "Failed to detect location"
    }
}

struct Message {
    static let kReachServerError = "Couldn't reach server."
    static let kParseServerResponseError = "Couldn't parse server response."
    static let kSomethingWentWrong = "Something went wrong."
    static let kTryAgain = "Do you want to try again?"
    static let kQuotaExceeded = "You have exceed the API requests quota for the day."
    static let kLocationServicesDisabled = "Location services are disabled. If you would like to see all nearby venues, please enable your location services."
    static let kLocationServicesDenied = "You have already denied location services permission. If you would like to see all nearby venues, please grant permission to this application explicitly from device settings"
    static let kLocationServicesRestricted = "Location services are restricted. If you would like to see all nearby venues, please remove the restriction."
}

struct HyperlinkTableView {
    static let kCellIdentifier = "cellReuseIdentifier_HyperlinkTableViewCell"
    static let kEstimatedRowHeight = 50.0
}
