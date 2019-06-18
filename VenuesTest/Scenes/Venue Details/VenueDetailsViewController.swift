//
//  VenueDetailsViewController.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 14.06.19.
//  Copyright (c) 2019 Plamen SH. All rights reserved.
//

import UIKit
import MapKit

class VenueDetailsViewController: UIViewController, VenueDetailsPresenterToViewProtocol, StoryboardInitializable, AlertDisplayer {
    
    var presenter: VenueDetailsPresenter!
    var venueId: String?
    
    var viewState: ViewState = .empty {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                switch self.viewState {
                case .empty:
                    self.emptyView.isHidden = false
                    self.scrollView.isHidden = true
                case .populated:
                    self.emptyView.isHidden = true
                    self.scrollView.isHidden = false
                    self.scrollView.flashScrollIndicators()
                    
                default: break
                }
            }
            
        }
    }
    
    var navigationBarVenueRating: UIBarButtonItem = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        label.textColor = .yellow
        label.backgroundColor = #colorLiteral(red: 0.0009257656639, green: 0.1973014523, blue: 0.3920739542, alpha: 1)
        label.cornerRadius = 20
        label.borderColor = .yellow
        label.borderWidth = 2
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return UIBarButtonItem(customView: label)
    }()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var noResultsLabel: UILabel!
    
    @IBOutlet weak var openClosedContainer: UIView!
    @IBOutlet weak var openClosedStatusLabel: UILabel!
    @IBOutlet weak var openClosedNowLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var addressContainer: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var gpsButton: UIButton!
    
    @IBOutlet weak var contactTableView: UITableView!
    @IBOutlet weak var contactTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Object lifecycle
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Do not ask for presenter before this call
        self.setupVIPER()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        // Do not ask for presenter before this call
        self.setupVIPER()
    }
    
    // MARK: - Initilization
    private func setupVIPER() {
        VenueDetailsConfigurator.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupUI()
        loadContent()
    }
    
    private func setupUI() {
        setupBackgroundAppearances()
        setupTextAppearances()
    }
    
    private func setupBackgroundAppearances() {
        view.backgroundColor = #colorLiteral(red: 0.0009257656639, green: 0.1973014523, blue: 0.3920739542, alpha: 1)
        emptyView.backgroundColor = #colorLiteral(red: 0.0009257656639, green: 0.1973014523, blue: 0.3920739542, alpha: 1)
        scrollContentView.backgroundColor = #colorLiteral(red: 0.0009257656639, green: 0.1973014523, blue: 0.3920739542, alpha: 1)
        contactTableView.backgroundColor = .clear
        openClosedContainer.backgroundColor = #colorLiteral(red: 0.5484076142, green: 0.5710660815, blue: 0.6754823327, alpha: 1)
        addressContainer.backgroundColor = #colorLiteral(red: 0.5484076142, green: 0.5710660815, blue: 0.6754823327, alpha: 1)
        menuButton.backgroundColor = #colorLiteral(red: 0.5484076142, green: 0.5710660815, blue: 0.6754823327, alpha: 1)
        gpsButton.setImageForAllStates(#imageLiteral(resourceName: "directions"))
    }
    
    private func setupTextAppearances() {
        noResultsLabel.text = Title.kNoDetails.capitalized
        noResultsLabel.textColor = .white
        noResultsLabel.font = UIFont.systemFont(ofSize: 18)
        openClosedStatusLabel.font = UIFont.systemFont(ofSize: 16)
        openClosedStatusLabel.textColor = #colorLiteral(red: 0.0009257656639, green: 0.1973014523, blue: 0.3920739542, alpha: 1)
        openClosedStatusLabel.adjustsFontSizeToFitWidth = true
        openClosedNowLabel.font = UIFont.boldSystemFont(ofSize: 14)
        addressLabel.font = UIFont.systemFont(ofSize: 16)
        addressLabel.textColor = #colorLiteral(red: 0, green: 0.1960784314, blue: 0.3921568627, alpha: 1)
        addressLabel.adjustsFontSizeToFitWidth = true
        menuButton.setTitleForAllStates(Title.kMenu)
        menuButton.titleLabel?.font = UIFont.systemFont(ofSize: 26)
        menuButton.setTitleColor(#colorLiteral(red: 0.0009257656639, green: 0.1973014523, blue: 0.3920739542, alpha: 1), for: .normal)
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .white
    }
    
    private func loadContent() {
        guard let safeVenueId = venueId else {
            viewState = .empty
            return
        }
        presenter.loadContentForVenue(with: safeVenueId)
    }
    
    func updateUI(with venue: Venue) {
        DispatchQueue.main.async { [weak self] in
            guard let safeSelf = self else { return }
            
            if let ratingLabel = safeSelf.navigationBarVenueRating.customView as? UILabel, let rating = venue.rating {
                ratingLabel.text = String(format: "%.1f", rating)
                safeSelf.navigationItem.rightBarButtonItem = safeSelf.navigationBarVenueRating
            } else {
                safeSelf.navigationItem.rightBarButtonItem = nil
            }
            
            safeSelf.navigationItem.title = venue.name
            safeSelf.descriptionLabel.text = venue.description
            safeSelf.updateOpenClosedHoursUI(with: venue.hours)
            safeSelf.updateLocationUI(with: venue.location)
            safeSelf.updateContactUI(with: venue.contact)
            safeSelf.updateMenuUI(with: venue.menu)
        }
    }
    
    func updateOpenClosedHoursUI(with hours: Hours?) {
        if let safeHours = hours, let isOpen = safeHours.isOpen {
            openClosedStatusLabel.text = safeHours.status
            if isOpen {
                openClosedNowLabel.text = Title.kOpen.uppercased()
                openClosedNowLabel.textColor = .green
            } else {
                openClosedNowLabel.text = Title.kClosed.uppercased()
                openClosedNowLabel.textColor = .red
            }
        } else {
            openClosedContainer.isHidden = true
        }
    }
    
    func updateLocationUI(with location: Location?) {
        if let safeLocation = location {
            mapView.addCenteredAnnotation(latitude: safeLocation.lat, longitude: safeLocation.lng)
            addressLabel.text = safeLocation.fullAddress
        } else {
            mapView.isHidden = true
            addressContainer.isHidden = true
        }
    }
    
    func updateContactUI(with contact: Contact?) {
        if let _ = contact {
            let contactTableViewHeight = CGFloat(presenter.calculateContactTableViewHeight())
            contactTableViewHeightConstraint.constant = contactTableViewHeight
            contactTableView.reloadData()
        } else {
            contactTableViewHeightConstraint.constant = 0
        }
    }
    
    func updateMenuUI(with menu: Menu?) {
        if let safeMenu = menu, let _ = safeMenu.menuURL {
            menuButton.isHidden = false
        } else {
            menuButton.isHidden = true
        }
    }
    
    // MARK: - PresenterToViewProtocol
    func updateViewState(with state: ViewState) {
        viewState = state
    }
    
    func displayError(message: String) {
        showErrorAlertWithOK(message: message)
    }
    
    // MARK: - Actions
    @IBAction func gpsButtonTapped(_ sender: UIButton) {
        presenter.gpsPressed()
    }
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        presenter.menuPressed()
    }
}

//MARK: - TableView Methods
extension VenueDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    private func setupTableView() {
        contactTableView.delegate = self
        contactTableView.dataSource = self
        contactTableView.separatorStyle = .none
        contactTableView.alwaysBounceVertical = false
        contactTableView.register(UITableViewCell.self, forCellReuseIdentifier: HyperlinkTableView.kCellIdentifier)
        contactTableView.estimatedRowHeight = CGFloat(HyperlinkTableView.kEstimatedRowHeight)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.contactHyperlinksCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let hyperLink = presenter.contactHyperlink(at: indexPath.row) else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HyperlinkTableView.kCellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .white
        cell.textLabel?.attributedText = hyperLink.text.underline

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.contactHyperlinkPressed(at: indexPath)
    }
}

