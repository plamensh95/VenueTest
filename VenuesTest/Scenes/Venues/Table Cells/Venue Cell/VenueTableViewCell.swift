//
//  VenueTableViewCell.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 17.06.19.
//  Copyright © 2019 Plamen SH. All rights reserved.
//

import UIKit
import SwifterSwift

class VenueTableViewCell: UITableViewCell {

    static let nib = UINib(nibName: "VenueTableViewCell", bundle: nil)
    static let reuseIdentifier = "cellReuseIdentifier_VenueTableViewCell"
    static let kEstimatedRowHeight: CGFloat = 100.0
    
    @IBOutlet var lineViews: [UIView]!
    
    @IBOutlet private weak var venueNameLabel: UILabel!
    @IBOutlet private weak var venueDistanceLabel: UILabel!
    @IBOutlet private weak var venueAddressLabel: UILabel!
    @IBOutlet private weak var venueCityAndCountryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        setupBackgroundAppearances()
        setupTextAppearances()
    }
    
    private func setupBackgroundAppearances() {
        selectionStyle = .none
        backgroundColor = .clear
        venueDistanceLabel.backgroundColor = .lightGray
        venueDistanceLabel.cornerRadius = 10
        lineViews.forEach { $0.backgroundColor = .black }
    }
    
    private func setupTextAppearances() {
        venueNameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        venueNameLabel.numberOfLines = 0
        venueNameLabel.adjustsFontSizeToFitWidth = true
        venueDistanceLabel.font = UIFont.boldSystemFont(ofSize: 14)
        venueDistanceLabel.adjustsFontSizeToFitWidth = true
        venueAddressLabel.font = UIFont.systemFont(ofSize: 16)
        venueAddressLabel.adjustsFontSizeToFitWidth = true
        venueCityAndCountryLabel.font = UIFont.systemFont(ofSize: 16)
        venueCityAndCountryLabel.adjustsFontSizeToFitWidth = true
    }
    
    // MARK: - Population
    func populate(with venue: Venue) {
        venueNameLabel.text = venue.name
        if let safeDistanceAway = venue.location?.distanceAway {
            venueDistanceLabel.text = safeDistanceAway
        } else {
            venueDistanceLabel.isHidden = true
        }
        venueAddressLabel.text = venue.location?.address
        venueCityAndCountryLabel.text = venue.location?.cityAndCountry
    }
    
}
