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

class MultipleChoice: Mappable {
    
    fileprivate struct MultipleChoiceKeys {
        static let id = "id"
        static let name = "name"
        static let tableName = "table_name"
    }
    
    
    var id: Int
    var name: String
    var tableName: String
    
    init(id: Int, name: String, tableName: String) {
        self.id = id
        self.name = name
        self.tableName = tableName
    }
    
    required init(map: Mapper) throws {
        self.id = try! map.from(MultipleChoiceKeys.id)
        self.name = try! map.from(MultipleChoiceKeys.name)
        self.tableName = try! map.from(MultipleChoiceKeys.tableName)
    }
}
