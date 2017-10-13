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

class TakeRegisterViewController: UIViewController {
    
    @IBOutlet weak var dniTextField: SATextField!
    @IBOutlet weak var cellphoneTextField: SATextField!
    @IBOutlet weak var institutionTextField: SATextField!
    @IBOutlet weak var nextButton: UIButton!
    
    let viewModel = TakeRegisterViewModel()
    fileprivate var tapGesture = UITapGestureRecognizer()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fillUI()
        addTapGesture()
        
        viewModel.didValidateDNI = { errorMessage in
            self.setDNIError(error: errorMessage)
        }
        
        viewModel.didValidateCellphone = { errorMessage in
            self.setCellphoneError(error: errorMessage)
        }
        
        viewModel.didValidateInstitution = { errorMessage in
            self.setInstitutionError(error: errorMessage)
        }
        
        viewModel.didConfirmateValidation = {
            self.showRefugeList()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup UI
    
    func setupUI() {
        self.dniTextField.delegate = self
        self.dniTextField.keyboardType = AppType.current.nationalPersonIDKeyboardType
        
        self.cellphoneTextField.delegate = self
        self.cellphoneTextField.keyboardType = .numberPad
        
        self.institutionTextField.delegate = self
        
        self.nextButton.addTarget(self, action: #selector(TakeRegisterViewController.didTapContinueButton), for: .touchUpInside)
    }
    
    func fillUI() {
        navigationItem.title = "Empadronar"
        
        nextButton.setTitle("Continuar", for: .normal)
        
        if let enumeratorUser = EnumeratorUserManager.sharedInstance.currentEnumeratorUser {
            dniTextField.text =  enumeratorUser.nationalPersonID
            cellphoneTextField.text = enumeratorUser.cellphone
            institutionTextField.text = enumeratorUser.institution
            dniTextField.placeholder = AppType.current.nationalPersonIDText
            cellphoneTextField.placeholder = "Celular"
            institutionTextField.placeholder = "Institución"
        } else{
            dniTextField.placeholder = AppType.current.nationalPersonIDText
            cellphoneTextField.placeholder = "Celular"
            institutionTextField.placeholder = "Institución"
        }
    }
    
    func showRefugeList() {
        setDNIError(error: nil)
        self.view.endEditing(true)
        let enumeratorUser = EnumeratorUser(nationalPersonID: dniTextField.text!, cellphone: cellphoneTextField.text!, institution: institutionTextField.text!)
        enumeratorUser.isActive = true
        
        EnumeratorUserManager.sharedInstance.currentEnumeratorUser = enumeratorUser
        
        EnumeratorUserManager.sharedInstance.saveUser()
    }

    // MARK: - TapGesture
    @objc func tapGesture(gesture: UITapGestureRecognizer) {
        
        dniTextField.resignFirstResponder()
    }
    
    func addTapGesture() {
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapContinueButton(){
        let dni = dniTextField.text ?? ""
        let cellphone = cellphoneTextField.text ?? ""
        let institution = institutionTextField.text ?? ""
    
        viewModel.validate(dni: dni, cellPhone: cellphone, institution: institution)
    }
    
    
    
    // MARK: - Error
    
    fileprivate func setDNIError(error: String?) {
        self.dniTextField.error = error
    }
    
    fileprivate func setCellphoneError(error: String?) {
        self.cellphoneTextField.error = error
    }
    
    fileprivate func setInstitutionError(error: String?) {
        self.institutionTextField.error = error
    }
}


extension TakeRegisterViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var reachMaxNumberOfCharacters = true
        var validMaxNumberOfCharacter = true
        
        let aSet = AppType.current.nationalPersonIDCharactersAllowed.inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let stringFiltered = compSepByCharInSet.joined(separator: "")
        
        if textField == dniTextField.textField || textField == cellphoneTextField.textField {
            let maxNumberOfCharacters = textField == dniTextField.textField ? AppType.current.nationalPersonIDMaxCharacters : 9
            guard let text = textField.text else { return false }
            let newLength = text.characters.count + string.characters.count - range.length
            reachMaxNumberOfCharacters = newLength == maxNumberOfCharacters
            validMaxNumberOfCharacter = newLength <= maxNumberOfCharacters
        }
        
        if reachMaxNumberOfCharacters {
            switch textField {
            case dniTextField.textField:
                dniTextField.error = nil
            case cellphoneTextField.textField:
                cellphoneTextField.error = nil
            case institutionTextField.textField:
                institutionTextField.error = nil
            default: break
                }
            }
        
        if (dniTextField.textField == textField || cellphoneTextField.textField == textField) {
            return validMaxNumberOfCharacter && string == stringFiltered
        } else {
            return validMaxNumberOfCharacter
        }
    }
}
