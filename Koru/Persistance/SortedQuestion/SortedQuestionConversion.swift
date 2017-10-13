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

extension SortedQuestion {
    
    convenience init(sortedQuestionMO: SortedQuestionMO) {
        let id = Int(sortedQuestionMO.id)
        let maxValue = sortedQuestionMO.maxValue
        let minValue = sortedQuestionMO.minValue
        let text = sortedQuestionMO.text
        let questionType = sortedQuestionMO.questionType
        var subQuestionArray = [Question]()
        var answerArray = [Answer]()
        
        if let subQuestions = sortedQuestionMO.subquest?.allObjects as! [SortedQuestionMO]? {
            for subQuestion in subQuestions {
                let subquestion = Question(questionMO: subQuestion)
                subQuestionArray.append(subquestion)
            }
        }
        
        if let answerArrayMO = sortedQuestionMO.answer?.allObjects as! [AnswerMO]? {
            for answerMO in answerArrayMO {
                let answer = Answer(answeMO: answerMO)
                answerArray.append(answer)
            }
        }
            
            self.init(id: id, text: text, question_type: questionType, sub_questions: subQuestionArray, min_value: minValue, max_value: maxValue, answers:answerArray)
        }

}

extension Question {
    convenience init(questionMO: SortedQuestionMO) {
        let id = Int(questionMO.id)
        let maxValue = questionMO.maxValue
        let minValue = questionMO.minValue
        let text = questionMO.text
        let questionType = questionMO.questionType
        var answerArray = [Answer]()
        
        
        if let answerArrayMO = questionMO.answer?.allObjects as! [AnswerMO]? {
            for answerMO in answerArrayMO {
                let answer = Answer(answeMO: answerMO)
                answerArray.append(answer)
            }
        }
        
        self.init(id: id, text: text, question_type: questionType, min_value: minValue, max_value: maxValue, answers: answerArray)
    }

}


