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

class QuestionViewController: UIViewController {

    var tableView: UITableView!
    var viewModel = QuestionViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        viewModel.fillCollectionArray()
        setupTableView()

        setupKeyboardNotifications()
    }
    
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(QuestionViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(QuestionViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide , object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
            self.tableView.contentInset = contentInset
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func setupTableView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 33
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.white
        
        viewModel.didFinishAnimating = {
            let section = self.viewModel.sectionArray.count - 1
            let indexPath = IndexPath(row: 0, section: section)
            guard let cell = self.tableView.cellForRow(at: indexPath) as? SendCell else {
                return
            }
            
            cell.sendButton.loading = false

        }
        
        
        let radioButtonCellXib = UINib(nibName: QuestionViewModel.CellType.radioButtonCell.nibName, bundle: nil)
        tableView.register(radioButtonCellXib, forCellReuseIdentifier: QuestionViewModel.CellType.radioButtonCell.identifier)
        
        let questionCellXib = UINib(nibName: QuestionViewModel.CellType.questionCell.nibName, bundle: nil)
        tableView.register(questionCellXib, forCellReuseIdentifier: QuestionViewModel.CellType.questionCell.identifier)
        
        let oneChoiseQuestionCellXib = UINib(nibName: QuestionViewModel.CellType.oneChoiseQuestionCell.nibName, bundle: nil)
        tableView.register(oneChoiseQuestionCellXib, forCellReuseIdentifier: QuestionViewModel.CellType.oneChoiseQuestionCell.identifier)
        
        let inputValueQuestionCellXib = UINib(nibName: QuestionViewModel.CellType.inputValueQuestionCell.nibName, bundle: nil)
        tableView.register(inputValueQuestionCellXib, forCellReuseIdentifier: QuestionViewModel.CellType.inputValueQuestionCell.identifier)
        
        let oneChoiseSubQuestionCellXib = UINib(nibName: QuestionViewModel.CellType.oneChoiseSubQuestionCell.nibName, bundle: nil)
        tableView.register(oneChoiseSubQuestionCellXib, forCellReuseIdentifier: QuestionViewModel.CellType.oneChoiseSubQuestionCell.identifier)
        
        let oneChoiseThreeOptionCelllXib = UINib(nibName: QuestionViewModel.CellType.oneChoiseThreeOptionCell.nibName, bundle: nil)
        tableView.register(oneChoiseThreeOptionCelllXib, forCellReuseIdentifier: QuestionViewModel.CellType.oneChoiseThreeOptionCell.identifier)
        
        let oneChoiseFourOptionCellXib = UINib(nibName: QuestionViewModel.CellType.oneChoiseFourOptionCell.nibName, bundle: nil)
        tableView.register(oneChoiseFourOptionCellXib, forCellReuseIdentifier: QuestionViewModel.CellType.oneChoiseFourOptionCell.identifier)
        
        let multipleChoiseCellXib = UINib(nibName: QuestionViewModel.CellType.multipleChoiseQuestionCell.nibName, bundle: nil)
        tableView.register(multipleChoiseCellXib, forCellReuseIdentifier: QuestionViewModel.CellType.multipleChoiseQuestionCell.identifier)
        
        let multipleChoiseWithInputCellXib = UINib(nibName: QuestionViewModel.CellType.multipleChoiseWithInputCell.nibName, bundle: nil)
        tableView.register(multipleChoiseWithInputCellXib, forCellReuseIdentifier: QuestionViewModel.CellType.multipleChoiseWithInputCell.identifier)
        
        let oneChoiseTwoOptionCellXib = UINib(nibName: QuestionViewModel.CellType.oneChoiseTwoOptionCell.nibName, bundle: nil)
        tableView.register(oneChoiseTwoOptionCellXib, forCellReuseIdentifier: QuestionViewModel.CellType.oneChoiseTwoOptionCell.identifier)
        
        let continueCellXib = UINib(nibName: QuestionViewModel.CellType.sendCell.nibName, bundle: nil)
        tableView.register(continueCellXib, forCellReuseIdentifier: QuestionViewModel.CellType.sendCell.identifier)
        
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        tableView.keyboardDismissMode = .onDrag

    }

}

