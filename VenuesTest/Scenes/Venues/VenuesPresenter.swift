//
//  VenuesPresenter.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 14.06.19.
//  Copyright (c) 2019 Plamen SH. All rights reserved.
//

import Foundation
import CoreLocation

class VenuesPresenter {
    
    weak var view: VenuesPresenterToViewProtocol?
    
    var interactor: VenuesPresentorToInterectorProtocol
    var router: VenuesPresenterToRouterProtocol
    
    private var venues = [Venue]()  {
        didSet {
            let state: ViewState = venues.isEmpty ? .empty : .populated
            view?.updateViewState(with: state)
        }
    }

    required init(with interactor: VenuesPresentorToInterectorProtocol, router: VenuesPresenterToRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
}

extension VenuesPresenter: VenuesViewToPresenterProtocol {
    func venuesCount() -> Int {
        return venues.count
    }
    
    
    func venue(at index: Int) -> Venue? {
        guard index < venues.count else { return nil }
        return venues[index]
    }
    
    func locationCoordinatesDetected(location: CLLocation) {
        interactor.fetchVenues(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func locationNameSearched(locationName: String) {
        interactor.fetchVenues(with: locationName)
    }


    func venuePressed(at indexPath: IndexPath) {
        guard let selectedVenue = venue(at: indexPath.row) else { return }
        router.navigateToVenueDetails(with: selectedVenue.id)
    }

}

extension VenuesPresenter: VenuesInterectorToPresenterProtocol {
    func venuesFetched(_ fetchedVenues: [Venue]) {
        self.venues = fetchedVenues
    }
    
    func errorOccured(error: CustomError) {
        switch error {
        case .couldntParse:
            venues = []
        default:
            view?.displayError(message: error.localizedDescription)
        }
    }
}
