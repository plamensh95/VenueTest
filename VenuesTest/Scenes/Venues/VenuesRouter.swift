//
//  VenuesRouter.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 14.06.19.
//  Copyright (c) 2019 Plamen SH. All rights reserved.
//

import UIKit

class VenuesRouter: VenuesPresenterToRouterProtocol {

    weak var viewController: VenuesViewController?
    
    // MARK: - Navigation
    func navigateToVenueDetails(with venueId: String) {
        let venueDetailsVC = VenueDetailsViewController.initFrom(storyboard: .VenueDetails)
        venueDetailsVC.venueId = venueId
        viewController?.navigationController?.pushViewController(venueDetailsVC, animated: true)
    }
}

