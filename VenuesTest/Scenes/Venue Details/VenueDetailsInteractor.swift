//
//  VenueDetailsInteractor.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 14.06.19.
//  Copyright (c) 2019 Plamen SH. All rights reserved.
//

import Foundation
import UIKit

class VenueDetailsInteractor: VenueDetailsPresentorToInterectorProtocol {
    
    weak var presenter: VenueDetailsInterectorToPresenterProtocol?
    
    private let repository: Repository
    
    init(repository: Repository = Injector.injectRepositoryDependency()) {
        self.repository = repository
    }
    
    // MARK: - PresentorToInterectorProtocol
    func fetchVenueDetails(venueId: String) {
        repository.getVenueDetails(with: venueId) { [weak self] result in
            guard let safeSelf = self else { return }
            
            switch(result) {
            case .success(let venues):
                if let safeVenueDetails = venues as? Venue {
                    safeSelf.presenter?.venueDetailsFetched(venue: safeVenueDetails)
                } else {
                    safeSelf.presenter?.fetchDetailsErrorOccured(error: .couldntParse)
                }
            case .failure(let error):
                safeSelf.presenter?.fetchDetailsErrorOccured(error: error)
            }
        }
    }
}