extension QuestionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionArray.count
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.sectionArray[indexPath.section]
        let isLastCell = indexPath.section == viewModel.sectionArray.count-1 ? true : false
        switch section {
            
        case .questionCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: section.identifier, for: indexPath) as! QuestionCell
            cell.questionLabel.text = viewModel.sorteQuestion.text
            return cell
        case .radioButtonCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: section.identifier, for: indexPath) as! RadioButtonCell
            return cell
        case .oneChoiseQuestionCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: section.identifier, for: indexPath) as! OneChoiseQuestionCell
            cell.isLastCell = isLastCell
            cell.questionLabel.text = viewModel.sorteQuestion.text
            cell.delegate = self
            if let answerArray = viewModel.sorteQuestion.answerArray {
                for (index,answer) in answerArray.enumerated() {
                    switch index {
                    case 0:
                        cell.optionYesLabel.text = answer.name
                    case 1:
                        cell.optionNoLabel.text = answer.name
                    default: break
                    }
                }
            }
            return cell
        case .inputValueQuestionCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: section.identifier, for: indexPath) as! InputValueQuestionCell
            cell.delegate = self
            cell.questionLabel.text = viewModel.sorteQuestion.text
            return cell
        case .oneChoiseSubQuestionCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: section.identifier, for: indexPath) as! OneChoiseSubQuestionCell
            cell.isLastCell = isLastCell
            cell.questionLabel.text = viewModel.sorteQuestion.subQuestions?[indexPath.section - 1].text
            cell.delegate = self
            if let answeArray = viewModel.sorteQuestion.subQuestions?[indexPath.section - 1].answerArray {
                for (index,answer) in answeArray.enumerated() {
                    switch index {
                    case 0:
                        cell.oneOptionLabel.text = answer.name
                    case 1:
                        cell.twoOptionLabel.text = answer.name
                    case 2:
                        cell.threeOptionLabel.text = answer.name
                        
                    default: break
                    }
                }
            }
            return cell
        case .oneChoiseThreeOptionCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: section.identifier, for: indexPath) as! OneChoiseThreeOptionCell
            cell.delegate = self
            cell.questionLabel.text = viewModel.sorteQuestion.text
            if let answeArray = viewModel.sorteQuestion.answerArray {
                for (index,answer) in answeArray.enumerated() {
                    switch index {
                    case 0:
                        cell.oneOptionLabel.text = answer.name
                    case 1:
                        cell.twoOptionLabel.text = answer.name
                    case 2:
                        cell.threeOptionLabel.text = answer.name
                        
                    default: break
                    }
                }
            }
            return cell
        case .oneChoiseFourOptionCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: section.identifier, for: indexPath) as! OneChoiseFourOptionCell
            cell.delegate = self
            cell.questionLabel.text = viewModel.sorteQuestion.text
            if let answeArray = viewModel.sorteQuestion.answerArray {
                for (index,answer) in answeArray.enumerated() {
                    switch index {
                    case 0:
                        cell.oneOptionLabel.text = answer.name
                    case 1:
                        cell.twoOptionLabel.text = answer.name
                    case 2:
                        cell.threeOptionLabel.text = answer.name
                    case 3:
                        cell.fourOptionLabel.text = answer.name
                    default: break
                    }
                }
            }
            return cell
        case .multipleChoiseQuestionCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: section.identifier, for: indexPath) as! MultipleChoiseCell
            cell.delegate = self
            cell.isLastCell = isLastCell
            cell.checkBoxView.titleLabel.text = viewModel.sorteQuestion.answerArray?[indexPath.section - 1].name
            return cell
        case .multipleChoiseWithInputCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: section.identifier, for: indexPath) as! MultipleChoiseWithInputCell
            cell.delegate = self
            cell.checkBoxView.titleLabel.text = viewModel.sorteQuestion.answerArray?[indexPath.section - 1].name
            return cell
        case .oneChoiseTwoOptionCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: section.identifier, for: indexPath) as! OneChoiseTwoOptionCell
            cell.isLastCell = isLastCell
            cell.delegate = self
            if let answerArray = viewModel.sorteQuestion.subQuestions?[indexPath.section - 1].answerArray {
                cell.questionLabel.text = viewModel.sorteQuestion.subQuestions?[indexPath.section - 1].text
                for (index,answer) in answerArray.enumerated() {
                    switch index {
                    case 0:
                        cell.optionYesLabel.text = answer.name
                    case 1:
                        cell.optionNoLabel.text = answer.name
                    default: break
                    }
                }
            }
            
            return cell
        case .sendCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: section.identifier, for: indexPath) as! SendCell
            cell.viewModel.delegate = self
            return cell
        }
    }

}


    
extension QuestionViewController: OneChoiseQuestionCellDelegate {
    func didTouchOptionYesRadioButton(cell: OneChoiseQuestionCell) {
            cell.optionYesRadioButton.isSelected = true
            viewModel.wasAnswered = true
        if cell.optionNoRadioButton.isSelected == true {
            cell.optionNoRadioButton.isSelected = false
        }
            if let answerArray = viewModel.sorteQuestion.answerArray {
                for answer in answerArray {
                    if answer.name == "Sí" {
                        answer.selected = true
                    } else {
                        answer.selected = false
                    }
                }
            }
        }
    func didTouchOptionNoRadioButton(cell: OneChoiseQuestionCell) {
        cell.optionNoRadioButton.isSelected = true
        viewModel.wasAnswered = true
        if cell.optionYesRadioButton.isSelected == true {
            cell.optionYesRadioButton.isSelected = false
        }
            if let answerArray = viewModel.sorteQuestion.answerArray {
                for answer in answerArray {
                    if answer.name == "No" {
                        answer.selected = true
                    } else {
                        answer.selected = false
                    }
                }
            }
        }

}

