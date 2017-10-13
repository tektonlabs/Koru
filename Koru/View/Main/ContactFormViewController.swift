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
protocol ContactFormViewControllerDelegate: class {
    func dissmisContactFormViewController(contactFormViewController: ContactFormViewController, contact: Contact)
}

class ContactFormViewController: UIViewController {

    @IBOutlet weak var nameTextField: SATextField!
    @IBOutlet weak var cellPhoneTextField: SATextField!
    @IBOutlet weak var emailTextField: SATextField!
    
    @IBOutlet weak var addButton: UIButton!
    var viewModel: ContactFormViewModel = ContactFormViewModel()
    fileprivate var tapGesture = UITapGestureRecognizer()
    var contact: Contact?
    weak var delegate: ContactFormViewControllerDelegate?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fillUI()
        addTapGesture()
        
        if let contact = contact {
            addButton.setTitle("Editar", for: .normal)
            nameTextField.text = contact.firstName
            cellPhoneTextField.text = contact.phone
            emailTextField.text = contact.email
        }
        
        viewModel.didValidateName = { errorMessage in
            self.nameTextField.error = errorMessage
        }
        
        viewModel.didValidateCellphone = { errorMessage in
            self.cellPhoneTextField.error = errorMessage
        }
        
        viewModel.didValidateEmail = { errorMessage in
            self.emailTextField.error = errorMessage
        }

        viewModel.didConfirmateValidation = {
            self.addContact()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup UI
    
    func setupUI() {
        
        self.nameTextField.returnKeyType = .done
        self.nameTextField.delegate = self
        
        self.cellPhoneTextField.delegate = self
        self.cellPhoneTextField.keyboardType = .numberPad
        
        self.emailTextField.keyboardType = .emailAddress
        self.emailTextField.returnKeyType = .done
        self.emailTextField.delegate = self
        
        
        self.addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
    }
    
    func fillUI() {
        addButton.setTitle("Agregar", for: .normal)
        addButton.layer.cornerRadius = 2
        addButton.backgroundColor = ColorPalette.ultraLightGray
        addButton.setTitleColor(ColorPalette.darkGray, for: .normal)
        addButton.layer.masksToBounds = false
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOpacity = 0.5
        addButton.layer.shadowOffset = CGSize(width: -1, height: 1)
        addButton.layer.shadowRadius = 1

        nameTextField.placeholder = "Nombre"
        cellPhoneTextField.placeholder = "Celular"
        emailTextField.placeholder = "Email"
    }
    
    func addContact() {
        let name = nameTextField.text ?? ""
        let cellphone = cellPhoneTextField.text ?? ""
        let email = emailTextField.text ?? ""
        contact = Contact(firstName: name, phone: cellphone, email: email)
        delegate?.dissmisContactFormViewController(contactFormViewController: self, contact: contact!)
    }

    
    // MARK: - TapGesture
    @objc func tapGesture(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func addTapGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapAddButton(){
        let name = nameTextField.text ?? ""
        let cellphone = cellPhoneTextField.text ?? ""
        let email = emailTextField.text ?? ""
        
        viewModel.validate(name: name, cellPhone: cellphone, email: email)
    }
    
    
    
    // MARK: - Error
    
    fileprivate func setNameError(error: String?) {
        self.nameTextField.error = error
    }
    
    fileprivate func setCellphoneError(error: String?) {
        self.cellPhoneTextField.error = error
    }
    
    fileprivate func setEmailError(error: String?) {
        self.emailTextField.error = error
    }
}


extension ContactFormViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.keyboardType == .numberPad {
            let aSet = CharacterSet.decimalDigits.inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            
            if textField == cellPhoneTextField.textField {
                let maxNumberOfCharacters = 9
                guard let text = textField.text else { return false }
                let newLength = text.characters.count + string.characters.count - range.length
                if newLength == maxNumberOfCharacters {
                    cellPhoneTextField.error = nil
                }
                
                return (newLength <= maxNumberOfCharacters) && (string == numberFiltered)
            } else {
                return string == numberFiltered
            }
        } else {
            switch textField {
            case emailTextField.textField:
                if let text = emailTextField.text, text.isValidEmail {
                    emailTextField.error = nil
                }
            case nameTextField.textField:
                nameTextField.error = nil
            default:
                break
            }
            return true
        }
        
        
    }
}


