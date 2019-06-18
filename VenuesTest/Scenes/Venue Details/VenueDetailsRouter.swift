//
//  VenueDetailsRouter.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 14.06.19.
//  Copyright (c) 2019 Plamen SH. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class VenueDetailsRouter: VenueDetailsPresenterToRouterProtocol {
    
    weak var viewController: VenueDetailsViewController?
    
    // MARK: - Navigation
    func navigateToIntent(with url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func navigateToGPS(with location: Location) {
        let coordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        mapItem.openInMaps(launchOptions: launchOptions)
    }

}

