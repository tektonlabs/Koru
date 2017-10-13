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

class RefugeBasicDataViewModel: ValidateViewModel {
    
    var nameCellViewModel: TextFieldCellViewModel
    var refugeTypeCellViewModel: DropdownCellViewModel
    var institutionInChargeCellViewModel: DropdownCellViewModel
    var emergencyCellViewModel: DropdownCellViewModel
    var addressCellViewModel: SelectAddressViewModel
    
    var tableStructure: [CellType] {
        return [.textFieldCell(nameCellViewModel), .dropDownCell(refugeTypeCellViewModel), .dropDownCell(institutionInChargeCellViewModel), .dropDownCell(emergencyCellViewModel), .locationCell(addressCellViewModel)]
    }
    
    var isValid: Bool {
        let valid = validateFields()
        if !valid  {
            didFailValidation?()
        }
        return valid
    }
    
    var didSelectAddress: ((_ address: Address) -> Void)?
    var didSelectOption: ((_ option: OptionItem) -> Void)?
    var didFailValidation: (() -> Void)?
    
    init() {
        nameCellViewModel = TextFieldCellViewModel(placeholder: "Nombre del albergue")
        
        refugeTypeCellViewModel = DropdownCellViewModel(placeholder: "Tipo de albergue", options: RefugeType.options)

        
        institutionInChargeCellViewModel = DropdownCellViewModel(placeholder: "Institución a cargo", options: InstitutionInChargeType.options)
        
        
        emergencyCellViewModel = DropdownCellViewModel(placeholder: "Tipo de emergencia", options: EmergencyType.options)
        
        addressCellViewModel = SelectAddressViewModel(placeholder: "Dirección")

        
        refugeTypeCellViewModel.didSelectOption = { [weak self] in
            if let option = self?.refugeTypeCellViewModel.selectedOption {
                self?.didSelectOption?(option)
            }
        }
        
        institutionInChargeCellViewModel.didSelectOption = { [weak self] in
            if let option = self?.institutionInChargeCellViewModel.selectedOption {
                self?.didSelectOption?(option)
            }
        }
        
        emergencyCellViewModel.didSelectOption = { [weak self] in
            if let option = self?.emergencyCellViewModel.selectedOption {
                self?.didSelectOption?(option)
            }
        }
        
        addressCellViewModel.didSelectAddress = { [weak self] in
            if let address = self?.addressCellViewModel.selectedAddress {
                self?.didSelectAddress?(address)
            }
        }
        
    }
    
    func validateFields() -> Bool {
        var validName = true
        var validEmergencyType = true
        var validAddress = true

        if nameCellViewModel.text == nil {
            validName = false
            nameCellViewModel.error = "Este es un campo requerido"
        } else if let name = nameCellViewModel.text, name.characters.count == 0 {
            validName = false
            nameCellViewModel.error = "Este es un campo requerido"
        } else {
            nameCellViewModel.error = nil
        }

        if emergencyCellViewModel.selectedOption == nil {
            validEmergencyType = false
            emergencyCellViewModel.error = "Este es un campo requerido"
        } else {
            emergencyCellViewModel.error = nil
        }

        if addressCellViewModel.selectedAddress == nil {
            validAddress = false
            addressCellViewModel.error = "Este es un campo requerido"
        } else {
            addressCellViewModel.error = nil
        }

        return validName && validEmergencyType && validAddress
    }
    
    enum CellType {
        case textFieldCell(TextFieldCellViewModel)
        case dropDownCell(DropdownCellViewModel)
        case locationCell(SelectAddressViewModel)
        
        var identifier: String {
            switch self {
            case .textFieldCell:
                return "textFieldCell"
            case .dropDownCell:
                return "dropdownCell"
            case .locationCell:
                return "SelectAddressCell"
            }
        }
        
        var nibName: String {
            switch self {
            case .textFieldCell:
                return "TextFieldCell"
            case .dropDownCell:
                return "DropdownCell"
            case .locationCell:
                return "SelectAddressCell"
            }
        }
    }
    

}
