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
protocol OneChoiseQuestionCellDelegate: class {
    func didTouchOptionYesRadioButton(cell: OneChoiseQuestionCell)
    func didTouchOptionNoRadioButton(cell: OneChoiseQuestionCell)
}
class OneChoiseQuestionCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var optionYesRadioButton: RadioButtonControl!
    
    @IBOutlet weak var optionNoLabel: UILabel!
    @IBOutlet weak var optionYesLabel: UILabel!
    @IBOutlet weak var optionNoRadioButton: RadioButtonControl!
    weak var delegate: OneChoiseQuestionCellDelegate?
    
    var isLastCell : Bool = false
    
    override func draw(_ rect: CGRect) {
        if isLastCell {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 5, height: 5)).cgPath
            let rectShape = CAShapeLayer()
            rectShape.path = path
            self.layer.mask = rectShape
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        styleUI()
    }
    
    func styleUI() {
        self.backgroundColor = ColorPalette.purple
        questionLabel.font = UIFont.systemFont(ofSize: 17)
        questionLabel.textColor = UIColor.white
        
        
        self.backgroundColor = ColorPalette.purple
        optionYesLabel.font = UIFont.systemFont(ofSize: 19)
        optionYesLabel.textColor = UIColor.white
        optionYesRadioButton.backgroundColor = UIColor.clear
        optionYesRadioButton.layer.borderWidth = 3
        optionYesRadioButton.layer.borderColor = UIColor.white.cgColor
        optionYesRadioButton.layer.cornerRadius  = CGFloat(roundf(Float(self.optionYesRadioButton.frame.size.width/2.0)))
        

        optionNoLabel.font = UIFont.systemFont(ofSize: 19)
        optionNoLabel.textColor = UIColor.white
        optionNoRadioButton.backgroundColor = UIColor.clear
        optionNoRadioButton.layer.borderWidth = 3
        optionNoRadioButton.layer.borderColor = UIColor.white.cgColor
        optionNoRadioButton.layer.cornerRadius  = CGFloat(roundf(Float(self.optionYesRadioButton.frame.size.width/2.0)))

        self.layer.cornerRadius = 5
    }

    @IBAction func didTouchOptionYesRadioButton(_ sender: RadioButtonControl) {
        delegate?.didTouchOptionYesRadioButton(cell: self)
    }
    
    @IBAction func didTouchOptionNoRadioButton(_ sender: RadioButtonControl) {
        delegate?.didTouchOptionNoRadioButton(cell: self)
    }
}
