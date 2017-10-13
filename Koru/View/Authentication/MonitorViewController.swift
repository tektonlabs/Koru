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

class MonitorViewController: UIViewController {

  
    @IBOutlet weak var dniTextField: SATextField!
    @IBOutlet weak var continueButton: UIButton!
   
    let viewModel = MonitorViewModel()
    var tapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleUI()
        fillUI()
        addTapGesture()
        
        viewModel.invalidateCharactersCount = { [weak self] in
            self?.showErrorCharacterCount()
        }
        
        viewModel.invalidateRequiredField = { [weak self] in
            self?.showErrorRequiredField()
        }

        viewModel.didConfirmateValidation = {[weak self] in
            self?.showRefugeList()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    func styleUI() {
        dniTextField.textField.delegate = self
        dniTextField.textField.keyboardType = AppType.current.nationalPersonIDKeyboardType
        continueButton.layer.cornerRadius = 2
        continueButton.backgroundColor = ColorPalette.blueButton
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.layer.masksToBounds = false
        continueButton.layer.shadowColor = UIColor.black.cgColor
        continueButton.layer.shadowOpacity = 0.5
        continueButton.layer.shadowOffset = CGSize(width: -1, height: 1)
        continueButton.layer.shadowRadius = 1
        continueButton.addTarget(self, action: #selector(didTouchContinueButton), for: .touchUpInside)
    }
    
    func fillUI() {
        navigationItem.title = "Monitorear"
        
        continueButton.setTitle("Continuar", for: .normal)
        
        if UserManager.sharedInstance.hasCurrentUser {
            dniTextField.text = UserManager.sharedInstance.currentUser?.nationalPersonID
            dniTextField.placeholder = AppType.current.nationalPersonIDText

        } else {
            dniTextField.placeholder = AppType.current.nationalPersonIDText
        }
    }
    
    
    func showRefugeList() {
        dniTextField.error = ""
        dniTextField.resignFirstResponder()
        let user = User(nationalPersonID: dniTextField.text!)
        UserManager.sharedInstance.currentUser = user
        UserManager.sharedInstance.saveUser()
    } 
    
    
    // Mark: Validation
    @objc func didTouchContinueButton(){
        
        guard let text = dniTextField.text  else {
            return
        }
        
        viewModel.validate(text: text)
    }
    
    func showErrorCharacterCount() {
        dniTextField.error = "Ingresa un número de \(AppType.current.nationalPersonIDMaxCharacters) caracteres"
    }
    
    func showErrorRequiredField() {
        dniTextField.error = "Este es un campo requerido"
    }
    
    // Mark: TapGesture
    @objc func tapGesture(gesture: UITapGestureRecognizer) {
        
       dniTextField.resignFirstResponder()
    }
    
    func addTapGesture() {
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
}

extension MonitorViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = AppType.current.nationalPersonIDCharactersAllowed.inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let stringFiltered = compSepByCharInSet.joined(separator: "")
        let maxCharactersLength = AppType.current.nationalPersonIDMaxCharacters
        
        guard let text = textField.text else { return false }
        let newLength = text.characters.count + string.characters.count - range.length
        
        if newLength == maxCharactersLength  {
            self.dniTextField.error = nil
        }
        
        return newLength <= maxCharactersLength && string == stringFiltered
    } 
}
