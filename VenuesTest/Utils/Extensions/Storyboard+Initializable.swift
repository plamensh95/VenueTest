//
//  Storyboard+Initializable.swift
//  WeatherApp
//
//  Created by Plamen Iliev on 30.05.19.
//  Copyright © 2019 Plamen SH. All rights reserved.
//

import UIKit

enum Storyboard:String {
    case Venues
    case VenueDetails
}

protocol StoryboardInitializable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardInitializable where Self: UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: Self.self)
    }
    
    static func initFrom(storyboard: Storyboard) -> Self {
        let storyBoard = UIStoryboard(name: storyboard.rawValue, bundle: Bundle.main)
        let viewController = storyBoard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
        viewController.title = storyboard.rawValue
        return viewController
    }
}
