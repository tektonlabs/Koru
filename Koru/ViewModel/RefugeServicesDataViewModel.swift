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

class RefugeServicesDataViewModel: ValidateViewModel {
    
    var lightManagementsViewModels: [MultipleChoiceViewModelCell]?
    var waterManagementsViewModels: [MultipleChoiceViewModelCell]?
    var stoolManagementsViewModels: [MultipleChoiceViewModelCell]?
    var wasteManagementsViewModels: [MultipleChoiceViewModelCell]?
    var foodManagementsViewModels: [MultipleChoiceViewModelCell]?
    
    var sections: [SectionType] = [.light, .water, .stool, .waste, .food, .send]
    var isValid: Bool {
        return validateFields()
    }
    
    var didTapSend: (() -> Void)?
    var didFinisihLoading: (() -> Void)?
    
    init(lightManagementsViewModels: [MultipleChoice], waterManagements: [MultipleChoice], stoolManagements: [MultipleChoice], wasteManagements: [MultipleChoice], foodManagements: [MultipleChoice]) {
        
        self.lightManagementsViewModels = lightManagementsViewModels.map{MultipleChoiceViewModelCell(multipleChoice: $0)}
        self.waterManagementsViewModels = waterManagements.map{MultipleChoiceViewModelCell(multipleChoice: $0)}
        self.stoolManagementsViewModels = stoolManagements.map{MultipleChoiceViewModelCell(multipleChoice: $0)}
        self.wasteManagementsViewModels = wasteManagements.map{MultipleChoiceViewModelCell(multipleChoice: $0)}
        self.foodManagementsViewModels = foodManagements.map{MultipleChoiceViewModelCell(multipleChoice: $0)}
    }
    
    func checkboxesViewModels(for sectionType: SectionType) -> [MultipleChoiceViewModelCell]? {
        switch sectionType {
        case .light:
            return lightManagementsViewModels
        case .water:
            return waterManagementsViewModels
        case .stool:
            return stoolManagementsViewModels
        case .waste:
            return wasteManagementsViewModels
        case .food:
            return foodManagementsViewModels
        case .send:
            return nil
        }
    }
    
    func validateFields() -> Bool {
        // No validations required in this step
        return true
    }

    enum CellType {
        case checkboxCell(MultipleChoiceViewModelCell)
        
        var identifier: String {
            switch self {
            case .checkboxCell:
                return "multipleChoiceCell"
            }
        }
        
        var nibName: String {
            switch self {
            case .checkboxCell:
                return "MultipleChoiceCell"
            }
        }
    }
    
    enum SectionType {
        case light
        case water
        case stool
        case waste
        case food
        case send
        
        var title: String? {
            switch self {
            case .light:
                return "Luz"
            case .water:
                return "Agua"
            case .stool:
                return "Manejo de heces"
            case .waste:
                return "Gestión de residuos"
            case .food:
                return "Alimentos y bebidas"
            case .send:
                return nil
            }
        }
    }
}
