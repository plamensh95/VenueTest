//
//  VenuesConfigurator.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 14.06.19.
//  Copyright (c) 2019 Plamen SH. All rights reserved.
//

import Foundation

// MARK: - Configuration
class VenuesConfigurator {
    
    class func configure(viewController: VenuesViewController) {
        
        let router = VenuesRouter()
        let interactor = VenuesInteractor()
        let presenter = VenuesPresenter(with: interactor, router: router)
        presenter.view = viewController
        
        interactor.presenter = presenter
        router.viewController = viewController
        viewController.presenter = presenter
    }
}
