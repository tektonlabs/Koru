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

import Foundation

import CoreLocation

protocol LocationManagerDelegate: class {
    func locationManager(_ locationManager: LocationManager, didUpdateCurrentLocation currentLocation: Location)
}

class LocationManager: NSObject {

    weak var locationManagerDelegate: LocationManagerDelegate?
    var manager = CLLocationManager()
    var placemark: CLPlacemark?
    var currentLocation = Location(longitude: 0.0, latitude: 0.0)
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func updateLocation() {
        manager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            updateLocation()
        case .denied, .restricted:
            self.locationManagerDelegate?.locationManager(self, didUpdateCurrentLocation: currentLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            currentLocation.latitude = lastLocation.coordinate.latitude
            currentLocation.longitude = lastLocation.coordinate.longitude
        }
        self.manager.stopUpdatingLocation()
        self.locationManagerDelegate?.locationManager(self, didUpdateCurrentLocation: currentLocation)
    }
}

