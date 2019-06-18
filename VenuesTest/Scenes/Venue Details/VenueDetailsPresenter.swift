//
//  VenueDetailsPresenter.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 14.06.19.
//  Copyright (c) 2019 Plamen SH. All rights reserved.
//

import Foundation

class VenueDetailsPresenter {
    
    weak var view: VenueDetailsPresenterToViewProtocol?
    
    var interactor: VenueDetailsPresentorToInterectorProtocol
    var router: VenueDetailsPresenterToRouterProtocol

    private var venueDetails: Venue? {
        didSet {
            if let safeVenueDetails = venueDetails {
                if let contact = safeVenueDetails.contact {
                    contactHyperlinks = contact.availableHyperlinks
                }
                view?.updateUI(with: safeVenueDetails)
                view?.updateViewState(with: .populated)
            } else {
                view?.updateViewState(with: .empty)
            }
        }
    }
    
    private var contactHyperlinks = [Hyperlink]()
    
    required init(with interactor: VenueDetailsPresentorToInterectorProtocol, router: VenueDetailsPresenterToRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension VenueDetailsPresenter: VenueDetailsViewToPresenterProtocol {
    func loadContentForVenue(with venueId: String) {
        interactor.fetchVenueDetails(venueId: venueId)
    }
    
    func calculateContactTableViewHeight() -> Double {
        return Double(contactHyperlinks.count) * HyperlinkTableView.kEstimatedRowHeight
    }
    
    func contactHyperlinksCount() -> Int {
        return contactHyperlinks.count
    }
    
    func contactHyperlink(at index: Int) -> Hyperlink? {
        guard index < contactHyperlinks.count else { return nil }
        return contactHyperlinks[index]
    }
    
    func contactHyperlinkPressed(at indexPath: IndexPath) {
        guard let hyperlink = contactHyperlink(at: indexPath.row) else { return }
        router.navigateToIntent(with: hyperlink.url)
    }
    
    func menuPressed() {
        guard let menuURL = venueDetails?.menu?.menuURL, let menuIntentURL = URL(string: menuURL) else { return }
        router.navigateToIntent(with: menuIntentURL)
    }
    
    func gpsPressed() {
        guard let location = venueDetails?.location else { return }
        router.navigateToGPS(with: location)
    }
}

extension VenueDetailsPresenter: VenueDetailsInterectorToPresenterProtocol {
    func venueDetailsFetched(venue: Venue) {
        venueDetails = venue
    }
    
    func fetchDetailsErrorOccured(error: CustomError) {
        venueDetails = nil
        view?.displayError(message: error.localizedDescription)
    }
    
}
