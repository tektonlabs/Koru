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
import CoreData

extension Category {
    
    convenience init(categoryMO: CategoryMO) {
        let id = Int(categoryMO.id)
        let name = categoryMO.name
        let level = categoryMO.level
        let selected = false
        var sortedQuestionArray = [SortedQuestion]()
        if let sortedQuestions = categoryMO.sortedques?.allObjects as! [SortedQuestionMO]? {
            for (_,sortedQuestion) in sortedQuestions.enumerated() {
                let sortedQuestion = SortedQuestion(sortedQuestionMO: sortedQuestion)
                sortedQuestionArray.append(sortedQuestion)
            }
        }
       
    
        self.init(id: id, name: name!, level: level!, selected: selected,sortedQuestions: sortedQuestionArray)
    }
}

