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

class EnumeratorUser: NSObject, NSCoding, UserProtocol {
    var nationalPersonID: String?
    var cellphone: String?
    var institution: String?
    var isActive: Bool = false
    
    static let didLoginNotification     = "EnumeratorUserDidLogin"
    static let didLogoutNotification    = "EnumeratorUserDidLogout"
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("enumeratorUser")
    
    struct KeyProperties {
        static let nationalPersonIDKey  = "dni"
        static let cellphoneKey = "cellphone"
        static let institutionKey = "institution"
    }
    
    init(nationalPersonID: String, cellphone: String, institution: String) {
        self.nationalPersonID = nationalPersonID
        self.cellphone = cellphone
        self.institution = institution
    }
    
    init(jsonObject: [String : AnyObject]) {
        nationalPersonID = jsonObject[KeyProperties.nationalPersonIDKey] as? String
        cellphone = jsonObject[KeyProperties.cellphoneKey] as? String
        institution = jsonObject[KeyProperties.institutionKey] as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(nationalPersonID, forKey: KeyProperties.nationalPersonIDKey)
        aCoder.encode(cellphone, forKey: KeyProperties.cellphoneKey)
        aCoder.encode(institution, forKey: KeyProperties.institutionKey)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        nationalPersonID = aDecoder.decodeObject(forKey: KeyProperties.nationalPersonIDKey) as? String
        cellphone = aDecoder.decodeObject(forKey: KeyProperties.cellphoneKey) as? String
        institution = aDecoder.decodeObject(forKey: KeyProperties.institutionKey) as? String
    }
    
    
    
}
