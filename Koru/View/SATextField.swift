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
import JVFloatLabeledTextField

class SATextField: UIControl {
    
    var textField: JVFloatLabeledTextField!
    fileprivate var separatorLine: SeparatorView!
    fileprivate var errorLabel: UILabel!
    
    var text: String? {
        get {
           return self.textField.text
        } set {
            self.textField.text = newValue
        }
    }
    
    var placeholder: String = "" {
        didSet {
            self.textField.placeholder = placeholder
        }
    }
    
    var error: String? {
        didSet {
            UIView.transition(with: self.errorLabel, duration: 0.25, options: .transitionCrossDissolve, animations: { 
                self.errorLabel.text = self.error
            }, completion: nil)
        }
    }
    
    var returnKeyType: UIReturnKeyType = .default {
        didSet {
            self.textField.returnKeyType = returnKeyType
        }
    }
    
    weak var delegate: UITextFieldDelegate? {
        didSet {
            self.textField.delegate = delegate
        }
    }
    
    var keyboardType: UIKeyboardType = .default {
        didSet {
            self.textField.keyboardType = keyboardType
        }
    }
    
    var didTextChanged: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    fileprivate func setupViews() {
        setupTextField()
        setupSeparatorLine()
        setupErrorLabel()
    }
    
    fileprivate func setupTextField() {
        self.textField = JVFloatLabeledTextField()
        self.textField.placeholderColor = ColorPalette.separatorViewColor
        self.textField.floatingLabelActiveTextColor = ColorPalette.borderRose
        self.textField.floatingLabelTextColor = ColorPalette.separatorViewColor
        self.textField.placeholder = placeholder
        self.textField.keyboardType = keyboardType
        self.textField.borderStyle = .none
        self.textField.font = UIFont.systemFont(ofSize: 16)
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.addTarget(self, action: #selector(SATextField.didTextfieldValueChanged), for: .allEditingEvents)
        self.textField.addTarget(self, action: #selector(SATextField.textFieldEditingDidBegin), for: .editingDidBegin)
        self.textField.addTarget(self, action: #selector(SATextField.textFieldEditingDidEnd), for: [.editingDidEnd, .editingDidEndOnExit])
        
        
        self.addSubview(textField)
        
        self.textField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        self.textField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        self.textField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        self.textField.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
    }
    
    fileprivate func setupSeparatorLine() {
        self.separatorLine = SeparatorView()
        self.separatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(separatorLine)
        
        self.separatorLine.topAnchor.constraint(equalTo: textField.bottomAnchor).isActive = true
        self.separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        self.separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        self.separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    fileprivate func setupErrorLabel() {
        self.errorLabel = UILabel()
        self.errorLabel.font = UIFont.systemFont(ofSize: 14)
        self.errorLabel.textAlignment = .left
        self.errorLabel.textColor = UIColor.red
        self.errorLabel.numberOfLines = 0
        self.errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(errorLabel)
        
        self.errorLabel.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 4).isActive = true
        self.errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        self.errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        self.errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        self.errorLabel.heightAnchor.constraint(equalToConstant: 17).isActive = true
    }
    
    @objc
    fileprivate func didTextfieldValueChanged() {
        self.didTextChanged?()
    }
    
    @objc
    fileprivate func textFieldEditingDidBegin() {
        self.separatorLine.backgroundColor = ColorPalette.borderRose
    }
    
    @objc
    fileprivate func textFieldEditingDidEnd() {
        self.separatorLine.backgroundColor = ColorPalette.separatorViewColor
    }
    
    


}
