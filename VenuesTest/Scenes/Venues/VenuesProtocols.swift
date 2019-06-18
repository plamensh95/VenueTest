//
//  VenuesProtocols.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 14.06.19.
//  Copyright (c) 2019 Plamen SH. All rights reserved.
//

import Foundation
import CoreLocation

//ViewController -> Presenter
protocol VenuesViewToPresenterProtocol: class{
    func locationCoordinatesDetected(location: CLLocation)
    func locationNameSearched(locationName: String)
    func venuesCount() -> Int
    func venue(at index: Int) -> Venue?
    func venuePressed(at indexPath: IndexPath)
}

//Presenter -> ViewController
protocol VenuesPresenterToViewProtocol: class{
    func updateViewState(with state: ViewState)
    func displayError(message: String)
}

//Presenter -> Router
protocol VenuesPresenterToRouterProtocol: class{
    func navigateToVenueDetails(with venueId: String)
}

//Presenter -> Interactor
protocol VenuesPresentorToInterectorProtocol: class{
    func fetchVenues(latitude: Double, longitude: Double)
    func fetchVenues(with locationName: String)
}

//Interactor -> Presenter
protocol VenuesInterectorToPresenterProtocol: class{
    func venuesFetched(_ fetchedVenues: [Venue])
    func errorOccured(error: CustomError)
}






