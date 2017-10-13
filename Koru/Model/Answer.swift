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

class Answer: Mappable {
    let id: Int?
    var name: String?
    var withValue: Bool?
    var selected: Bool? = false
    var value: String? = ""
    let createdAt: String?
    let updatedAt: String?
    
    required init(map: Mapper) throws {
        id      = map.optionalFrom(AnswerKeys.id)
        name    = map.optionalFrom(AnswerKeys.name)
        withValue     = map.optionalFrom(AnswerKeys.withValue)
        createdAt     = map.optionalFrom(AnswerKeys.createdAt)
        updatedAt     = map.optionalFrom(AnswerKeys.updatedAt)
    }
    
    init(id: Int?, name: String?, withValue: Bool?, value: String?,selected: Bool?, createdAt: String?, updatedAt: String?) {
        self.id = id
        self.name = name
        self.withValue = withValue
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.selected = selected
        self.value = value
        
    }
}

extension Answer {
    
    fileprivate struct  AnswerKeys {
        static let id     = "id"
        static let name   = "name"
        static let withValue    = "with_value"
        static let createdAt    = "min_value"
        static let updatedAt   = "max_value"
    }
}
