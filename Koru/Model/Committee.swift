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

class Committee: Mappable, SearchResult {
    var id: Int
    var name: String
    var title: String {
        get {
            return name
        } set {
            name = newValue
        }
    }
    
    init(id: Int, name: String) {
        self.id     = id
        self.name   = name
    }
    
    required init(map: Mapper) throws {
        id   = try! map.from(CommitteeKeys.id)
        name = try! map.from(CommitteeKeys.name)
    }
}

extension Committee {
    
    fileprivate struct CommitteeKeys {
        static let id = "id"
        static let name = "name"
    }
    
}
