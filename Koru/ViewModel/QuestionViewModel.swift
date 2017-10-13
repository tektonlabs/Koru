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
protocol QuestionViewModelDelegate: class {
    func questionViewModelDidTouchContinueButton(sendCell: SendCell)
}

class QuestionViewModel {
    var category: Category!
    var sorteQuestion: SortedQuestion!
    var sectionArray: [CellType] = []
    var viewModel = ListQuestionPageViewModel()
    var wasAnswered = false
    var isLastController = false
    weak var delegate: QuestionViewModelDelegate?
    var didFinishAnimating:(() -> Void)?
    
    init() {
        
    }
    
    
    var didFinishLoading: (() -> Void)?
    
 
    func  fillCollectionArray() {
        switch sorteQuestion.questionType! {
        case "one_choice":
         
            if let answerArray = sorteQuestion.answerArray {
                if answerArray.count == 2 {
                    sectionArray.append(.oneChoiseQuestionCell)
                } else if answerArray.count == 3 {
                    sectionArray.append(.oneChoiseThreeOptionCell)
                } else if answerArray.count == 4 {
                    sectionArray.append(.oneChoiseFourOptionCell)
                } else {
                    sectionArray.append(.questionCell)
                    if let subQuestionArray = sorteQuestion.subQuestions {
                        for question in subQuestionArray {
                            if question.answerArray?.count == 2 {
                                sectionArray.append(.oneChoiseTwoOptionCell)
                            } else {
                            sectionArray.append(.oneChoiseSubQuestionCell)
                        }
                    }
                }
            }
        }
        
        case "input_value":
            sectionArray.append(.inputValueQuestionCell)
        case "multiple_choice":
            sectionArray.append(.questionCell)
            if let answerArray = sorteQuestion.answerArray {
                for (index,answer) in answerArray.enumerated() {
                    if index == answerArray.count - 1 {
                        if answer.name == "Otros" {
                            sectionArray.append(.multipleChoiseWithInputCell)
                        } else {
                            sectionArray.append(.multipleChoiseQuestionCell)
                        }
                    } else {
                        sectionArray.append(.multipleChoiseQuestionCell)
                    }
                }
            }
        default:
            break
        }
        
        if isLastController {
            sectionArray.append(.sendCell)
        }
    }

}

extension QuestionViewModel {
    enum CellType {
        case radioButtonCell
        case questionCell
        case oneChoiseQuestionCell
        case inputValueQuestionCell
        case oneChoiseSubQuestionCell
        case oneChoiseThreeOptionCell
        case oneChoiseFourOptionCell
        case multipleChoiseQuestionCell
        case multipleChoiseWithInputCell
        case oneChoiseTwoOptionCell
        case sendCell
        
        var identifier: String {
            switch self {
            case .radioButtonCell: return "radioButtonCell"
            case .questionCell: return "questionCell"
            case .oneChoiseQuestionCell: return "oneChoiseQuestionCell"
            case .inputValueQuestionCell: return "inputValueQuestionCell"
            case .oneChoiseSubQuestionCell: return "oneChoiseSubQuestionCell"
            case .oneChoiseThreeOptionCell: return "0neChoiseThreeOptionCell"
            case .oneChoiseFourOptionCell: return "oneChoiseFourOptionCell"
            case .multipleChoiseQuestionCell: return "multipleChoiseCell"
            case .multipleChoiseWithInputCell: return "multipleChoiseWithInputCell"
            case .oneChoiseTwoOptionCell: return "oneChoiseTwoOptionCell"
            case .sendCell: return "sendCell"
            }
        }
        
        var nibName: String {
            switch self {
            case .radioButtonCell: return "RadioButtonCell"
            case .questionCell: return "QuestionCell"
            case .oneChoiseQuestionCell: return "OneChoiseQuestionCell"
            case .inputValueQuestionCell: return "InputValueQuestionCell"
            case .oneChoiseSubQuestionCell: return "OneChoiseSubQuestionCell"
            case .oneChoiseThreeOptionCell: return "OneChoiseThreeOptionCell"
            case .oneChoiseFourOptionCell: return "OneChoiseFourOptionCell"
            case .multipleChoiseQuestionCell: return "MultipleChoiseCell"
            case .multipleChoiseWithInputCell: return "MultipleChoiseWithInputCell"
            case .oneChoiseTwoOptionCell: return "OneChoiseTwoOptionCell"
            case .sendCell: return "SendCell"
            }
        }
    }
}
