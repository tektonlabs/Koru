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

class RefugeAdditionalDataViewController: UIViewController {
    
    var viewModel: RefugeAdditionalDataViewModel!
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight  = 40
        tableView.rowHeight  = UITableViewAutomaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(tableView)
        
        return tableView
    }()
    
    fileprivate var selectedIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableViewLayout()
        configureViewModelBinding()
    }
    
    func configureTableViewLayout() {
        
        let dropdownFieldNib = UINib(nibName: "DropdownCell", bundle: nil)
        tableView.register(dropdownFieldNib, forCellReuseIdentifier: "dropdownCell")
        
        let addSearchResultNib = UINib(nibName: "AddSearchResultCell", bundle: nil)
        tableView.register(addSearchResultNib, forCellReuseIdentifier: "addSearchResultCell")
        
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    }
    
    func configureViewModelBinding() {
        viewModel.didSelectOption = { [weak self] (option: OptionItem) in
            if let selectedIndexPath = self?.selectedIndexPath, let cell = self?.tableView.cellForRow(at: selectedIndexPath) as? DropdownCell {
                cell.option = option.displayValue
                cell.errorLabel.text = ""
            }
        }
        
        viewModel.didFailValidation = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.didSelectSearchResult = { [weak self] (result: SearchResult) in
            if let selectedIndexPath = self?.selectedIndexPath, let cell = self?.tableView.cellForRow(at: selectedIndexPath) as? AddSearchResultCell {
                cell.result = result.title
                cell.errorLabel.text = ""
            }
        }
    }
}

extension RefugeAdditionalDataViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = viewModel.sections[section]
        return viewModel.cellTypes(for: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.sections[indexPath.section]
        let cellTypes = viewModel.cellTypes(for: section)
        let type = cellTypes[indexPath.row]
        
        switch type {
        case .dropDownCell(let viewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as! DropdownCell
            
            cell.selectionStyle = .none
            cell.placeholder = viewModel.placeholder
            cell.errorLabel.text = viewModel.error
            
            if let option = viewModel.selectedOption {
                cell.option = option.displayValue
            }
            return cell
        case .addSearchResult(let viewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as! AddSearchResultCell
            cell.selectionStyle = .none
            cell.result = viewModel.result?.title
            cell.errorLabel.text = viewModel.error
            if self.viewModel.refugeCommitteesViewModels.count == 5 {
                cell.showAddButton = false
            } else {
                cell.showAddButton = (cellTypes.endIndex-1 == indexPath.row)
            }
            
            cell.delegate = self
            
            return cell
        }
    }
}

extension RefugeAdditionalDataViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        
        let section = viewModel.sections[indexPath.section]
        let cellTypes = viewModel.cellTypes(for: section)
        let type = cellTypes[indexPath.row]
        switch type {
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
        case .addSearchResult(let viewModel):
            let searchViewController = SearchCommitteeViewController()
            searchViewController.viewModel = viewModel
            searchViewController.delegate = self
            
            if let navigationController = self.navigationController {
                navigationController.pushViewController(searchViewController, animated: true)
            } else if let navigationController = self.parent?.navigationController {
                navigationController.pushViewController(searchViewController, animated: true)
            } else {
                self.show(searchViewController, sender: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = viewModel.sections[section]
        
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

extension RefugeAdditionalDataViewController: AddSearchResultCellDelegate {
    func addSearchResultCell(didTapAddButton cell: AddSearchResultCell) {
        
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        
        if viewModel.addNewRefugeCommittee() {
            let newIndexPath = IndexPath(item: indexPath.row+1, section: indexPath.section)
            
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            if let cell = tableView.cellForRow(at: indexPath) as? AddSearchResultCell {
                cell.showAddButton = false
            }
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)

        }

    }
    
    func addSearchResultCell(didTapDeleteButton cell: AddSearchResultCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        
        viewModel.removeRefugeCommittee(at: indexPath.row)
        
        let newIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)

        tableView.deleteRows(at: [indexPath], with: .automatic)
        if indexPath.row == 4 {
            if let cell = tableView.cellForRow(at: newIndexPath) as? AddSearchResultCell {
                cell.showAddButton = true
            }
        }
        if  indexPath.row > 0 {
            tableView.scrollToRow(at: newIndexPath, at: .top, animated: true)
        }
        
        if indexPath.row == 0 {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }

    }
}

extension RefugeAdditionalDataViewController: SearchCommitteeViewControllerDelegate {
    func didSelectOption(viewContronller: SearchCommitteeViewController) {
       self.viewModel.addNewResult(searchResult: (viewContronller.viewModel?.result)!)
        navigationController!.popViewController(animated: true)
    }
}
