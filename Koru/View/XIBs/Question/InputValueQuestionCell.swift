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
protocol InputValueQuestionCellDelegate: class {
    func inputValueQuestionCellDidChangeText(cell: InputValueQuestionCell, changeText: String)
    func inputValueQuestionCellTextDidChange(cell: InputValueQuestionCell)
}
class InputValueQuestionCell: UITableViewCell {
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var separatorLineView: UIView!
    weak var delegate: InputValueQuestionCellDelegate?
    var line = 24
    var answerFont = UIFont()
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        styleUI()
    }

    
    func styleUI() {
        self.backgroundColor = ColorPalette.purple
        questionLabel.font = UIFont.systemFont(ofSize: 17)
        questionLabel.textColor = UIColor.white
        
        answerTextView.backgroundColor = UIColor.clear
        answerTextView.textAlignment = .left
        answerFont = UIFont.systemFont(ofSize: 19)
        answerTextView.font = answerFont
        answerTextView.attributedText = NSAttributedString(string: "Ingresa un comentario", attributes: [NSAttributedStringKey.foregroundColor : ColorPalette.placeholderColor, NSAttributedStringKey.font: answerFont])
        answerTextView.delegate = self
        answerTextView.autocapitalizationType = .none
        answerTextView.autocorrectionType = .no

        self.layer.cornerRadius = 5

    }
}

extension InputValueQuestionCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let nsString = textView.text as NSString?
        let newString = nsString?.replacingCharacters(in: range, with: text)
        
        guard let string = newString else {
            return false
        }
        delegate?.inputValueQuestionCellDidChangeText(cell: self, changeText: string)
        
        return true

    }
    
    func textViewDidChange(_ textView: UITextView) {

        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        heightConstraint.constant = newSize.height
        
        delegate?.inputValueQuestionCellTextDidChange(cell: self)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Ingresa un comentario" {
            textView.text = ""
            answerTextView.textColor = UIColor.white
        } else {
            answerTextView.textColor = UIColor.white
        }
    }

    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
             answerTextView.attributedText = NSAttributedString(string: "Ingresa un comentario", attributes: [NSAttributedStringKey.foregroundColor : ColorPalette.placeholderColor, NSAttributedStringKey.font: answerFont])
        }
    }
}
