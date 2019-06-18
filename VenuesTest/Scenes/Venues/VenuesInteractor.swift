//
//  VenuesInteractor.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 14.06.19.
//  Copyright (c) 2019 Plamen SH. All rights reserved.
//

import Foundation

class VenuesInteractor: VenuesPresentorToInterectorProtocol {

    weak var presenter: VenuesInterectorToPresenterProtocol?
    
    private let repository: Repository

    init(repository: Repository = Injector.injectRepositoryDependency()) {
        self.repository = repository
    }
    
    private func fetchVenues(with parameters: [String: String]) {
        repository.getVenues(with: parameters) { [weak self] result in
            guard let safeSelf = self else { return }
            
            switch(result) {
            case .success(let venues):
                if let safeVenues = venues as? [Venue] {
                    safeSelf.presenter?.venuesFetched(safeVenues)
                } else {
                    safeSelf.presenter?.errorOccured(error: .couldntParse)
                }
            case .failure(let error):
                safeSelf.presenter?.errorOccured(error: error)
            }
        }
    }
    
    private func buildParameters(with latitude: Double?, and longitude: Double?, locationName: String?) -> [String: String] {
        
        var parameters = [APIConstants.QueryKeys.kLimit: String(describing: APIConstants.QueryValues.kDefaultLimit),
                          APIConstants.QueryKeys.kRadius: String(describing: APIConstants.QueryValues.kDefaultRadius)]
        
        if let safeLocationName = locationName {
            parameters[APIConstants.QueryKeys.kNear] = safeLocationName
        } else if let safeLatitude = latitude, let safeLongitude = longitude {
            parameters[APIConstants.QueryKeys.kCoordinates] = "\(safeLatitude),\(safeLongitude)"
        }
        
        return parameters
    }
    
    // MARK: - PresentorToInterectorProtocol
    func fetchVenues(latitude: Double, longitude: Double) {
        let parameters = buildParameters(with: latitude, and: longitude, locationName: nil)
        fetchVenues(with: parameters)
    }
    
    func fetchVenues(with locationName: String) {
        let parameters = buildParameters(with: nil, and: nil, locationName: locationName)
        fetchVenues(with: parameters)
    }
}
