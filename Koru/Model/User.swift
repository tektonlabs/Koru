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

protocol UserProtocol {
    var nationalPersonID: String?  {get set}
}

class User: NSObject, NSCoding, UserProtocol {
    
    var nationalPersonID: String?
    
    static let didLoginNotification     = "UserDidLogin"
    static let didLogoutNotification    = "UserDidLogout"
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("user")
    
    struct KeyProperties {
        static let nationalPersonIDKey  = "dni"
    }
    
    init(nationalPersonID: String){
        self.nationalPersonID = nationalPersonID
    }
    

    init(jsonObject: [String : AnyObject]) {
        nationalPersonID = jsonObject[KeyProperties.nationalPersonIDKey] as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(nationalPersonID, forKey: KeyProperties.nationalPersonIDKey)
    }
    
    required init(coder aDecoder: NSCoder) {
        nationalPersonID = aDecoder.decodeObject(forKey: KeyProperties.nationalPersonIDKey) as? String
    }
}