extension QuestionViewController: InputValueQuestionCellDelegate {
    func inputValueQuestionCellTextDidChange(cell: InputValueQuestionCell) {
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
        
    }

    func inputValueQuestionCellDidChangeText(cell: InputValueQuestionCell, changeText: String) {
        if viewModel.sorteQuestion.answerArray?.count == 0 {
            let answer = Answer(id: 0, name: "",withValue: false, value: changeText, selected: false,createdAt: "", updatedAt: "")
            answer.value = changeText
            viewModel.sorteQuestion.answerArray?.append(answer)
            viewModel.wasAnswered = true

        } else {
            viewModel.sorteQuestion.answerArray?.first?.value = changeText
            viewModel.wasAnswered = true

        }
    }
}

extension QuestionViewController: OneChoiseSubQuestionCellDelegate {
    func oneChoiseSubQuestionCellDidTouchOptionOneRadioButton(cell: OneChoiseSubQuestionCell) {
        cell.oneOptionRadioButton.isSelected = true
        viewModel.wasAnswered = true
        if cell.twoOptionRadioButton.isSelected == true {
            cell.twoOptionRadioButton.isSelected = false
        }
        if cell.threeOptionRadioButton.isSelected == true {
            cell.threeOptionRadioButton.isSelected = false
        }
        if let indexPath = tableView.indexPath(for: cell) {
                if let answeArray = viewModel.sorteQuestion.subQuestions?[indexPath.section - 1].answerArray {
                    for (index,answer) in answeArray.enumerated() {
                        switch index {
                        case 0:
                            answer.selected = true
                        case 1:
                            answer.selected = false
                        case 2:
                            answer.selected = false
                            
                        default: break
                        }
                    }
                }
        }
    }
    
