//
//  Repository.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 14.06.19.
//  Copyright © 2019 Plamen SH. All rights reserved.
//

import Foundation

class Repository {
    private let remoteRepository: RemoteRepository
    
    // MARK: - Initialization
    init(remoteRepository: RemoteRepository = Injector.injectRemoteRepositoryDependency()) {
        self.remoteRepository = remoteRepository
    }
    
    func getVenues(with parameters: [String: String], completion: @escaping (Result) -> ()) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let safeSelf = self else { return }
            return safeSelf.remoteRepository.searchVenues(with: parameters, completion: completion)
        }
    }
    
    func getVenueDetails(with venueId: String, completion: @escaping (Result) -> ()) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let safeSelf = self else { return }
            return safeSelf.remoteRepository.getVenueDetails(with: venueId, completion: completion)
        }
    }
}
