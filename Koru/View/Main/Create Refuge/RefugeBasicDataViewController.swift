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

class RefugeBasicDataViewController: UIViewController {
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.estimatedRowHeight  = 93
        tableView.rowHeight  = UITableViewAutomaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(tableView)
        
        return tableView
    }()
    
    fileprivate lazy var selectAddressViewController: SelectAddressViewController = {
        let viewController = SelectAddressViewController()
        viewController.title = "Ubicación del Albergue"
        viewController.viewModel = self.viewModel.addressCellViewModel
        return viewController
    }()
    
    
    fileprivate var selectedIndexPath: IndexPath?
    
    var viewModel: RefugeBasicDataViewModel!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableViewLayout()
        configureViewModelBinding()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    func configureTableViewLayout() {
        
        let textFieldNib = UINib(nibName: "TextFieldCell", bundle: nil)
        tableView.register(textFieldNib, forCellReuseIdentifier: "textFieldCell")
        
        let dropdownFieldNib = UINib(nibName: "DropdownCell", bundle: nil)
        tableView.register(dropdownFieldNib, forCellReuseIdentifier: "dropdownCell")
        
        let selectAddresCellNib = UINib(nibName: "SelectAddressCell", bundle: nil)
        tableView.register(selectAddresCellNib, forCellReuseIdentifier: "SelectAddressCell")
        
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    }
    
    func configureViewModelBinding() {
        viewModel.didSelectOption = { [weak self] (option: OptionItem) in
            if let selectedIndexPath = self?.selectedIndexPath {
                self?.tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            }
        }
        
        viewModel.didSelectAddress = { [weak self] (address: Address) in
            if let selectedIndexPath = self?.selectedIndexPath {
                self?.tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            }
        }
        
        viewModel.didFailValidation = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension RefugeBasicDataViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.tableStructure.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let types = self.viewModel.tableStructure
        let cellType = types[indexPath.row]
        
        switch cellType {
        case .textFieldCell(let viewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as! TextFieldCell
            cell.viewModel = viewModel
            cell.selectionStyle = .none
            cell.textField.placeholder = viewModel.placeholder
            cell.textField.text = viewModel.text
            cell.textField.error = viewModel.error
            return cell
        case .dropDownCell(let viewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as! DropdownCell
            
            cell.selectionStyle = .none
            cell.placeholder = viewModel.placeholder
            cell.errorLabel.text = viewModel.error
            
            if let option = viewModel.selectedOption {
                cell.option = option.displayValue
            }
            return cell
        case .locationCell(let viewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as! SelectAddressCell
            cell.selectionStyle = .none
            cell.placeholder = viewModel.placeholder
            cell.errorLabel.text = viewModel.error
            
            if let address = viewModel.selectedAddress {
                cell.address = address.name
            }
            
            return cell
        }
    }
}

extension RefugeBasicDataViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndexPath = indexPath
        
        let types = self.viewModel.tableStructure
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
            
        case .locationCell(let viewModel):
            selectAddressViewController.selectedAddress = viewModel.selectedAddress
            let customNavigationController = InitialNavigationController()
            customNavigationController.setViewControllers([selectAddressViewController], animated: true)
            
            if let parent = self.parent {
                parent.present(customNavigationController, animated: true, completion: nil)
            } else {
                self.present(customNavigationController, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = UILabel()
        titleLabel.text = "Datos Generales"
        titleLabel.backgroundColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        return titleLabel
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
