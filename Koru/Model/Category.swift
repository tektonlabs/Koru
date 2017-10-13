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
class Category: Mappable {
    
    let id: Int?
    let name: String?
    let level: String?
    var selected: Bool? = false
    let sortedQuestionArray: [SortedQuestion]?
    
    required init(map: Mapper) throws {
        id      = map.optionalFrom(CategoryKeys.id)
        name    = map.optionalFrom(CategoryKeys.name)
        level     = map.optionalFrom(CategoryKeys.level)
        selected = false
        sortedQuestionArray = map.optionalFrom(CategoryKeys.sortedQuestion)
    }
    
    init(id: Int, name: String, level: String,selected: Bool, sortedQuestions: [SortedQuestion]?) {
        self.id = id
        self.name = name
        self.level = level
        self.sortedQuestionArray = sortedQuestions?.sorted { $0.id! < $1.id! }
        self.selected = selected
    }
}

extension Category {
    
    fileprivate struct CategoryKeys {
        static let id     = "id"
        static let name   = "name"
        static let level    = "level"
        static let sortedQuestion = "sorted_questions"
    }

}
