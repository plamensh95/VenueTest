//
//  VenueDetailsProtocols.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 14.06.19.
//  Copyright (c) 2019 Plamen SH. All rights reserved.
//

import Foundation
import CoreLocation

//ViewController -> Presenter
protocol VenueDetailsViewToPresenterProtocol: class{
    func loadContentForVenue(with venueId: String)
    func calculateContactTableViewHeight() -> Double
    func contactHyperlinksCount() -> Int
    func contactHyperlink(at index: Int) -> Hyperlink?
    func contactHyperlinkPressed(at indexPath: IndexPath)
    func menuPressed()
    func gpsPressed()
}

//Presenter -> ViewController
protocol VenueDetailsPresenterToViewProtocol: class{
    func updateViewState(with: ViewState)
    func updateUI(with venue: Venue)
    func displayError(message: String)
}

//Presenter -> Router
protocol VenueDetailsPresenterToRouterProtocol: class{
    func navigateToIntent(with url: URL)
    func navigateToGPS(with location: Location)
}

//Presenter -> Interactor
protocol VenueDetailsPresentorToInterectorProtocol: class{
    func fetchVenueDetails(venueId: String)
}

//Interactor -> Presenter
protocol VenueDetailsInterectorToPresenterProtocol: class{
    func venueDetailsFetched(venue: Venue)
    func fetchDetailsErrorOccured(error: CustomError)
}






