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
import UIKit
class RefugeContactDataViewModel: ValidateViewModel {
    
    var principalAddContactCellViewModel: AddContactCellViewModel!
    var segundaryAddContactCellViewMode: AddContactCellViewModel!
    var cellForPrincipalContactSection = [CellType]()
    var cellForSegundaryContactSection = [CellType]()
    var sections: [SectionType] = [.principalContact, .secondaryContact]
    
    var contactPrincipal = [Contact]()
    var contactSegundary = [Contact]()
    var selectContactIndexPath: IndexPath?
    var isUpdateData = false {
        didSet {
            didUpdateData?()
        }
    }
    
    var isValid: Bool {
        let valid = validateFields()
        if !valid  {
            didFailValidation?()
        }
        return valid
    }

    
    var didUpdateData: (() -> Void)?
    var didFailValidation: (() -> Void)?

    
    init() {
        principalAddContactCellViewModel = AddContactCellViewModel(title: "Agregar contacto principal", colorButton: ColorPalette.blueRefuge, colorTitle: UIColor.white)
        segundaryAddContactCellViewMode =  AddContactCellViewModel(title: "Agregar contacto secundario", colorButton: ColorPalette.ultraLightGray, colorTitle: UIColor.darkGray)
        cellForPrincipalContactSection.append(.addContactCell(principalAddContactCellViewModel))
        cellForSegundaryContactSection.append(.addContactCell(segundaryAddContactCellViewMode))
    }
    
    func validateFields() -> Bool {
//        if contactPrincipal.count > 0 {
//            return true
//        } else {
//            return false
//        }
        return true
    }
    
    func addContact(contactType: ContactType, contact: Contact, isEditing: Bool) {
        if contactType == .principal {
            if isEditing {
                contactPrincipal[selectContactIndexPath!.row] = contact
            } else {
                contactPrincipal.append(contact)
                cellForPrincipalContactSection.removeAll()
                let newCellPrincipalContact = ContactCellViewModel(colorNameLabel: UIColor.white,colorLabel: UIColor.white, backgroundColorContainerView: ColorPalette.purple, deleteImage: #imageLiteral(resourceName: "delete-white"))
                cellForPrincipalContactSection.append(.contactCell(newCellPrincipalContact))
            }
            isUpdateData = true
        } else {
            if isEditing {
                contactSegundary[selectContactIndexPath!.row] = contact
            } else {
                contactSegundary.append(contact)
                let image = #imageLiteral(resourceName: "delete-black")
                let newCellPrincipalContact = ContactCellViewModel(colorNameLabel: UIColor.black, colorLabel: ColorPalette.darkGray, backgroundColorContainerView: UIColor.white, deleteImage: image)
                cellForSegundaryContactSection.insert(.contactCell(newCellPrincipalContact), at: 0)

            }
            isUpdateData = true
        }
    }
    
    func deleteContact(sectionType: SectionType, indexPath: IndexPath) {
        switch sectionType {
        case .principalContact:
            contactPrincipal.remove(at: indexPath.row)
            cellForPrincipalContactSection.removeAll()
            principalAddContactCellViewModel = AddContactCellViewModel(title: "AGREGAR CONTACTO PRINCIPAL", colorButton: ColorPalette.blueRefuge, colorTitle: UIColor.white)
            cellForPrincipalContactSection.append(.addContactCell(principalAddContactCellViewModel))
            isUpdateData = true
            
        case .secondaryContact:
            contactSegundary.remove(at: indexPath.row)
            cellForSegundaryContactSection.remove(at: indexPath.row)
            isUpdateData = true
        }
    }
}

extension RefugeContactDataViewModel {
    
    enum SectionType {
        case principalContact
        case secondaryContact
        
        var title : String {
            switch self {
            case .principalContact:
                return "Contacto Principal"
            case .secondaryContact:
                return "Contactos Secundarios (Opcional)"
            }
        }
    }
    
    enum CellType {
        case contactCell(ContactCellViewModel)
        case addContactCell(AddContactCellViewModel)
        var identifier: String {
            switch self {
            case .contactCell:
                return "contactCell"
            case .addContactCell:
                return "addContactCell"
            }
        }
        
        var nibName: String {
            switch self {
            case .contactCell:
                return "ContactCell"
            case .addContactCell:
                return "AddContactCell"
          
            }
        }
    }
}
