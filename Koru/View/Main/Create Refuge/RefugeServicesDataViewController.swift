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

class RefugeServicesDataViewController: UIViewController {
    
    var viewModel: RefugeServicesDataViewModel?
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight  = 60
        tableView.rowHeight  = UITableViewAutomaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(tableView)
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableViewLayout()
        
        self.viewModel?.didFinisihLoading = { [weak self] in
            guard let section = self?.viewModel?.sections.index(of: .send) else {
                return
            }
            
            let indexPath = IndexPath(row: 0, section: section)
            
            guard let cell = self?.tableView.cellForRow(at: indexPath) as? SendButtonCell else {
                return
            }
            cell.sendButton.loading = false
        }
    }
    
    func configureTableViewLayout() {
        
        let multipleChoiceCellNib = UINib(nibName: "MultipleChoiceCell", bundle: nil)
        tableView.register(multipleChoiceCellNib, forCellReuseIdentifier: "multipleChoiceCell")
        
        let sendButtonCellNib = UINib(nibName: "SendButtonCell", bundle: nil)
        tableView.register(sendButtonCellNib, forCellReuseIdentifier: "sendButtonCell")
        
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    }
}

extension RefugeServicesDataViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        
        let sectionType = viewModel.sections[section]
        
        if let numberOfRows = viewModel.checkboxesViewModels(for: sectionType)?.count {
            return numberOfRows
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard  let viewModel = viewModel else {
            return UITableViewCell()
        }
        
        let sectionType = viewModel.sections[indexPath.section]
        
        if let checkboxesViewModel = viewModel.checkboxesViewModels(for: sectionType) {
            let cellViewmodel = checkboxesViewModel[indexPath.row]
            
            let checkboxCell = tableView.dequeueReusableCell(withIdentifier: "multipleChoiceCell", for: indexPath) as! MultipleChoiceCell
            checkboxCell.delegate = self
            checkboxCell.checkboxControl.titleLabel.text = cellViewmodel.multipleChoice.name
            checkboxCell.checkboxControl.isSelected = cellViewmodel.selected
            return checkboxCell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sendButtonCell", for: indexPath) as! SendButtonCell
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let section = viewModel?.sections[section] {
            switch section {
            case .send:
                return nil
            default:
                let titleLabel = UILabel()
                titleLabel.text = section.title
                titleLabel.backgroundColor = UIColor.white
                titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
                return titleLabel
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let section = viewModel?.sections[section] {
            switch section {
            case .send:
                return 0
            default:
                return 50
            }
        }
        return 0
    }
}

extension RefugeServicesDataViewController: MultipleChoiceCellDelegate {
    func multipleChoiceCell(_ cell: MultipleChoiceCell, didSelectCheckbox selected: Bool) {
        
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        
        let sectionType = viewModel?.sections[indexPath.section]
        
        if let checkboxesViewModel = viewModel?.checkboxesViewModels(for: sectionType!) {
            let cellViewmodel = checkboxesViewModel[indexPath.row]
            cellViewmodel.selected = selected
        }
    }
}

extension RefugeServicesDataViewController: SendButtonCellDelegate {
    func sendButtonCell(cell: SendButtonCell, didTapSendButton button: LoadingButton) {
        self.viewModel?.didTapSend?()
    }
}
