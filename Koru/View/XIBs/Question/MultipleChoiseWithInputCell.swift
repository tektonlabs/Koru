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

protocol MultipleChoiseWithInputCellDelegate: class {
    func multipleChoiseWithInputCellDidTouchCheckBox(cell: MultipleChoiseWithInputCell)
    func multipleChoiseWithInputCellDidChangeText(cell: MultipleChoiseWithInputCell, changeText: String)
    func multipleChoiseWithInputCellDidTextChange(cell: MultipleChoiseWithInputCell)

}

class MultipleChoiseWithInputCell: UITableViewCell {
    @IBOutlet weak var checkBoxView: CheckboxControl!

    @IBOutlet weak var heightContraint: NSLayoutConstraint!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var separatorLine: UIView!
    weak var delegate: MultipleChoiseWithInputCellDelegate?
    var inputTextFont = UIFont()
    override func awakeFromNib() {
        super.awakeFromNib()
        styleUI()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 5, height: 5)).cgPath
        let rectShape = CAShapeLayer()
        rectShape.path = path
        self.layer.mask = rectShape
    }
    
    func styleUI() {
        backgroundColor = ColorPalette.purple
        checkBoxView.titleLabel.font = UIFont.systemFont(ofSize: 19)
        checkBoxView.backgroundColor = UIColor.clear
        checkBoxView.titleLabel.textColor = UIColor.white
        
        separatorLine.isHidden = true
        separatorLine.backgroundColor = UIColor.white
        inputTextView.isEditable = false
        inputTextView.backgroundColor = UIColor.clear
        inputTextView.textAlignment = .left
        inputTextFont = UIFont(name: "Roboto-Regular", size: 16)!
        inputTextView.font = inputTextFont
        inputTextView.attributedText = NSAttributedString(string: "Ingresa un comentario", attributes: [NSAttributedStringKey.foregroundColor : ColorPalette.placeholderColor, NSAttributedStringKey.font: inputTextFont.withSize(14)])
        inputTextView.autocapitalizationType = .none
        inputTextView.autocorrectionType = .no
        inputTextView.delegate = self
        
      
    }
    
    @IBAction func didTouchCheckBox(_ sender: CheckboxControl) {
        delegate?.multipleChoiseWithInputCellDidTouchCheckBox(cell: self)
    }

    
    func changeCanByEditing(completionHandler: (() -> Void)) {
        if inputTextView.isEditable {
            inputTextView.isEditable = false
            separatorLine.isHidden = true
            inputTextView.attributedText = NSAttributedString(string: "Ingresa un comentario", attributes: [NSAttributedStringKey.foregroundColor : ColorPalette.placeholderColor, NSAttributedStringKey.font: inputTextFont.withSize(14)])
            heightContraint.constant = 39
            completionHandler()
        } else {
            inputTextView.isEditable = true
            separatorLine.isHidden = false
        }
    }
}

extension MultipleChoiseWithInputCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let nsString = textView.text as NSString?
        let newString = nsString?.replacingCharacters(in: range, with: text)
        guard let string = newString else {
            return false
        }
        delegate?.multipleChoiseWithInputCellDidChangeText(cell: self, changeText: string)
        
        return true
    }
 
    func textViewDidChange(_ textView: UITextView) {
        
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        heightContraint.constant = newSize.height
        
       delegate?.multipleChoiseWithInputCellDidTextChange(cell: self)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Ingresa un comentario" {
            textView.text = ""
            inputTextView.textColor = UIColor.white
        } else {
            inputTextView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            inputTextView.attributedText = NSAttributedString(string: "Ingresa un comentario", attributes: [NSAttributedStringKey.foregroundColor : ColorPalette.placeholderColor, NSAttributedStringKey.font: inputTextFont])
        }
    }

    
   
}
