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
import Mapper

class SAError: NSObject, LocalizedError, Mappable {
    var errorDescription: String? {
        get {
            return "\(message ?? "") \(errorMessageDescription ?? "")"
        }
    }
    
    override var description: String {
        get {
            return "\(errorMessageDescription ?? "")"
        }
    }
    
    var code: Int?
    var message: String?
    var errorMessageDescription: String?
    var reasons: [String: String]?
    
    required init(map: Mapper) throws {
        code = map.optionalFrom(SAErrorKeys.code)
        message = map.optionalFrom(SAErrorKeys.message)
        errorMessageDescription = map.optionalFrom(SAErrorKeys.description)
        reasons = map.optionalFrom(SAErrorKeys.reasons)
    }
}

extension SAError {
    struct SAErrorKeys {
        static let error = "error"
        static let code = "code"
        static let message = "message"
        static let description = "description"
        static let reasons = "reasons"
    }
}
