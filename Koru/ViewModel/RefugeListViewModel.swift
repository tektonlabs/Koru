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

class RefugeListViewModel {
    
    var limit: Int = 20
    var offset: Int = 0
    var isActiveSearchBar = false
    let locationManager = LocationManager()
    var currentLocation: Location?
    var timer = Timer()
    var searchText = "" {
        didSet {
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(callService), userInfo: nil, repeats: false)
        }
    }
    var refugeSelected: Refuge?
    var isLoading: Bool = false
    
    fileprivate var gpsHasResponded = false
    
    init() {
        locationManager.locationManagerDelegate = self
    }
    
    var morePages: Bool = true {
        didSet {
            if !morePages {
                didReachLastPage?()
            }
        }
    }
    
    var type: ScrollType = .none
    
    var listRefuge = [Refuge]() {
        didSet {
            didChangeListRefuge?()
        }
    }
    
    var cancelSearch = false
    
    var needsPullRefresh = false {
        didSet {
            if needsPullRefresh {
                morePages = true
                offset = 0
                callRefugeServiceWith(currentLocation)
            }
        }
    }
    
    var isScrollBottom = false {
        didSet {
            didScrollBottom?()
        }
    }
    
    var isSelectRefuge = false {
        didSet {
            didSelectRefuge?()
        }
    }
    
    var needLoading = false {
        didSet {
            didLoading?()
            if gpsHasResponded {
                callRefugeServiceWith(currentLocation)
            }
        }
    }
    
    var isEmpty = false {
        didSet {
            showEmptyView?()
        }
    }
    
    var isEmptySearch = false {
        didSet {
            showSearchEmptyView?()
        }
    }
    
    var isTouchedSearch = false {
        didSet {
            didTouchSearchButton?()
        }
    }
    
    var isTouchedSearchCancelButton = false {
        didSet {
            didTouchSearchCancelButton?()
        }
    }
    
    var thereArePendingForm = false {
        didSet {
            theArePending?()
        }
    }

    
    var haveDataInStore = false
    
    @objc func callService() {
        callRefugeServiceWith(currentLocation)
    }
    
    // MARK: - Events
    var didChangeListRefuge: (() -> Void)?
    var didSuccessLoading: (() -> Void)?
    var didScrollBottom: (() -> Void)?
    var didLoading: (() -> Void)?
    var showEmptyView: (() -> Void)?
    var showSearchEmptyView: (() -> Void)?
    var didSelectRefuge: (() -> Void)?
    var didTouchSearchButton: (() -> Void)?
    var didTouchSearchCancelButton: (() -> Void)?
    var theArePending: (() -> Void)?
    var didReachLastPage: (() -> Void)?
    
    
    func callRefugeServiceWith(_ currentLocation: Location?) {
        guard morePages else {
            return
        }
        
        verifyPendingForm()
        
        guard !isLoading else {
            return
        }
        
        if !needsPullRefresh {
            offset += listRefuge.count == 0 ? 0 : limit
        }
        
        if cancelSearch {
            listRefuge.removeAll()
            offset = 0
        }
        
        isLoading = true
        print(offset)
        RefugeService.getRefuges(location: currentLocation, limit: String(limit), offset: String(offset), text: searchText){ (refuges, error) in
            
            OperationQueue.main.addOperation {
                self.isLoading = false
                if var refuges = refuges {
                    refuges = self.verifyExistRefugePending(refugeArray: refuges)
                    if self.searchText != "" {
                        if refuges.count == 0 {
                            self.isEmptySearch = true
                        } else {
                            self.morePages = false
                            self.type = .none
                            self.listRefuge = refuges
                        }
                    } else {
                        self.didSuccessLoading?()
                        if refuges.count > 0 {
                            for refuge in refuges {
                                RefugePersistence().create(refuge: refuge) { (result) in }
                            }
                            if self.currentLocation?.getLatitude() == "" {
                                self.listRefuge = self.sortWith(refuge: refuges)
                            } else {
                                if self.needsPullRefresh {
                                    self.needsPullRefresh = false
                                    self.listRefuge = refuges
                                } else if self.cancelSearch  {
                                    self.cancelSearch = false
                                    self.listRefuge = refuges
                                } else {
                                    
                                    self.listRefuge.append(contentsOf: refuges)
                                }
                            }
                        } else {
                            self.morePages = false
                            self.type = .none
                            self.offset = self.listRefuge.count
                        }
                    }
                } else {
                    if self.searchText == "" {
                        self.fetchRefugesFromCoreData()
                    } else {
                        self.searchRefuge()
                    }
                    
                }
            }
        }
    }
    
    func fetchRefugesFromCoreData() {
        type = .loading
        
        let storeData = RefugePersistence().fetchAllRefugeWith()
        OperationQueue.main.addOperation {
            if storeData.count > 0 {
                self.didSuccessLoading?()
                self.morePages = false
                self.type = .none
                self.listRefuge = self.sortWith(refuge: storeData)
            } else {
                self.haveDataInStore = false
            }
        }
    }
    
    func sendPendingQuestionForm() {
        var isFailure = true
        let refugesStore = RefugePersistence().fetchAllRefuge()
        for refuge in refugesStore {
            if let pendingQuestionFormArray = refuge.pendingSortedQuestion {
                if pendingQuestionFormArray.count > 0 {
                    for pendingQuestionForm in pendingQuestionFormArray {
                        let question = NetworkMapper().bodySortedQuestionArray(from: pendingQuestionForm.sortedQuestion!)
                            RefugeService.sendQuestionFromShelter(questions: question, refuge: refuge, dni: pendingQuestionForm.dni!, date: pendingQuestionForm.date!) { (message, error) in
                            if message == "success" {
                                RefugePersistence().deletePendingForm(refuge: refuge, pending: pendingQuestionForm)
                            } else {
                                if isFailure {
                                    isFailure = false
                                    self.verifyPendingFormWithNotification()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func verifyPendingFormWithNotification() {
        if RefugePersistence().verifyPendingForm() {
            thereArePendingForm = true
            NotificationManager.sharedInstance.postNotificationFailureSendQuestionForm()
            
        }
    }
    
    func verifyPendingForm() {
        if RefugePersistence().verifyPendingForm() {
            thereArePendingForm = true
        }
    }
    
    func pendingFormVerify() -> Bool {
        return RefugePersistence().verifyPendingForm()
    }
    
    func searchRefuge() {
        let storeData = RefugePersistence().searchRefuges(with: searchText)
        OperationQueue.main.addOperation {
            if storeData.count > 0 {
                    self.type = .none
                    self.morePages = false
                    self.listRefuge = self.sortWith(refuge: storeData)
                } else {
                    self.isEmptySearch = true
                }
        }
    }
    
    func verifyExistRefugePending(refugeArray: [Refuge]) -> [Refuge] {
        
        let refugesStore = RefugePersistence().fetchAllRefuge()
            for (index,refuge) in refugeArray.enumerated() {
                for storeRefuge in refugesStore {
                    if refuge.id == storeRefuge.id {
                        if let pendingSortedQuestion = storeRefuge.pendingSortedQuestion {
                            if pendingSortedQuestion.count > 0 {
                                
                                refugeArray[index].pendingSortedQuestion = storeRefuge.pendingSortedQuestion
                            }
                        }
                       
                    }
                }
        }
        return refugeArray
    }
    
    func sortWith(refuge: [Refuge]) -> [Refuge] {
        return refuge.sorted  { $0.sortedName < $1.sortedName }
    }
    
    
    func formLocationTextWith(refuge: Refuge) -> String {
        var text: String = ""
        if refuge.address != "" && refuge.address != nil {
            text = refuge.address! + ", "
        }
        if refuge.city != "" || refuge.city != nil {
            text += refuge.city!
        }
        
        if refuge.country!.name != "" || refuge.country != nil {
            text += ", " + refuge.country!.name!
        }
        return text
    }
}


extension RefugeListViewModel: LocationManagerDelegate {
    func locationManager(_ locationManager: LocationManager, didUpdateCurrentLocation currentLocation: Location) {
        
        self.gpsHasResponded = true
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            self.currentLocation = currentLocation
        default:
            self.currentLocation = nil
            break;
        }
        
        self.offset = 0
        self.listRefuge.removeAll()
        callRefugeServiceWith(self.currentLocation)
    }
}



enum ScrollType {
    case loading
    case none
}
