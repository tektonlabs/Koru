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

enum ContactType {
    case principal
    case secondary
}

enum ContactFormField {
    case name, cellphone, email
}

class ContactFormViewModel: NSObject {
    
    // MARK: - Public
    var isValidate = false {
        didSet {
            guard isValidate else{ return }
            didConfirmateValidation?()
        }
    }
    
    var didConfirmateValidation: (() ->  Void)?
    var didValidateName: ((_ errorMessage: String?) -> Void)?
    var didValidateCellphone: ((_ errorMessage: String?) -> Void)?
    var didValidateEmail: ((_ errorMessage: String?) -> Void)?
    
    var contactType: ContactType = .principal
    var isEditing: Bool = false

    func validate(name: String, cellPhone: String, email: String) {
        
        var validName = true
        var validCellPhone = true
        var validEmail = true
        
        if name.characters.count == 0  {
            validName = false
            self.didValidateName?("Este es un campo requerido")
        } else {
            self.didValidateName?(nil)
        }
        
        if cellPhone.characters.count == 0  {
            validCellPhone = false
            self.didValidateCellphone?("Este es un campo requerido")
        } else if cellPhone.characters.count != 9 {
            validCellPhone = false
            self.didValidateCellphone?("Ingresa un número de 9 dígitos")
        } else {
            self.didValidateCellphone?(nil)
        }
        
        if email.characters.count == 0  {
            validEmail = false
            self.didValidateEmail?("Este es un campo requerido")
        }else if !email.isValidEmail{
            validEmail = false
            self.didValidateEmail?("Correo Inválido")
        } else {
            self.didValidateEmail?(nil)
        }
        
        isValidate = validName && validCellPhone && validEmail
    }
}
