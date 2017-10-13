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

class TextFieldCell: UITableViewCell {
    
    @IBOutlet weak var textField: SATextField!
    var viewModel: TextFieldCellViewModel?
    var maxNumberOfCharacters: Int?

    override func awakeFromNib() {
        super.awakeFromNib()
        textField.returnKeyType = .done
        textField.delegate = self
        textField.didTextChanged = {
            self.viewModel?.text = self.textField.text
            
            if let text = self.textField.text, text.characters.count > 0 {
                self.viewModel?.error = nil
            }
            
        }
    }
}

extension TextFieldCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var validNumberOfCharacters = true
        var validStringForKeyboardType = true
        var reachMaxNumberOCharacters = true
        
        if let maxNumberOfCharacters = maxNumberOfCharacters {
            guard let text = textField.text else { return false }
            let newLength = text.characters.count + string.characters.count - range.length
            
            validNumberOfCharacters = newLength <= maxNumberOfCharacters
            reachMaxNumberOCharacters = (newLength == maxNumberOfCharacters)
        }
        
        
        if textField.keyboardType == .numberPad {
            let aSet = CharacterSet.decimalDigits.inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            
            validStringForKeyboardType = (string == numberFiltered)
        }
        
        if reachMaxNumberOCharacters {
            self.textField.error = nil
            self.viewModel?.error = nil
        }
        
        
        return validNumberOfCharacters && validStringForKeyboardType
    }
}
