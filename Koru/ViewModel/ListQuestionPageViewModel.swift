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

import UIKit

class ListQuestionPageViewModel {
    
    var refugeSelected: Refuge!
    var categorySelected = [Category]()
    var nextViewController: QuestionViewController!
    var currentViewController: QuestionViewController!
    var orderedViewControllers = [UIViewController]()
    var questionViewModel: QuestionViewModel!
    var index = 0 {
        didSet {
            didChangeIndex?()
        }
    }
    
    var isChangePageView = false {
        didSet {
            didChangePage?()
        }
    }
    
    var isNext = false {
        didSet {
            didTouchNextButton?()
        }
    }
    
    var isPrevious = false {
        didSet {
            didTouchPreviousButton?()
        }
    }
    
    var isPressBackButton = false {
        didSet {
            didTouchBackButton?()
        }
    }
    
    var wasNotAnswered = false {
        didSet {
            didVerifyFormulary?()
        }
    }
    
    var isSendQuestionSuccess = false {
        didSet {
            didSendQuestionSuccess?()
        }
    }
    
    var canNotSummitForm = false {
        didSet {
            wasNotSummited?()
        }
    }
    
    
    var didTouchPreviousButton: (() -> Void)?
    var didTouchNextButton: (() -> Void)?
    var didTouchBackButton: (() -> Void)?
    var didVerifyFormulary: (() -> Void)?
    var didSendQuestionSuccess: (() -> Void)?
    var wasNotSummited: (() -> Void)?
    var didChangePage: (() -> Void)?
    var didChangeIndex:(() -> Void)?
    var didFailWithError: (() -> Void)?
    
    // Fill the pageViewController with the number of questions from the selected categories
    func fillPageViewController() {
        if let categories = refugeSelected.category {
            for (categoryIndex,category) in categories.enumerated() {
                if category.selected! {
                    for (index,sortedQuestion) in category.sortedQuestionArray!.enumerated() {
                        if index == (category.sortedQuestionArray?.count)! - 1 && categoryIndex == verifyLastCategorySelected()  {
                               orderedViewControllers.append(newViewController(category: category, sortedQuestion: sortedQuestion, isLastController: true))
                        } else {
                            orderedViewControllers.append(newViewController(category: category, sortedQuestion: sortedQuestion, isLastController: false))
                        }
                    }
                }
                
            }
        }
    }
    
    private func newViewController(category: Category, sortedQuestion: SortedQuestion, isLastController: Bool) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "questionViewController") as! QuestionViewController
        viewController.viewModel.category = category
        viewController.viewModel.sorteQuestion = sortedQuestion
        viewController.viewModel.isLastController = isLastController
        if isLastController {
            questionViewModel = viewController.viewModel
            viewController.viewModel.delegate = self
        }
        return viewController
    }
    
    func verifyLastCategorySelected() -> Int {
        var selectedCount = 0
        if let categories = refugeSelected.category {
            for (index, category) in categories.enumerated() {
                if category.selected! {
                    selectedCount = index
                }
            }
        }
        return selectedCount
    }
    
    func didChangePage(nextViewController: QuestionViewController) {
        
        self.nextViewController = nextViewController
        isChangePageView = true

    }
    
    func callServeForSendQuestion(sortedQuestionArray: [SortedQuestion]) {
        let body = NetworkMapper().bodySortedQuestionArray(from: sortedQuestionArray)
        var dni = ""
        if let monitor = UserManager.sharedInstance.currentUser {
            dni = monitor.nationalPersonID!
        } else {
            dni = EnumeratorUserManager.sharedInstance.currentEnumeratorUser!.nationalPersonID!
        }
        let date = DateFormatter.currentDate()
        RefugeService.sendQuestionFromShelter(questions: body, refuge: refugeSelected, dni: dni, date: date) { (message, error) in
            OperationQueue.main.addOperation {
                self.questionViewModel.didFinishAnimating?()

                if let message = message {
                    if message == "success" {
                        self.isSendQuestionSuccess = true
                        
                    } else if message == "error"{
                        self.didFailWithError?()
                    } else if message == "failure" {
                    
                    RefugePersistence().updateRefugeWith(pending: sortedQuestionArray, refugeSelected: self.refugeSelected, dni: dni, date: date)  { (result) in
                        if result {
                            self.canNotSummitForm = true
                        } else {
                            print("error")
                        }
                        }
                    }
                }
            }
        }
    }
    
}

extension ListQuestionPageViewModel: QuestionViewModelDelegate {
    func questionViewModelDidTouchContinueButton(sendCell: SendCell) {
        var verify = false
        var sortedQuestionArray = [SortedQuestion]()
        for viewController in orderedViewControllers {
            let questionViewController = viewController as! QuestionViewController
            if questionViewController.viewModel.wasAnswered {
                verify = true
                sortedQuestionArray.append(questionViewController.viewModel.sorteQuestion)
            }
        }
        
        if verify == false {
            sendCell.sendButton.loading = false
            self.wasNotAnswered = true
        } else {
            callServeForSendQuestion(sortedQuestionArray: sortedQuestionArray)
        }
     
    }
}
