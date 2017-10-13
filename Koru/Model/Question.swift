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
class Question: Mappable {
    let id: Int?
    let text: String?
    let questionType: String?
    let minValue: String?
    let maxValue: String?
    let answerArray: [Answer]?
    
    required init(map: Mapper) throws {
        id      = map.optionalFrom(QuestionKeys.id)
        text    = map.optionalFrom(QuestionKeys.text)
        questionType     = map.optionalFrom(QuestionKeys.questionType)
        minValue     = map.optionalFrom(QuestionKeys.minValue)
        maxValue     = map.optionalFrom(QuestionKeys.maxValue)
        answerArray = map.optionalFrom(QuestionKeys.answers)
    }
    
    init(id: Int?, text: String?, question_type: String?, min_value: String?, max_value: String?, answers: [Answer]?) {
        self.id = id
        self.text = text
        self.questionType = question_type
        self.minValue = min_value
        self.maxValue = max_value
        self.answerArray = answers?.sorted { $0.id! < $1.id! }
    }
}

extension Question {
    
    fileprivate struct  QuestionKeys {
        static let id     = "id"
        static let text   = "text"
        static let questionType    = "question_type"
        static let minValue    = "min_value"
        static let maxValue   = "max_value"
        static let answers   = "answers"

    }
    

}
