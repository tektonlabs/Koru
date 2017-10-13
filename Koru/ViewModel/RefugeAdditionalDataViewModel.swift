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

class RefugeAdditionalDataViewModel: ValidateViewModel {
    
    var propertyTypeViewModel: DropdownCellViewModel!
    var accessibilityTypeViewModel: DropdownCellViewModel!
    var victimsProvenanceTypeViewModel: DropdownCellViewModel!
    
    var refugeCommitteesViewModels = [CellType]()
    var sections: [SectionType] = [.additonalData, .comittes]
    var searchArray = [SearchResult]()
    
    var isValid: Bool {
        let valid = validateFields()
        if !valid  {
            didFailValidation?()
        }
        return valid
    }
    
    var didSelectOption: ((_ option: OptionItem) -> Void)?
    var didSelectSearchResult: ((_ result: SearchResult) -> Void)?
    var didFailValidation: (() -> Void)?
    
    init() {
        propertyTypeViewModel = DropdownCellViewModel(placeholder: "Tipo de propiedad", options: PropertyType.options)
        accessibilityTypeViewModel = DropdownCellViewModel(placeholder: "Accesibilidad", options: AccessibilityType.options)
        victimsProvenanceTypeViewModel = DropdownCellViewModel(placeholder: "Procedencia de damnificados", options: VictimsProvenanceType.options)
        
        _ = self.addNewRefugeCommittee()
        
        propertyTypeViewModel.didSelectOption = { [weak self] in
            if let option = self?.propertyTypeViewModel.selectedOption {
                self?.didSelectOption?(option)
            }
        }
        
        accessibilityTypeViewModel.didSelectOption = { [weak self] in
            if let option = self?.accessibilityTypeViewModel.selectedOption {
                self?.didSelectOption?(option)
            }
        }
        
        victimsProvenanceTypeViewModel.didSelectOption = { [weak self] in
            if let option = self?.victimsProvenanceTypeViewModel.selectedOption {
                self?.didSelectOption?(option)
            }
        }
        
    }
    
    func addNewResult(searchResult: SearchResult) {
        var isExist = false
        for (index,result) in searchArray.enumerated() {
            if result.id == searchResult.id {
                isExist = true
                searchArray[index] = result
            }
        }
        
        if isExist == false {
            searchArray.append(searchResult)
        }
    }
    
    func cellTypes(for section: SectionType) -> [CellType]  {
        switch section {
        case .additonalData:
            return [.dropDownCell(propertyTypeViewModel), .dropDownCell(accessibilityTypeViewModel), .dropDownCell(victimsProvenanceTypeViewModel)]
        case .comittes:
            return refugeCommitteesViewModels
        }
    }
    
    func addNewRefugeCommittee() -> Bool {
        if refugeCommitteesViewModels.count < 5 {
            
            let addSearchResultViewModel = AddSearchResultViewModel()
            addSearchResultViewModel.didSelectResult = { [weak self] viewModel in
                if let searchResult = viewModel.result {
                    self?.didSelectSearchResult?(searchResult)
                }
            }
            refugeCommitteesViewModels.append(.addSearchResult(addSearchResultViewModel))
            return true
        }
        return false
    }
    
    func removeRefugeCommittee(at index: Int){
        if refugeCommitteesViewModels.count > 1 {
            refugeCommitteesViewModels.remove(at: index)
        } else if case .addSearchResult(let viewModel) = refugeCommitteesViewModels.first! {
            viewModel.result = nil
            
        }
    }
    
    func validateFields() -> Bool {
        
//        var validPropertyType = true
//        var validAccessbilityType = true
//        var validVictimsProvenanceType = true
//
//        if propertyTypeViewModel.selectedOption == nil {
//            validPropertyType = false
//            propertyTypeViewModel.error = "Este es un campo requerido"
//        } else {
//            propertyTypeViewModel.error = nil
//        }
//
//        if accessibilityTypeViewModel.selectedOption == nil {
//            validAccessbilityType = false
//            accessibilityTypeViewModel.error = "Este es un campo requerido"
//        } else {
//            accessibilityTypeViewModel.error = nil
//        }
//
//        if victimsProvenanceTypeViewModel.selectedOption == nil {
//            validVictimsProvenanceType = false
//            victimsProvenanceTypeViewModel.error = "Este es un campo requerido"
//        } else {
//            victimsProvenanceTypeViewModel.error = nil
//        }
//
//        return validPropertyType && validAccessbilityType && validVictimsProvenanceType
        return true
    }
    
    
}

extension RefugeAdditionalDataViewModel {
    
    enum SectionType {
        case additonalData
        case comittes
        
        var title : String {
            switch self {
            case .additonalData:
                return "Datos Adicionales"
            case .comittes:
                return "Presencia de Comités"
            }
        }
    }
    
    enum CellType {
        case dropDownCell(DropdownCellViewModel)
        case addSearchResult(AddSearchResultViewModel)
        
        var identifier: String {
            switch self {
            case .dropDownCell:
                return "dropdownCell"
            case .addSearchResult:
                return "addSearchResultCell"
            }
        }
        
        var nibName: String {
            switch self {
            case .dropDownCell:
                return "DropdownCell"
            case .addSearchResult:
                return "AddSearchResultCell"
            }
        }
    }
}
