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

class RefugeCensusDataViewController: UIViewController {

    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.estimatedRowHeight  = 40
        tableView.rowHeight  = UITableViewAutomaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(tableView)
        
        return tableView
    }()
    
    var viewModel: RefugeCensusDataViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableViewLayout()
        configureViewModelBinding()
    }
    
    func configureTableViewLayout() {
        
        let doubletextFieldNib = UINib(nibName: "DoubleTextFieldCell", bundle: nil)
        tableView.register(doubletextFieldNib, forCellReuseIdentifier: "doubleTextFieldCell")
        
        let multipleChoiceCellNib = UINib(nibName: "MultipleChoiceCell", bundle: nil)
        tableView.register(multipleChoiceCellNib, forCellReuseIdentifier: "multipleChoiceCell")

        let textFieldNib = UINib(nibName: "TextFieldCell", bundle: nil)
        tableView.register(textFieldNib, forCellReuseIdentifier: "textFieldCell")
        
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    }
    
    func configureViewModelBinding() {
        viewModel?.didFailValidation = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension RefugeCensusDataViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel?.sections.count ?? 0

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = viewModel?.sections[section] else {
            return 0
        }
        switch section {
        case .censos:
            return viewModel?.structureCellForCesusSection.count ?? 0
        case .typesOfService:
            return viewModel?.serviceTypesCheckboxesViewModels?.count ?? 0
        case .housingState:
            return viewModel?.housingStatesCheckboxesViewModels?.count ?? 0
        case .childrenUnder3:
            return viewModel?.structureCellForChildrenUnder3Section.count ?? 0
        case .peopleUnder18:
            return viewModel?.structureCellForPeopleUnder18.count ?? 0
        case .peopleOlderThanTo18:
            return viewModel?.structureCellForPeopleOlderTo18.count ?? 0
        case .peopleOlder:
            return viewModel?.structureCellForPeopleOlder.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = viewModel?.sections[indexPath.section] else {
            return UITableViewCell()
        }
        
        switch section {
        case .censos:
            guard let cellType = viewModel?.structureCellForCesusSection[indexPath.row] else {
                return UITableViewCell()
            }
            
            switch cellType {
            case .doubleTextFieldCell(let viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as! DoubleTextFieldCell
                cell.viewModel = viewModel
                cell.selectionStyle = .none
                cell.firstTextField.placeholder = viewModel.firstPlaceholder
                cell.secondTextField.placeholder = viewModel.secondPlaceholder
                cell.firstTextField.text = viewModel.firstText
                cell.secondTextField.text = viewModel.secondText
                cell.firstTextField.error = viewModel.firstError
                cell.secondTextField.error = viewModel.secondError
                return cell
                
            case .textFieldCell(let viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as! TextFieldCell
                cell.viewModel = viewModel
                cell.selectionStyle = .none
                cell.textField.placeholder = viewModel.placeholder
                cell.textField.text = viewModel.text
                cell.textField.error = viewModel.error
                cell.textField.keyboardType = .numberPad
                cell.maxNumberOfCharacters = viewModel.maxNumberOfCharacters
                return cell
            }
        case .childrenUnder3:
            guard let cellType = viewModel?.structureCellForChildrenUnder3Section[indexPath.row] else {
                return UITableViewCell()
            }
            
            switch cellType {
            case .doubleTextFieldCell(let viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as! DoubleTextFieldCell
                cell.viewModel = viewModel
                cell.selectionStyle = .none
                cell.firstTextField.placeholder = viewModel.firstPlaceholder
                cell.secondTextField.placeholder = viewModel.secondPlaceholder
                cell.firstTextField.text = viewModel.firstText
                cell.secondTextField.text = viewModel.secondText
                cell.firstTextField.error = viewModel.firstError
                cell.secondTextField.error = viewModel.secondError
                return cell
                
            case .textFieldCell(let viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as! TextFieldCell
                cell.viewModel = viewModel
                cell.selectionStyle = .none
                cell.textField.placeholder = viewModel.placeholder
                cell.textField.text = viewModel.text
                cell.textField.error = viewModel.error
                cell.textField.keyboardType = .numberPad
                cell.maxNumberOfCharacters = viewModel.maxNumberOfCharacters
                return cell
            }

        case .peopleUnder18:
            guard let cellType = viewModel?.structureCellForPeopleUnder18[indexPath.row] else {
                return UITableViewCell()
            }
            
            switch cellType {
            case .doubleTextFieldCell(let viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as! DoubleTextFieldCell
                cell.viewModel = viewModel
                cell.selectionStyle = .none
                cell.firstTextField.placeholder = viewModel.firstPlaceholder
                cell.secondTextField.placeholder = viewModel.secondPlaceholder
                cell.firstTextField.text = viewModel.firstText
                cell.secondTextField.text = viewModel.secondText
                cell.firstTextField.error = viewModel.firstError
                cell.secondTextField.error = viewModel.secondError
                return cell
                
            case .textFieldCell(let viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as! TextFieldCell
                cell.viewModel = viewModel
                cell.selectionStyle = .none
                cell.textField.placeholder = viewModel.placeholder
                cell.textField.text = viewModel.text
                cell.textField.error = viewModel.error
                cell.textField.keyboardType = .numberPad
                cell.maxNumberOfCharacters = viewModel.maxNumberOfCharacters
                return cell
            }

        case .peopleOlderThanTo18:
            guard let cellType = viewModel?.structureCellForPeopleOlderTo18[indexPath.row] else {
                return UITableViewCell()
            }
            
            switch cellType {
            case .doubleTextFieldCell(let viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as! DoubleTextFieldCell
                cell.viewModel = viewModel
                cell.selectionStyle = .none
                cell.firstTextField.placeholder = viewModel.firstPlaceholder
                cell.secondTextField.placeholder = viewModel.secondPlaceholder
                cell.firstTextField.text = viewModel.firstText
                cell.secondTextField.text = viewModel.secondText
                cell.firstTextField.error = viewModel.firstError
                cell.secondTextField.error = viewModel.secondError
                return cell
                
            case .textFieldCell(let viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as! TextFieldCell
                cell.viewModel = viewModel
                cell.selectionStyle = .none
                cell.textField.placeholder = viewModel.placeholder
                cell.textField.text = viewModel.text
                cell.textField.error = viewModel.error
                cell.textField.keyboardType = .numberPad
                cell.maxNumberOfCharacters = viewModel.maxNumberOfCharacters
                return cell
            }
        case .peopleOlder:
            guard let cellType = viewModel?.structureCellForPeopleOlder[indexPath.row] else {
                return UITableViewCell()
            }
            
            switch cellType {
            case .doubleTextFieldCell(let viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as! DoubleTextFieldCell
                cell.viewModel = viewModel
                cell.selectionStyle = .none
                cell.firstTextField.placeholder = viewModel.firstPlaceholder
                cell.secondTextField.placeholder = viewModel.secondPlaceholder
                cell.firstTextField.text = viewModel.firstText
                cell.secondTextField.text = viewModel.secondText
                cell.firstTextField.error = viewModel.firstError
                cell.secondTextField.error = viewModel.secondError
                return cell
                
            case .textFieldCell(let viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as! TextFieldCell
                cell.viewModel = viewModel
                cell.selectionStyle = .none
                cell.textField.placeholder = viewModel.placeholder
                cell.textField.text = viewModel.text
                cell.textField.error = viewModel.error
                cell.textField.keyboardType = .numberPad
                cell.maxNumberOfCharacters = viewModel.maxNumberOfCharacters
                return cell
            }

        case .typesOfService:
            guard let cellViewModel = self.viewModel?.serviceTypesCheckboxesViewModels?[indexPath.row] else {
                return UITableViewCell()
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "multipleChoiceCell", for: indexPath) as! MultipleChoiceCell
            cell.delegate = self
            cell.checkboxControl.titleLabel.text = cellViewModel.multipleChoice.name
            cell.checkboxControl.isSelected = cellViewModel.selected
            return cell

        case .housingState:
            guard let cellViewModel = self.viewModel?.housingStatesCheckboxesViewModels?[indexPath.row] else {
                return UITableViewCell()
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "multipleChoiceCell", for: indexPath) as! MultipleChoiceCell
            cell.delegate = self
            cell.checkboxControl.titleLabel.text = cellViewModel.multipleChoice.name
            cell.checkboxControl.isSelected = cellViewModel.selected
            return cell

            
        }
    }
}

extension RefugeCensusDataViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = viewModel?.sections[section] else {
            return nil
        }

        let titleLabel = UILabel()
        titleLabel.text = section.title
        titleLabel.backgroundColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        return titleLabel
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension RefugeCensusDataViewController: MultipleChoiceCellDelegate {
    func multipleChoiceCell(_ cell: MultipleChoiceCell, didSelectCheckbox selected: Bool) {
        
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        
        guard let sectionType = viewModel?.sections[indexPath.section] else {
            return
        }
        
        switch sectionType {
        case .typesOfService:
            guard let cellViewModel = self.viewModel?.serviceTypesCheckboxesViewModels?[indexPath.row] else {
                return
            }
            
            cellViewModel.selected = selected
            
        case .housingState:
            guard let cellViewModel = self.viewModel?.housingStatesCheckboxesViewModels?[indexPath.row] else {
                return
            }
            
            cellViewModel.selected = selected
        default:
            break
        }
    }
}
