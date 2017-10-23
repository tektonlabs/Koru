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


protocol ValidateViewModel {
    var isValid: Bool {get}
    func validateFields() -> Bool
}

enum CreateRefugeSteps: Int {
    case basicData = 0
    case additionalData
    case contactData
    case censusData
    case infrastructureData
    case servicesData
}

class CreateRefugeViewModel {
    var multipleChoices: RefugeFormMultipleChoices?
    
    var steps : [CreateRefugeSteps] = [.basicData, .additionalData, .contactData, .censusData, .infrastructureData, .servicesData]

    var currentStep: CreateRefugeSteps {
        didSet {
            didChangePage?()
        }
    }
    
    var currentPage: Int {
        return steps.index(of: currentStep) ?? NSNotFound
    }
    
    var currenPageIsFirstPage: Bool {
        return currentPage == 0
    }
    
    var currentPageIsLastPage: Bool {
        return currentPage == steps.count-1
    }
    
    var basicDataViewModel : RefugeBasicDataViewModel
    var additionalDataViewModel: RefugeAdditionalDataViewModel
    var servicesDataViewModel: RefugeServicesDataViewModel?
    var contactDataViewModel: RefugeContactDataViewModel
    var censusDataViewModel: RefugeCensusDataViewModel?
    var infrastructureDataViewModel: RefugeInfrastructureDataViewModel?
    
    var currentPageViewModel: ValidateViewModel? {
        switch currentStep {
        case .basicData:
            return basicDataViewModel
        case .additionalData:
            return additionalDataViewModel
        case .contactData:
            return contactDataViewModel
        case .censusData:
            return censusDataViewModel
        case .infrastructureData:
            return infrastructureDataViewModel
        case .servicesData:
            return servicesDataViewModel
        }
    }
    
    init() {
        basicDataViewModel = RefugeBasicDataViewModel()
        additionalDataViewModel = RefugeAdditionalDataViewModel()
        contactDataViewModel = RefugeContactDataViewModel()
        
        if let step = steps.first {
            self.currentStep = step
        } else {
            self.currentStep = .basicData
        }
    }
    
    func fetchMultipleChoices() {
        didStartLoadingMultipleChoices?()
        MultipleChoicesService.list { [weak self] (multipleChoices, error) in
            if let multipleChoices = multipleChoices {
                self?.multipleChoices = multipleChoices
                self?.createCensusDataViewModel()
                self?.createInfrastructureDataViewModel()
                self?.createServicesDataViewModel()
                self?.didLoadMultipleChoices?()
            } else {
                self?.didFailLoadingMultipleChoices?(error!)
            }
        }
    }
    
    func createCensusDataViewModel() {
        guard let multipleChoices = self.multipleChoices else {
            return
        }
        
        self.censusDataViewModel = RefugeCensusDataViewModel(servicesTypes: multipleChoices.services!, housingStates: multipleChoices.housingStatuses!)
    }
    
    func createInfrastructureDataViewModel() {
        guard let multipleChoices = self.multipleChoices else {
            return
        }
        
        self.infrastructureDataViewModel = RefugeInfrastructureDataViewModel(areas: multipleChoices.areas!)
    }
    
    func createServicesDataViewModel() {
        guard let multipleChoices = self.multipleChoices else {
            return
        }
        
        self.servicesDataViewModel = RefugeServicesDataViewModel(lightManagementsViewModels: multipleChoices.lightManagements!, waterManagements: multipleChoices.waterManagements!, stoolManagements: multipleChoices.stoolManagements!, wasteManagements: multipleChoices.wasteManagements!, foodManagements: multipleChoices.foodManagements!)
        
        self.servicesDataViewModel?.didTapSend = { [weak self] in
            if let refugeForm = self?.createRefugeForm() {
                RefugeService.createRefuge(refugeForm: refugeForm) { [weak self] (message, error) in
                    self?.servicesDataViewModel?.didFinisihLoading?()
                    if let error = error {
                        self?.didFailSendingRefugeForm?(error)
                    } else {
                        self?.didSendRefugeForm?()
                    }
                }
            }
        }
    }

