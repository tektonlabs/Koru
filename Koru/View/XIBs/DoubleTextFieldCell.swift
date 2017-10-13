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

class DoubleTextFieldCell: UITableViewCell {
    @IBOutlet weak var firstTextField: SATextField!
    @IBOutlet weak var secondTextField: SATextField!
    var viewModel: DoubleTextFieldCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        firstTextField.delegate = self
        secondTextField.delegate = self
        firstTextField.keyboardType = .numberPad
        secondTextField.keyboardType = .numberPad
        firstTextField.didTextChanged = { [weak self] in
            self?.viewModel?.firstText = self?.firstTextField.text
        }
        
        secondTextField.didTextChanged = { [weak self] in
            self?.viewModel?.secondText = self?.secondTextField.text
        }
    }
}

extension DoubleTextFieldCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = CharacterSet.decimalDigits.inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
    
        let maxNumberOfCharacters = 4
        guard let text = textField.text else { return false }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= maxNumberOfCharacters && string == numberFiltered
       
    }

}
