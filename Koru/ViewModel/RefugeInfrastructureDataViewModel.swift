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

class RefugeInfrastructureDataViewModel: ValidateViewModel {
    
    var garbageCollectionViewModel: TextFieldCellViewModel
    var floorTypeViewModel: DropdownCellViewModel!
    var roofTypeViewModel: DropdownCellViewModel!
    var firstCellViewModel: DoubleTextFieldCellViewModel
    var secondCellViewModel: DoubleTextFieldCellViewModel
    var thirdCellViewModel: DoubleTextFieldCellViewModel

    var sections: [SectionType] = [.infrestructure, .presenceOf]
    var areasCheckboxesViewModels: [MultipleChoiceViewModelCell]?
    
    var isValid: Bool {
        let valid = validateFields()
        if !valid  {
            didFailValidation?()
        }
        return valid
    }
    
    var didSelectOption: ((_ option: OptionItem) -> Void)?
    var didFailValidation: (() -> Void)?
    
    init(areas: [MultipleChoice]) {
        garbageCollectionViewModel = TextFieldCellViewModel(placeholder: "# puntos de acopio de basura")
        garbageCollectionViewModel.maxNumberOfCharacters = 4

        firstCellViewModel = DoubleTextFieldCellViewModel(firstPlaceholder: "# carpas", secondPlaceholder: "# inodoros")
        secondCellViewModel = DoubleTextFieldCellViewModel(firstPlaceholder: "# lavatorios", secondPlaceholder: "# duchas")
        thirdCellViewModel = DoubleTextFieldCellViewModel(firstPlaceholder: "# tanques", secondPlaceholder: "# basureros")
        
        floorTypeViewModel = DropdownCellViewModel(placeholder: "Tipo de piso", options: FloorType.options)
        
        roofTypeViewModel = DropdownCellViewModel(placeholder: "Techo", options: RoofType.options)
        
        areasCheckboxesViewModels = areas.map{MultipleChoiceViewModelCell(multipleChoice: $0)}
   
        
        floorTypeViewModel.didSelectOption = { [weak self] in
            if let option = self?.floorTypeViewModel.selectedOption {
                self?.didSelectOption?(option)
            }
        }
        
        roofTypeViewModel.didSelectOption = { [weak self] in
            if let option = self?.roofTypeViewModel.selectedOption {
                self?.didSelectOption?(option)
            }
        }
  
    }
    
    func cellTypes(for section: SectionType) -> [CellType]  {
        switch section {
        case .infrestructure:
            return [.doubletextFieldCell(firstCellViewModel),.doubletextFieldCell(secondCellViewModel),.doubletextFieldCell(thirdCellViewModel), .textFieldCell(garbageCollectionViewModel),.dropDownCell(floorTypeViewModel), .dropDownCell(roofTypeViewModel)]
        case .presenceOf:
            guard let areasCheckboxesViewModels = self.areasCheckboxesViewModels else {
                return []
            }
            
            return areasCheckboxesViewModels.map{.multipleChoiceCell($0)}
        }
    }
    
    func validateFields() -> Bool {

//        var floorTypeValid = true
//        var roofTypeValid = true
//
//        if floorTypeViewModel.selectedOption == nil {
//            floorTypeValid = false
//            floorTypeViewModel.error = "Este es un campo requerido"
//        } else {
//            floorTypeViewModel.error = nil
//        }
//
//        if roofTypeViewModel.selectedOption == nil {
//            roofTypeValid = false
//            roofTypeViewModel.error = "Este es un campo requerido"
//        } else {
//            roofTypeViewModel.error = nil
//        }
//
//        return  roofTypeValid && floorTypeValid
        return true
    }
    
}

extension RefugeInfrastructureDataViewModel {
    
    enum SectionType {
        case infrestructure
        case presenceOf
        
        var title : String {
            switch self {
            case .infrestructure:
                return "Infraestructura"
            case .presenceOf:
                return "Presencia de"
            }
        }
    }
    
    enum CellType {
        case dropDownCell(DropdownCellViewModel)
        case doubletextFieldCell(DoubleTextFieldCellViewModel)
        case textFieldCell(TextFieldCellViewModel)
        case multipleChoiceCell(MultipleChoiceViewModelCell)
 
        var identifier: String {
            switch self {
            case .dropDownCell:
                return "dropdownCell"
            case .doubletextFieldCell:
                return "doubleTextFieldCell"
            case .textFieldCell:
                return "textFieldCell"
            case .multipleChoiceCell:
                return "multipleChoiceCell"
            }
        }
        
        var nibName: String {
            switch self {
            case .dropDownCell:
                return "DropdownCell"
            case .doubletextFieldCell:
                return "DoubleTextFieldCell"
            case .textFieldCell:
                return "TextFieldCell"
            case .multipleChoiceCell:
                return "MultipleChoiceCell"
            }
        }
    }
}