    func oneChoiseSubQuestionCellDidTouchOptionTwoRadioButton(cell: OneChoiseSubQuestionCell) {
        cell.twoOptionRadioButton.isSelected = true
        viewModel.wasAnswered = true
        if cell.oneOptionRadioButton.isSelected == true {
            cell.oneOptionRadioButton.isSelected = false
        }
        if cell.threeOptionRadioButton.isSelected == true {
            cell.threeOptionRadioButton.isSelected = false
        }
            if let indexPath = tableView.indexPath(for: cell) {
                if let answeArray = viewModel.sorteQuestion.subQuestions?[indexPath.section - 1].answerArray {
                    for (index,answer) in answeArray.enumerated() {
                        switch index {
                        case 0:
                            answer.selected = false
                        case 1:
                            answer.selected = true
                        case 2:
                            answer.selected = false
                        default: break
                        }
                    }
                }
            }
        
    }
    func oneChoiseSubQuestionCellDidTouchOptionThreeRadioButton(cell: OneChoiseSubQuestionCell) {
        cell.threeOptionRadioButton.isSelected = true
        viewModel.wasAnswered = true
        if cell.twoOptionRadioButton.isSelected == true {
            cell.twoOptionRadioButton.isSelected = false
        }
        if cell.oneOptionRadioButton.isSelected == true {
            cell.oneOptionRadioButton.isSelected = false
        }
            if let indexPath = tableView.indexPath(for: cell) {
                if let answeArray = viewModel.sorteQuestion.subQuestions?[indexPath.section - 1].answerArray {
                    for (index,answer) in answeArray.enumerated() {
                        switch index {
                        case 0:
                            answer.selected = false
                        case 1:
                            answer.selected = false
                        case 2:
                            answer.selected = true
                        default: break
                        }
                    }
                }
            }
        }
}

extension QuestionViewController: OneChoiseThreeOptionCellDelegate {
    func oneChoiseThreeOptionCellDidTouchOptionOneRadioButton(cell: OneChoiseThreeOptionCell) {
        viewModel.wasAnswered = true
        cell.oneOptionRadioButton.isSelected = true
        if cell.twoOptionRadioButton.isSelected == true {
            cell.twoOptionRadioButton.isSelected = false
        }
        if cell.threeOptionRadioButton.isSelected == true {
            cell.threeOptionRadioButton.isSelected = false
        }
            if let answeArray = viewModel.sorteQuestion.answerArray {
                for (index,answer) in answeArray.enumerated() {
                    switch index {
                    case 0:
                        answer.selected = true
                    case 1:
                        answer.selected = false
                    case 2:
                        answer.selected = false
                        
                    default: break
                    }
                }
            }
        
    }
    
    func oneChoiseThreeOptionCellDidTouchOptionTwoRadioButton(cell: OneChoiseThreeOptionCell) {
        viewModel.wasAnswered = true
        cell.twoOptionRadioButton.isSelected = true
        if cell.oneOptionRadioButton.isSelected == true {
            cell.oneOptionRadioButton.isSelected = false
        }
        if cell.threeOptionRadioButton.isSelected == true {
            cell.threeOptionRadioButton.isSelected = false
        }
            if let answeArray = viewModel.sorteQuestion.answerArray {
                for (index,answer) in answeArray.enumerated() {
                    switch index {
                    case 0:
                        answer.selected = false
                    case 1:
                        answer.selected = true
                    case 2:
                        answer.selected = false
                    default: break
                    }
                }
            }
        
        
    }
    func oneChoiseThreeOptionCellDidTouchOptionThreeRadioButton(cell: OneChoiseThreeOptionCell) {
        viewModel.wasAnswered = true
        cell.threeOptionRadioButton.isSelected = true
        if cell.twoOptionRadioButton.isSelected == true {
            cell.twoOptionRadioButton.isSelected = false
        }
        if cell.oneOptionRadioButton.isSelected == true {
            cell.oneOptionRadioButton.isSelected = false
        }
            if let answeArray = viewModel.sorteQuestion.answerArray {
                for (index,answer) in answeArray.enumerated() {
                    switch index {
                    case 0:
                        answer.selected = false
                    case 1:
                        answer.selected = false
                    case 2:
                        answer.selected = true
                    default: break
                    }
                }
            }
    }
    
}


