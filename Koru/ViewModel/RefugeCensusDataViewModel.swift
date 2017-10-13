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

class RefugeCensusDataViewModel: ValidateViewModel {
    
    var familiesAndPregnantCellViewModel: DoubleTextFieldCellViewModel
    var petsAndDisabledCellViewModel: DoubleTextFieldCellViewModel
    var farmAnimalsCellViewModel: TextFieldCellViewModel
    
    var childrenUnder3CellViewModel: DoubleTextFieldCellViewModel
    var peopleUnderTo18CellViewModel: DoubleTextFieldCellViewModel
    var peopleOlderThan18CellViewModel: DoubleTextFieldCellViewModel
    var peopleOlderCellViewModel: DoubleTextFieldCellViewModel
    
    var structureCellForCesusSection: [CellType] {
        return [.doubleTextFieldCell(familiesAndPregnantCellViewModel), .doubleTextFieldCell(petsAndDisabledCellViewModel), .textFieldCell(farmAnimalsCellViewModel)]
    }
    var structureCellForChildrenUnder3Section: [CellType] {
        return [.doubleTextFieldCell(childrenUnder3CellViewModel)]
    }
    
    var structureCellForPeopleUnder18: [CellType] {
        return [.doubleTextFieldCell(peopleUnderTo18CellViewModel)]
    }
    
    var structureCellForPeopleOlderTo18: [CellType] {
        return [.doubleTextFieldCell(peopleOlderThan18CellViewModel)]
    }
    
    var structureCellForPeopleOlder: [CellType] {
        return [.doubleTextFieldCell(peopleOlderCellViewModel)]
    }
    
    var serviceTypesCheckboxesViewModels: [MultipleChoiceViewModelCell]?
    var housingStatesCheckboxesViewModels: [MultipleChoiceViewModelCell]?
    
    var sections: [SectionType] = [.censos, .childrenUnder3, .peopleUnder18, .peopleOlderThanTo18, .peopleOlder , .typesOfService, .housingState]
 
    
    var isValid: Bool {
        let valid = validateFields()
        if !valid  {
            didFailValidation?()
        }
        return valid
    }
    
    var didFailValidation: (() -> Void)?
    
    init(servicesTypes: [MultipleChoice], housingStates: [MultipleChoice]) {
        
        familiesAndPregnantCellViewModel = DoubleTextFieldCellViewModel(firstPlaceholder: "# familias", secondPlaceholder: "# embarazadas")
        petsAndDisabledCellViewModel = DoubleTextFieldCellViewModel(firstPlaceholder: "# mascotas", secondPlaceholder: "# discapacitados")
        
        farmAnimalsCellViewModel = TextFieldCellViewModel(placeholder: "# animales de granja")
        farmAnimalsCellViewModel.maxNumberOfCharacters = 4

        
        childrenUnder3CellViewModel = DoubleTextFieldCellViewModel(firstPlaceholder: "# hombres", secondPlaceholder: "# mujeres")
        peopleUnderTo18CellViewModel = DoubleTextFieldCellViewModel(firstPlaceholder: "# hombres", secondPlaceholder: "# mujeres")
        peopleOlderThan18CellViewModel =  DoubleTextFieldCellViewModel(firstPlaceholder: "# hombres", secondPlaceholder: "# mujeres")
        peopleOlderCellViewModel =  DoubleTextFieldCellViewModel(firstPlaceholder: "# hombres", secondPlaceholder: "# mujeres")

        serviceTypesCheckboxesViewModels = servicesTypes.map{MultipleChoiceViewModelCell(multipleChoice: $0)}
        housingStatesCheckboxesViewModels = housingStates.map{MultipleChoiceViewModelCell(multipleChoice: $0)}
    }
    
    func validateFields() -> Bool {
        return true
    }
    
}

extension RefugeCensusDataViewModel {
    
    enum SectionType {
        case censos
        case childrenUnder3
        case peopleUnder18
        case peopleOlderThanTo18
        case peopleOlder
        case typesOfService
        case housingState
        
        var title : String {
            switch self {
            case .censos:
                return "Censo"
            case .childrenUnder3:
                return "Niños menores a 3"
            case .peopleUnder18:
                return "Jóvenes menores a 18"
            case .peopleOlderThanTo18:
                return "Mayores a 18"
            case .peopleOlder:
                return "Adultos mayores"
            case .typesOfService:
                return "Tipo de Servicios"
            case .housingState:
                return "Estado de Viviendas"
            }
        }
    }
    
    enum CellType {
        case doubleTextFieldCell(DoubleTextFieldCellViewModel)
        case textFieldCell(TextFieldCellViewModel)
        
        var identifier: String {
            switch self {
            case .doubleTextFieldCell:
                return "doubleTextFieldCell"
            case .textFieldCell:
                return "textFieldCell"
            }
        }
        
        var nibName: String {
            switch self {
            case .doubleTextFieldCell:
                return "DoubleTextFieldCell"
            case .textFieldCell:
                return "TextFieldCell"
            }
        }
    }

}
    
