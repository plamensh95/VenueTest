//
//  MKMapView+Extensions.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 19.06.19.
//  Copyright © 2019 Plamen SH. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
    func addCenteredAnnotation(latitude: Double, longitude: Double) {
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let regionRadius: CLLocationDistance = Double(APIConstants.QueryValues.kDefaultRadius)
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        addAnnotation(annotation)
    }
}