extension QuestionViewController: MultipleChoiseCellDelegate {
    func multipleChoiseCellDidTouchCheckBodx(cell: MultipleChoiseCell) {
        viewModel.wasAnswered = true
        if let indexPath = tableView.indexPath(for: cell) {
            if let answer = viewModel.sorteQuestion.answerArray?[indexPath.section - 1] {
                if answer.selected == true {
                    answer.selected = false
                } else {
                    answer.selected = true
                }
            }
        }
    }
}

extension QuestionViewController: MultipleChoiseWithInputCellDelegate {
    func multipleChoiseWithInputCellDidTextChange(cell: MultipleChoiseWithInputCell) {
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        if let thisIndexPath = tableView.indexPath(for: cell) {
            tableView?.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
        }
    }
  
    
    func multipleChoiseWithInputCellDidTouchCheckBox(cell: MultipleChoiseWithInputCell) {
        cell.changeCanByEditing { 
            let currentOffset = tableView.contentOffset
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            tableView.setContentOffset(currentOffset, animated: false)
        }
        
        viewModel.wasAnswered = true
        if let indexPath = tableView.indexPath(for: cell) {
            if let answer = viewModel.sorteQuestion.answerArray?[indexPath.section - 1] {
                if answer.selected == true {
                    answer.selected = false
                } else {
                    answer.selected = true
                }
            }
        }
    }
    
    func multipleChoiseWithInputCellDidChangeText(cell: MultipleChoiseWithInputCell, changeText: String) {
        if let indexPath = tableView.indexPath(for: cell) {
            if let answer = viewModel.sorteQuestion.answerArray?[indexPath.section - 1] {
            answer.value = changeText

            }
        }
    }
}

extension QuestionViewController: OneChoiseTwoOptionCellDelegate {
    func oneChoiseTwoOptionCellDidTouchOptionYesRadioButton(cell: OneChoiseTwoOptionCell) {
        viewModel.wasAnswered = true
        cell.optionYesRadioButton.isSelected = true
        if cell.optionNoRadioButton.isSelected == true {
            cell.optionNoRadioButton.isSelected = false
        }
        
        if let indexPath = tableView.indexPath(for: cell) {
            if let answerArray = viewModel.sorteQuestion.subQuestions?[indexPath.section - 1].answerArray {
                for answer in answerArray {
                    if answer.name == "Sí" {
                        answer.selected = true
                    } else {
                        answer.selected = false
                    }
                }
            }
        }
    }
    
    func oneChoiseTwoOptionCellDidTouchOptionNoRadioButton(cell: OneChoiseTwoOptionCell) {
        cell.optionNoRadioButton.isSelected = true
        viewModel.wasAnswered = true
        if cell.optionYesRadioButton.isSelected == true {
            cell.optionYesRadioButton.isSelected = false
        }
        if let indexPath = tableView.indexPath(for: cell) {
            if let answerArray = viewModel.sorteQuestion.subQuestions?[indexPath.section - 1].answerArray {
                for answer in answerArray {
                    if answer.name == "No" {
                        answer.selected = true
                    } else {
                        answer.selected = false
                    }
                }
            }
        }
    }

}

