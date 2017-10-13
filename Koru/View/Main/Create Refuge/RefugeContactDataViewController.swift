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

class RefugeContactDataViewController: UIViewController {

    var viewModel: RefugeContactDataViewModel!
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(tableView)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        configureViewModelBinding()
    }
    
    //Mark: Action binding
    func configureViewModelBinding() {
        viewModel.didUpdateData = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.didFailValidation = { [weak self] in
            self?.showAlert(with: "Por favor agregue al menos un contacto principal para continuar")
        }
    }
    
    func setupTableView() {
        
        let addContactNib = UINib(nibName: "AddContactCell" , bundle: nil)
        tableView.register(addContactNib, forCellReuseIdentifier:  "addContactCell")
        
        let contactNib = UINib(nibName: "ContactCell" , bundle: nil)
        tableView.register(contactNib, forCellReuseIdentifier:  "contactCell")

        
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    }
}

extension RefugeContactDataViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
       return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = viewModel.sections[section]
        switch section {
        case .principalContact:
            return viewModel.cellForPrincipalContactSection.count
        case .secondaryContact:
            return viewModel.cellForSegundaryContactSection.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .principalContact:
            let cellType = viewModel.cellForPrincipalContactSection[indexPath.row]
            switch cellType {
            case .addContactCell(let viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as! AddContactCell
                cell.title = viewModel.title!
                cell.colorTitle = viewModel.colorTitleButton!
                cell.backbraoundColorButton = viewModel.colorButton!
                cell.delegate = self
                return cell
            case .contactCell(let cellViewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as! ContactCell
                cell.delegate = self
                let contact = viewModel.contactPrincipal[indexPath.row]
                cell.colorLabel = cellViewModel.colorLabel!
                cell.backgroundViewContainer = cellViewModel.backgroundColorContainerView!
                cell.colorNameLabel = cellViewModel.colorNameLabel!
                cell.imageDeleteButton = cellViewModel.deleteImage!
                cell.nameLabel.text = contact.firstName
                cell.emailLabel.text = contact.email
                cell.phoneNumberLabel.text = contact.phone
                
                return cell
            }
        case .secondaryContact:
            let cellType = viewModel.cellForSegundaryContactSection[indexPath.row]
            switch cellType {
            case .addContactCell(let viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as! AddContactCell
                cell.title = viewModel.title!
                cell.colorTitle = viewModel.colorTitleButton!
                cell.backbraoundColorButton = viewModel.colorButton!
                cell.delegate = self
                return cell
            case .contactCell(let cellViewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as! ContactCell
                cell.delegate = self
                let contact = viewModel.contactSegundary[indexPath.row]
                cell.colorLabel = cellViewModel.colorLabel!
                cell.backgroundViewContainer = cellViewModel.backgroundColorContainerView!
                cell.colorNameLabel = cellViewModel.colorNameLabel!
                cell.imageDeleteButton = cellViewModel.deleteImage!
                cell.nameLabel.text = contact.firstName
                cell.emailLabel.text = contact.email
                cell.phoneNumberLabel.text = contact.phone
                return cell
            }
        }
        
    }
}

extension RefugeContactDataViewController: UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .principalContact:
            let cellType = viewModel.cellForPrincipalContactSection[indexPath.row]
            switch cellType {
            case .addContactCell:
                return
            case .contactCell:
                let contact = self.viewModel.contactPrincipal[indexPath.row]
                self.viewModel.selectContactIndexPath = indexPath
                let contactFormViewModel = ContactFormViewModel()
                contactFormViewModel.contactType = .principal
                self.showContactViewController(with: contact, title: sectionType.title, contactType: .principal, isEditing: true)
            }
            
        case .secondaryContact:
            let cellType = viewModel.cellForSegundaryContactSection[indexPath.row]
            switch cellType {
            case .addContactCell:
                return
            case .contactCell:
                let contact = self.viewModel.contactSegundary[indexPath.row]
                self.viewModel.selectContactIndexPath = indexPath
                let contactFormViewModel = ContactFormViewModel()
                contactFormViewModel.contactType = .secondary
                self.showContactViewController(with: contact, title: sectionType.title, contactType: .secondary, isEditing: true)
            }
        }
    }
}

extension RefugeContactDataViewController: AddContactCellDelegate {
    func didTouchAddButton(cell: AddContactCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let section = viewModel.sections[indexPath.section]
            switch section {
            case .principalContact:
                showContactViewController(with: nil, title: section.title, contactType: .principal, isEditing: false)
            case .secondaryContact:
                showContactViewController(with: nil, title: section.title, contactType: .secondary, isEditing:  false)
            }
            
        }
    }
    
    func showContactViewController( with contact: Contact?, title: String, contactType: ContactType, isEditing: Bool) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let contactFormViewController = storyBoard.instantiateViewController(withIdentifier: "contactViewController") as! ContactFormViewController
        
        contactFormViewController.contact = contact
        contactFormViewController.navigationItem.title = title
        contactFormViewController.viewModel.contactType = contactType
        contactFormViewController.viewModel.isEditing = isEditing
        contactFormViewController.delegate = self
        
        if let navigationController = self.navigationController {
            navigationController.pushViewController(contactFormViewController, animated: true)
        } else if let navigationController = self.parent?.navigationController {
            navigationController.pushViewController(contactFormViewController, animated: true)
        } else {
            self.show(contactFormViewController, sender: self)
        }
    }
}

extension RefugeContactDataViewController: ContactCellDelegate {
    func deleteContact(cell: ContactCell) {
        let indexPath = tableView.indexPath(for: cell)
        let section = viewModel.sections[indexPath!.section]

        viewModel.deleteContact(sectionType: section, indexPath: indexPath!)
    }
}

extension RefugeContactDataViewController: ContactFormViewControllerDelegate {
    func dissmisContactFormViewController(contactFormViewController: ContactFormViewController, contact: Contact) {
        let contactViewModel = contactFormViewController.viewModel
        viewModel.addContact(contactType: contactViewModel.contactType, contact: contact, isEditing: contactViewModel.isEditing)
        navigationController!.popViewController(animated: true)
    }
}