    func createRefugeForm() -> [String: Any] {
        let name = basicDataViewModel.nameCellViewModel.text!
        let address = basicDataViewModel.addressCellViewModel.selectedAddress?.name ?? ""
        let city = basicDataViewModel.addressCellViewModel.selectedAddress?.city ?? ""
        let countryISO = basicDataViewModel.addressCellViewModel.selectedAddress?.countryISO ?? ""
        let longitude = String(describing: basicDataViewModel.addressCellViewModel.selectedAddress?.longitude ?? 0)
        let latitude = String(describing: basicDataViewModel.addressCellViewModel.selectedAddress?.longitude ?? 0)
        let emergencyType = basicDataViewModel.emergencyCellViewModel.selectedOption as! EmergencyType
        
        let refugeForm = RefugeForm(name: name, latitude: latitude, longitude: longitude, address: address, city: city, countryISO: countryISO, emergencyType: emergencyType)
        
        refugeForm.refugeType = basicDataViewModel.refugeTypeCellViewModel.selectedOption as? RefugeType
        refugeForm.institutionInCharge = basicDataViewModel.institutionInChargeCellViewModel.selectedOption as? InstitutionInChargeType
        refugeForm.propertyType = additionalDataViewModel.propertyTypeViewModel.selectedOption as? PropertyType
        refugeForm.accessibility = additionalDataViewModel.accessibilityTypeViewModel.selectedOption as? AccessibilityType
        refugeForm.victimsProvenance = additionalDataViewModel.victimsProvenanceTypeViewModel.selectedOption as? VictimsProvenanceType
        refugeForm.floorType = infrastructureDataViewModel?.floorTypeViewModel.selectedOption as? FloorType
        refugeForm.roofType = infrastructureDataViewModel?.roofTypeViewModel.selectedOption as? RoofType
        refugeForm.primaryContact = contactDataViewModel.contactPrincipal.first
        refugeForm.numberOfCarps = Int(infrastructureDataViewModel?.firstCellViewModel.firstText ?? "0") ?? 0
        refugeForm.numberOfToilets = Int(infrastructureDataViewModel?.firstCellViewModel.secondText ?? "0") ?? 0
        refugeForm.numberOfWashbasins = Int(infrastructureDataViewModel?.secondCellViewModel.firstText ?? "0") ?? 0
        refugeForm.numberOfShowers = Int(infrastructureDataViewModel?.secondCellViewModel.secondText ?? "0") ?? 0
        refugeForm.numberOfTanks = Int(infrastructureDataViewModel?.thirdCellViewModel.firstText  ?? "0") ?? 0
        refugeForm.numberOfLandfills = Int(infrastructureDataViewModel?.thirdCellViewModel.secondText ?? "0") ?? 0
        refugeForm.numberOfGarbageCollectionPoints = Int(infrastructureDataViewModel?.garbageCollectionViewModel.text ?? "0") ?? 0

        refugeForm.numberOfFamilies = Int(censusDataViewModel?.familiesAndPregnantCellViewModel.firstText ?? "0") ?? 0
        refugeForm.numberOfPregnantWomen = Int(censusDataViewModel?.familiesAndPregnantCellViewModel.secondText ?? "0") ?? 0
        refugeForm.numberOfPets = Int(censusDataViewModel?.petsAndDisabledCellViewModel.firstText ?? "0") ?? 0
        refugeForm.numberOfPeopleWithDisabilities = Int(censusDataViewModel?.petsAndDisabledCellViewModel.secondText ?? "0") ?? 0
        refugeForm.numberOfFarmAnimals = Int(censusDataViewModel?.farmAnimalsCellViewModel.text ?? "0") ?? 0
        refugeForm.numberOfMaleChildrensUnder3 = Int(censusDataViewModel?.childrenUnder3CellViewModel.firstText ?? "0") ?? 0
        refugeForm.numberOfFemaleChildrensUnder3 = Int(censusDataViewModel?.childrenUnder3CellViewModel.secondText ?? "0") ?? 0
        refugeForm.numberOfMalePeopleLessThanOrEqualsTo18 = Int(censusDataViewModel?.peopleUnderTo18CellViewModel.firstText ?? "0") ?? 0
        refugeForm.numberOfFemalePeopleLessThanOrEqualsTo18 = Int(censusDataViewModel?.peopleUnderTo18CellViewModel.secondText ?? "0") ?? 0
        refugeForm.numberOfMalePeopleOlderThan18 = Int(censusDataViewModel?.peopleOlderThan18CellViewModel.firstText ?? "0") ?? 0
        refugeForm.numberOfFemalePeopleOlderThan18 = Int(censusDataViewModel?.peopleOlderThan18CellViewModel.secondText ?? "0") ?? 0
        refugeForm.numberOfMaleOlderAdults = Int(censusDataViewModel?.peopleOlderCellViewModel.firstText ?? "0") ?? 0
        refugeForm.numberOfFemaleOlderAdults = Int(censusDataViewModel?.peopleOlderCellViewModel.secondText ?? "0") ?? 0
        
        refugeForm.secondaryContacts = contactDataViewModel.contactSegundary
        
        refugeForm.refugeCommittees = additionalDataViewModel.searchArray.map { $0.title }
        
        
        if let census = censusDataViewModel, let serviceTypeCheckBoxes = census.serviceTypesCheckboxesViewModels, let housingStatesCheckboxes = census.housingStatesCheckboxesViewModels {
            refugeForm.refugeServices = serviceTypeCheckBoxes.filter { $0.selected}.map{ $0.multipleChoice}
            refugeForm.refugeHousingStatuses = housingStatesCheckboxes.filter { $0.selected}.map{ $0.multipleChoice}
        }
        
        if let infrastructure = infrastructureDataViewModel, let areasCheckboxes = infrastructure.areasCheckboxesViewModels {
            refugeForm.refugeAreas = areasCheckboxes.filter { $0.selected}.map{ $0.multipleChoice}
        }
        
        if let services = servicesDataViewModel,let lightManagements = services.lightManagementsViewModels, let waterManagements = services.waterManagementsViewModels, let stoolManagements = services.stoolManagementsViewModels, let wasteManagements = services.wasteManagementsViewModels, let foodManagements = services.foodManagementsViewModels {
            
            refugeForm.refugeLightManagements = lightManagements.filter { $0.selected == true }.map { $0.multipleChoice }
            
            refugeForm.refugeWaterManagements = waterManagements.filter { $0.selected == true }.map { $0.multipleChoice }
           
            refugeForm.refugeStoolManagements = stoolManagements.filter { $0.selected == true }.map { $0.multipleChoice }
            refugeForm.refugeWasteManagements = wasteManagements.filter { $0.selected == true }.map { $0.multipleChoice }
        
            refugeForm.refugeFoodManagements = foodManagements.filter { $0.selected}.map{ $0.multipleChoice}
        }
            
        let mapRefugeForm = NetworkMapper().bodyRefugeForm(from: refugeForm)

        return mapRefugeForm

    }
    
    // MARK: - Actions
    var didChangePage: (() -> Void)?
    var didStartLoadingMultipleChoices: (() -> Void)?
    var didLoadMultipleChoices: (() -> Void)?
    var didFailLoadingMultipleChoices: ((_ error: Error) -> Void)?
    var didFailSendingRefugeForm: ((_ error: Error) -> Void)?
    var didSendRefugeForm: (() -> Void)?
    
}