extension QuestionViewController: OneChoiseFourOptionCellDelegate {
    func oneChoiseFourOptionCellDidTouchOptionOneRadioButton(cell: OneChoiseFourOptionCell) {
        viewModel.wasAnswered = true
        cell.oneOptionRadioButton.isSelected = true
        if cell.twoOptionRadioButton.isSelected == true {
            cell.twoOptionRadioButton.isSelected = false
        }
        if cell.threeOptionRadioButton.isSelected == true {
            cell.threeOptionRadioButton.isSelected = false
        }
        
        if cell.fourOptionRadioButton.isSelected == true {
            cell.fourOptionRadioButton.isSelected = false
        }
        
            if let answeArray = viewModel.sorteQuestion.answerArray {
                for (index,answer) in answeArray.enumerated() {
                    switch index {
                    case 0:
                        answer.selected = true
                    case 1:
                        answer.selected = false
                    case 2:
                        answer.selected = false
                    case 3:
                        answer.selected = false
                    default: break
                    }
            }
        }

    }
    func oneChoiseFourOptionCellDidTouchOptionTwoRadioButton(cell: OneChoiseFourOptionCell) {
        viewModel.wasAnswered = true
        cell.twoOptionRadioButton.isSelected = true
        if cell.oneOptionRadioButton.isSelected == true {
            cell.oneOptionRadioButton.isSelected = false
        }
        if cell.threeOptionRadioButton.isSelected == true {
            cell.threeOptionRadioButton.isSelected = false
        }
        
        if cell.fourOptionRadioButton.isSelected == true {
            cell.fourOptionRadioButton.isSelected = false
        }
        
            if let answeArray = viewModel.sorteQuestion.answerArray {
                for (index,answer) in answeArray.enumerated() {
                    switch index {
                    case 0:
                        answer.selected = false
                    case 1:
                        answer.selected = true
                    case 2:
                        answer.selected = false
                    case 3:
                        answer.selected = false

                    default: break
                    }
            }
        }

    }
    
    func oneChoiseFourOptionCellDidTouchOptionFourRadioButton(cell: OneChoiseFourOptionCell) {
        viewModel.wasAnswered = true
        cell.fourOptionRadioButton.isSelected = true
        if cell.twoOptionRadioButton.isSelected == true {
            cell.twoOptionRadioButton.isSelected = false
        }
        if cell.threeOptionRadioButton.isSelected == true {
            cell.threeOptionRadioButton.isSelected = false
        }
        
        if cell.oneOptionRadioButton.isSelected == true {
            cell.oneOptionRadioButton.isSelected = false
        }
        
            if let answeArray = viewModel.sorteQuestion.answerArray {
                for (index,answer) in answeArray.enumerated() {
                    switch index {
                    case 0:
                        answer.selected = false
                    case 1:
                        answer.selected = false
                    case 2:
                        answer.selected = false
                    case 3:
                        answer.selected = true

                    default: break
                    }
                
            }
        }

    }
    
    func oneChoiseFourOptionCellDidTouchOptionThreeRadioButton(cell: OneChoiseFourOptionCell) {
        viewModel.wasAnswered = true
        cell.threeOptionRadioButton.isSelected = true
        if cell.twoOptionRadioButton.isSelected == true {
            cell.twoOptionRadioButton.isSelected = false
        }
        if cell.fourOptionRadioButton.isSelected == true {
            cell.fourOptionRadioButton.isSelected = false
        }
        
        if cell.oneOptionRadioButton.isSelected == true {
            cell.oneOptionRadioButton.isSelected = false
        }
        
            if let answeArray = viewModel.sorteQuestion.answerArray {
                for (index,answer) in answeArray.enumerated() {
                    switch index {
                    case 0:
                        answer.selected = false
                    case 1:
                        answer.selected = false
                    case 2:
                        answer.selected = true
                    case 3:
                        answer.selected = false

                    default: break
                    }
            }
        }

    }
}

extension QuestionViewController: SendCellViewModelDelegate {
    func didTouchButton(cell: SendCell) {
        viewModel.delegate?.questionViewModelDidTouchContinueButton(sendCell: cell)
    }
}


