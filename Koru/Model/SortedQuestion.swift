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

class SortedQuestion: Mappable {
    let id: Int?
    let text: String?
    let questionType: String?
    var subQuestions: [Question]? = nil
    let minValue: String?
    let maxValue: String?
    var answerArray: [Answer]? = nil
    
    required init(map: Mapper) throws {
        id      = map.optionalFrom(SortedQuestionKeys.id)
        text    = map.optionalFrom(SortedQuestionKeys.text)
        questionType     = map.optionalFrom(SortedQuestionKeys.questionType)
        subQuestions     = map.optionalFrom(SortedQuestionKeys.subQuestions)
        minValue     = map.optionalFrom(SortedQuestionKeys.minValue)
        maxValue     = map.optionalFrom(SortedQuestionKeys.maxValue)
        answerArray = map.optionalFrom(SortedQuestionKeys.answers)
    }
    
    init(id: Int?, text: String?, question_type: String?, sub_questions: [Question]?, min_value: String?, max_value: String?, answers: [Answer]?) {
        self.id = id
        self.text = text
        self.questionType = question_type
        self.subQuestions = sub_questions
        self.minValue = min_value
        self.maxValue = max_value
        self.answerArray = answers?.sorted { $0.id! < $1.id! }
    }
}

extension SortedQuestion {
    
    fileprivate struct  SortedQuestionKeys {
        static let id     = "id"
        static let text   = "text"
        static let questionType    = "question_type"
        static let subQuestions   = "sub_questions"
        static let minValue    = "min_value"
        static let maxValue   = "max_value"
        static let answers   = "answers"
    }
}
