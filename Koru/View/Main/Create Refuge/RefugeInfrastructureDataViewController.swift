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

class RefugeInfrastructureDataViewController: UIViewController {

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
    fileprivate var selectedIndexPath: IndexPath?
    
    var viewModel: RefugeInfrastructureDataViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableViewLayout()
        configureViewModelBinding()
    }
    
    func configureTableViewLayout() {
        
        let textFieldNib = UINib(nibName: "TextFieldCell", bundle: nil)
        tableView.register(textFieldNib, forCellReuseIdentifier: "textFieldCell")
        
        let dropdownFieldNib = UINib(nibName: "DropdownCell", bundle: nil)
        tableView.register(dropdownFieldNib, forCellReuseIdentifier: "dropdownCell")
        
        let doubleTextFieldNib = UINib(nibName: "DoubleTextFieldCell", bundle: nil)
        tableView.register(doubleTextFieldNib, forCellReuseIdentifier: "doubleTextFieldCell")
        
        let multipleChoiceCellNib = UINib(nibName: "MultipleChoiceCell", bundle: nil)
        tableView.register(multipleChoiceCellNib, forCellReuseIdentifier: "multipleChoiceCell")
        
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    }
    
    func configureViewModelBinding() {
        viewModel?.didSelectOption = { [weak self] (option: OptionItem) in
            if let selectedIndexPath = self?.selectedIndexPath, let cell = self?.tableView.cellForRow(at: selectedIndexPath) as? DropdownCell {
                cell.option = option.displayValue
                cell.errorLabel.text = ""
            }
        }

        viewModel?.didFailValidation = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension RefugeInfrastructureDataViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = viewModel?.sections[section] else {
            return 0
        }
        
        switch sectionType {
        case .infrestructure:
           return viewModel?.cellTypes(for: sectionType).count ?? 0
        case .presenceOf:
            return viewModel?.areasCheckboxesViewModels?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let sectionType = viewModel?.sections[indexPath.section] else {
            return UITableViewCell()
        }
        
        guard let cellType = viewModel?.cellTypes(for: sectionType) else {
            return UITableViewCell()
        }
        let type = cellType[indexPath.row]
        
        switch type {
        case .textFieldCell(let viewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as! TextFieldCell
            cell.viewModel = viewModel
            cell.selectionStyle = .none
            cell.textField.placeholder = viewModel.placeholder
            cell.textField.text = viewModel.text
            cell.textField.error = viewModel.error
            cell.textField.keyboardType = .numberPad
            cell.maxNumberOfCharacters = viewModel.maxNumberOfCharacters
            return cell
        case .dropDownCell(let viewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as! DropdownCell
            
            cell.selectionStyle = .none
            cell.placeholder = viewModel.placeholder
            cell.errorLabel.text = viewModel.error
            
            if let option = viewModel.selectedOption {
                cell.option = option.displayValue
            }
            return cell
        case .doubletextFieldCell(let viewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as! DoubleTextFieldCell
            cell.viewModel = viewModel
            cell.selectionStyle = .none
            cell.firstTextField.placeholder = viewModel.firstPlaceholder
            cell.secondTextField.placeholder = viewModel.secondPlaceholder
            cell.firstTextField.text = viewModel.firstText
            cell.secondTextField.text = viewModel.secondText
            
            cell.firstTextField.error = viewModel.firstError
            cell.secondTextField.error = viewModel.secondError
            return cell
        case .multipleChoiceCell(let viewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as! MultipleChoiceCell
            cell.delegate = self
            cell.checkboxControl.titleLabel.text = viewModel.multipleChoice.name
            cell.checkboxControl.isSelected = viewModel.selected
            return cell
        }
    }
}

extension RefugeInfrastructureDataViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        let titleLabel = UILabel()
        titleLabel.text = viewModel?.sections[section].title
        titleLabel.backgroundColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        return titleLabel
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndexPath = indexPath
        
        guard let section = viewModel?.sections[indexPath.section] else {
            return
        }
        
        guard let types = self.viewModel?.cellTypes(for: section) else {
            return
        }
        
        let cellType = types[indexPath.row]
        
        switch cellType {
        case .textFieldCell(_):
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as! TextFieldCell
            cell.textField.becomeFirstResponder()
        case .dropDownCell(let viewModel):
            let selectOptionViewController = SelectOptionViewController()
            selectOptionViewController.dropdownViewModel = viewModel
            
            if let navigationController = self.navigationController {
                navigationController.pushViewController(selectOptionViewController, animated: true)
            } else if let navigationController = self.parent?.navigationController {
                navigationController.pushViewController(selectOptionViewController, animated: true)
            } else {
                self.show(selectOptionViewController, sender: self)
            }
        default: break
        }
    }
}

extension RefugeInfrastructureDataViewController: MultipleChoiceCellDelegate {
    func multipleChoiceCell(_ cell: MultipleChoiceCell, didSelectCheckbox selected: Bool) {
        
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        
        guard let checkBoxViewModel = viewModel?.areasCheckboxesViewModels?[indexPath.row] else {
            return
        }
        
        checkBoxViewModel.selected = selected

    }
}

