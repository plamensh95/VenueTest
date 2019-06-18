//
//  VenuesViewController.swift
//  VenuesTest
//
//  Created by Plamen Iliev on 14.06.19.
//  Copyright (c) 2019 Plamen SH. All rights reserved.
//

import UIKit
import CoreLocation

enum ViewState {
    case empty
    case populated
    case detectingLocation
}

class VenuesViewController: UIViewController, VenuesPresenterToViewProtocol, StoryboardInitializable, AlertDisplayer {

    var presenter: VenuesPresenter!
    var searchTask: DispatchWorkItem?
    
    let locationManager = CLLocationManager()
    
    @IBOutlet private weak var detectingLocationView: UIView!
    @IBOutlet private weak var emptyView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var noResultsLabel: UILabel!
    @IBOutlet private weak var detectingLocationLabel: UILabel!
    @IBOutlet private weak var detectingLocationActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var stopDetectingLocationButton: UIButton!
    
    lazy var searchBar: UISearchBar = {
        let searchbar = UISearchBar(frame: CGRect(x: 0, y: 0, width:
            view.bounds.width - 50, height: 20))
        searchbar.placeholder = Title.kSearchVenues
        return searchbar
    }()
    
    var viewState: ViewState = .empty {
        didSet {
            guard viewState != oldValue else { return }
            
            DispatchQueue.main.async { [unowned self] in
                switch self.viewState {
                case .empty:
                    self.searchBar.isUserInteractionEnabled = true
                    self.detectingLocationView.isHidden = true
                    self.emptyView.isHidden = false
                    self.tableView.reloadData()
                case .populated:
                    self.searchBar.isUserInteractionEnabled = true
                    self.detectingLocationView.isHidden = true
                    self.emptyView.isHidden = true
                    self.tableView.reloadData()
                case .detectingLocation:
                    self.searchBar.isUserInteractionEnabled = false
                    self.detectingLocationView.isHidden = false
                    self.emptyView.isHidden = true
                }
            }
        }
    }
    
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
        VenuesConfigurator.configure(viewController: self)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableView()
        setupSearchBarDelegate()
        checkLocationServices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.titleView = searchBar
    }
    
    // MARK: - Setup
    private func setupUI() {
        setupBackgroundAppearances()
        setupTextAppearances()
    }
    
    private func setupBackgroundAppearances() {
        view.backgroundColor = #colorLiteral(red: 0.0009257656639, green: 0.1973014523, blue: 0.3920739542, alpha: 1)
        emptyView.backgroundColor = #colorLiteral(red: 0.0009257656639, green: 0.1973014523, blue: 0.3920739542, alpha: 1)
        detectingLocationView.backgroundColor = #colorLiteral(red: 0.0009257656639, green: 0.1973014523, blue: 0.3920739542, alpha: 1)
        tableView.backgroundColor = .clear
        stopDetectingLocationButton.backgroundColor = .white
        stopDetectingLocationButton.cornerRadius = 10
    }
    
    private func setupTextAppearances() {
        detectingLocationLabel.text = Title.kDetectingCurrentLocation
        detectingLocationLabel.textColor = .white
        detectingLocationLabel.font = UIFont.systemFont(ofSize: 16)
        noResultsLabel.text = Title.kNoResultsFound.capitalized
        noResultsLabel.textColor = .white
        noResultsLabel.font = UIFont.systemFont(ofSize: 18)
        stopDetectingLocationButton.setTitleForAllStates(Title.kStopDetecting)
        stopDetectingLocationButton.setTitleColorForAllStates(#colorLiteral(red: 0.0009257656639, green: 0.1973014523, blue: 0.3920739542, alpha: 1))
    }
    
    private func searchVenues(for locationName: String) {
        presenter.locationNameSearched(locationName: locationName)
    }

    // MARK: - Actions
    @IBAction func stopDetectingLocationButtonTapped(_ sender: UIButton) {
        stopDetectingLocation()
    }

    // MARK: - PresenterToViewProtocol
    func updateViewState(with state: ViewState) {
        viewState = state
    }
    
    func displayError(message: String) {
        DispatchQueue.main.async {
            AlertManager.sharedInstance.showErrorAlert(message: message)
        }
    }
    
}

//MARK: - TableView Methods
extension VenuesViewController: UITableViewDelegate, UITableViewDataSource {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(VenueTableViewCell.nib, forCellReuseIdentifier: VenueTableViewCell.reuseIdentifier)
        tableView.estimatedRowHeight = VenueTableViewCell.kEstimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.venuesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let venue = presenter.venue(at: indexPath.row) else { return UITableViewCell() }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            VenueTableViewCell.reuseIdentifier, for: indexPath) as? VenueTableViewCell {
            cell.populate(with: venue)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.venuePressed(at: indexPath)
    }
}

//MARK: - SearchBar Methods
extension VenuesViewController: UISearchBarDelegate {
    private func setupSearchBarDelegate() {
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTask?.cancel()
        
        let task = DispatchWorkItem { [weak self] in
            self?.searchVenues(for: searchText)
        }
        self.searchTask = task
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: task)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

//MARK: - LocationManager Methods
extension VenuesViewController: CLLocationManagerDelegate {
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            viewState = .detectingLocation
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            showMessageAlert(message : Message.kLocationServicesDisabled)
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func detectLocation() {
        viewState = .detectingLocation
        locationManager.requestLocation()
    }
    
    private func stopDetectingLocation() {
        viewState = .empty
        locationManager.stopUpdatingLocation()
    }
    
    private func handleDetectLocationFailure() {
        showErrorAlertWithTryAgain(title: Title.Error.kFailedToDetectLocation) { shouldTryAgain in
            if shouldTryAgain {
                self.detectLocation()
            }
        }
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            detectLocation()
        case .denied:
            showMessageAlert(message : Message.kLocationServicesDenied)
            viewState = .empty
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            viewState = .empty
            showMessageAlert(message : Message.kLocationServicesRestricted)
            break
        case .authorizedAlways:
            // The application is authorized to access location services also when the app is killed.
            // Our application is not asking for this type of location, so we will never hit this case.
            break
        }
    }
    
    
    // CLLocationDelegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            presenter.locationCoordinatesDetected(location: location)
        } else {
            handleDetectLocationFailure()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        handleDetectLocationFailure()
    }
}
