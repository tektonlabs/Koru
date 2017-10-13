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

import UIKit

enum TakeRegisterField {
    case dni, cellphone, institution
}

class TakeRegisterViewModel: NSObject {
    

    
    // MARK: - Public
    var isValidate = false {
        didSet {
            guard isValidate else { return }
            didConfirmateValidation?()
        }
    }
    
    
    fileprivate var errorField: TakeRegisterField?
    
    var didConfirmateValidation: (() ->  Void)?
    var didValidateDNI:((_ errorMessage: String?) -> Void)?
    var didValidateCellphone:((_ errorMessage: String?) -> Void)?
    var didValidateInstitution:((_ errorMessage: String?) -> Void)?

    
    func validate(dni: String, cellPhone: String, institution: String) {
        
        var validDNI = true
        var validCellPhone = true
        var validInstitution = true
        let nationlPersonIDMaxCharacters = AppType.current.nationalPersonIDMaxCharacters
        
        if dni.characters.count == 0  {
            validDNI = false
            self.didValidateDNI?("Este es un campo requerido")
        } else if dni.characters.count < nationlPersonIDMaxCharacters {
            validDNI = false
            self.didValidateDNI?("Ingresa un número de \(nationlPersonIDMaxCharacters) caracteres")
        } else {
            self.didValidateDNI?(nil)
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
        
        if institution.characters.count == 0  {
            validInstitution = false
            self.didValidateInstitution?("Este es un campo requerido")
        } else {
            self.didValidateInstitution?(nil)
        }
        
        isValidate = validDNI && validCellPhone && validInstitution
    }

    
}
