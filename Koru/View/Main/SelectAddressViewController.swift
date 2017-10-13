/* 

=========================================================================== 
Koru GPL Source Code 
Copyright (C) 2017 Tekton Labs
This file is part of the Koru GPL Source Code.
Koru Source Code is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, either version 3 of the License, or 
(at your option) any later version. 

Koru Source Code is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Koru Source Code. If not, see <http://www.gnu.org/licenses/>. 
=========================================================================== 

*/

import UIKit
import GoogleMaps
import GooglePlaces
class SelectAddressViewController: UIViewController {
    
    var mapView: GMSMapView!
    var searchBarPlaceholderView: UIView!
    var searchController: UISearchController?
    var resultsViewController: GMSAutocompleteResultsViewController?
    
    let locationManager = LocationManager()
    var viewModel: SelectAddressViewModel!
    var selectedAddress: Address?
    
    fileprivate let searchBarHeight: CGFloat = 45.0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupNavigationItem()
        setupMapView()
        setupSearchLocationController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let selectedAddress =  self.selectedAddress {
            self.searchController?.searchBar.text = selectedAddress.name
            let location = CLLocationCoordinate2D(latitude: selectedAddress.latitude, longitude: selectedAddress.longitude)
            setMarker(onLocation: location)
            mapView.camera = GMSCameraPosition.camera(withLatitude: selectedAddress.latitude, longitude: selectedAddress.longitude,
                                              zoom: 17)
        } else {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                mapView.camera = GMSCameraPosition.camera(withLatitude: locationManager.currentLocation.latitude, longitude: locationManager.currentLocation.longitude, zoom: 17)
            default:
                
                mapView.camera = GMSCameraPosition.camera(withLatitude: locationManager.currentLocation.latitude, longitude: locationManager.currentLocation.longitude, zoom: 0)
            }
        }
    }
    
    
    func setupSearchLocationController() {
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.searchBar.text = selectedAddress?.name
        
        searchBarPlaceholderView = UIView(frame: CGRect(x: 0, y: 65, width: self.view.frame.width, height: searchBarHeight))
        
        searchBarPlaceholderView.addSubview((searchController?.searchBar)!)
        view.addSubview(searchBarPlaceholderView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        definesPresentationContext = true
    }
    
    func setupMapView() {
        self.locationManager.updateLocation()
        self.locationManager.locationManagerDelegate = self

        mapView = GMSMapView(frame: view.bounds)
        
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(mapView)
    }
    
    func setMarker(onLocation location: CLLocationCoordinate2D ) {
        mapView.clear()
        mapView.animate(toLocation: location)
        let marker = GMSMarker(position: location)
        marker.map = mapView
    }
    
    // MARK: - Navigation Setup/ Actions
    
    func setupNavigationItem() {

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Aceptar", style: .done, target: self, action: #selector(SelectAddressViewController.didTapDoneButton))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(SelectAddressViewController.didTapCancelButton))
    }
    
    @objc func didTapDoneButton() {
        if let address = selectedAddress {
            self.viewModel.selectedAddress = address
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func didTapCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension SelectAddressViewController: LocationManagerDelegate {
    func locationManager(_ locationManager: LocationManager, didUpdateCurrentLocation currentLocation: Location) {
        
        let location = CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        if let selectedAddress = self.selectedAddress {
            self.setMarker(onLocation: selectedAddress.coordinate)
        } else {
            
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                self.setMarker(onLocation: location)
            default:
                break;
            }

            let geocoder = GMSGeocoder()
            
            geocoder.reverseGeocodeCoordinate(location) { [weak self] response , error in
                if let address = response?.firstResult() {
                    if let lines = address.lines {
                        let address = lines.joined(separator: " ")
                        self?.searchController?.isActive = true
                        self?.searchController?.searchBar.text = address
                    }
                }
            }
        }
    }
}

extension SelectAddressViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        self.setMarker(onLocation: coordinate)
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { [weak self] response , error in
            if let address = response?.firstResult() {
                if let lines = address.lines {
                    let address = lines.first
                    self?.searchController?.isActive = true
                    self?.searchController?.searchBar.text = address
                }
            }
        }
    }
}

extension SelectAddressViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        self.setMarker(onLocation: place.coordinate)
        self.searchController?.searchBar.text = place.formattedAddress
        var city = ""
        var countryISO = ""
        if let addressComponents = place.addressComponents {
            
            if city.isEmpty {
                city = addressComponents.filter{$0.type == "administrative_area_level_2"}.first?.name ?? ""
            }
            
            if city.isEmpty {
                city = addressComponents.filter{$0.type == "locality"}.first?.name ?? ""
            }

            for component in addressComponents {
                if component.type == "country" {
                    countryISO = Locale.isoCountry(for: component.name)!
                }
            }
        }
        self.selectedAddress = Address(name: place.formattedAddress!, coordinate: place.coordinate, city: city, countryISO: countryISO)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
