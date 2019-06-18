//
//  VenueDetailsConfigurator.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 14.06.19.
//  Copyright (c) 2019 Plamen SH. All rights reserved.
//

import Foundation

// MARK: - Configuration
class VenueDetailsConfigurator {
    
    class func configure(viewController: VenueDetailsViewController) {
        
        let router = VenueDetailsRouter()
        let interactor = VenueDetailsInteractor()
        let presenter = VenueDetailsPresenter(with: interactor, router: router)
        presenter.view = viewController
        
        interactor.presenter = presenter
        router.viewController = viewController
        viewController.presenter = presenter
    }
}
