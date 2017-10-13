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
protocol OneChoiseSubQuestionCellDelegate: class {
    func oneChoiseSubQuestionCellDidTouchOptionOneRadioButton(cell: OneChoiseSubQuestionCell)
    func oneChoiseSubQuestionCellDidTouchOptionTwoRadioButton(cell: OneChoiseSubQuestionCell)
    func oneChoiseSubQuestionCellDidTouchOptionThreeRadioButton(cell: OneChoiseSubQuestionCell)

}
class OneChoiseSubQuestionCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var oneOptionRadioButton: RadioButtonControl!
    
    @IBOutlet weak var threeOptionRadioButton: RadioButtonControl!
    @IBOutlet weak var twoOptionRadioButton: RadioButtonControl!
    
    @IBOutlet weak var oneOptionLabel: UILabel!
    @IBOutlet weak var twoOptionLabel: UILabel!
    @IBOutlet weak var threeOptionLabel: UILabel!
    
    weak var delegate: OneChoiseSubQuestionCellDelegate?
    
    
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
        
        oneOptionRadioButton.backgroundColor = UIColor.clear
        oneOptionRadioButton.layer.borderWidth = 3
        oneOptionRadioButton.layer.borderColor = UIColor.white.cgColor
        oneOptionRadioButton.layer.cornerRadius  = CGFloat(roundf(Float(self.oneOptionRadioButton.frame.size.width/2.0)))
     
        twoOptionRadioButton.backgroundColor = UIColor.clear
        twoOptionRadioButton.layer.borderWidth = 3
        twoOptionRadioButton.layer.borderColor = UIColor.white.cgColor
        twoOptionRadioButton.layer.cornerRadius  = CGFloat(roundf(Float(self.twoOptionRadioButton.frame.size.width/2.0)))
        
        threeOptionRadioButton.backgroundColor = UIColor.clear
        threeOptionRadioButton.layer.borderWidth = 3
        threeOptionRadioButton.layer.borderColor = UIColor.white.cgColor
        threeOptionRadioButton.layer.cornerRadius  = CGFloat(roundf(Float(self.threeOptionRadioButton.frame.size.width/2.0)))
        
        oneOptionLabel.font = UIFont.systemFont(ofSize: 19)
        oneOptionLabel.textColor = UIColor.white
        twoOptionLabel.font = UIFont.systemFont(ofSize: 19)
        twoOptionLabel.textColor = UIColor.white
        threeOptionLabel.font = UIFont.systemFont(ofSize: 19)
        threeOptionLabel.textColor = UIColor.white
        
    }
    @IBAction func didTouchOptionOneRadioButton(_ sender: RadioButtonControl) {
        delegate?.oneChoiseSubQuestionCellDidTouchOptionOneRadioButton(cell: self)
    }
    
    @IBAction func didTouchOptionTwoRadioButton(_ sender: RadioButtonControl) {
        delegate?.oneChoiseSubQuestionCellDidTouchOptionTwoRadioButton(cell: self)
    }
    
    @IBAction func didTouchOptionThreeRadioButton(_ sender: RadioButtonControl) {
        delegate?.oneChoiseSubQuestionCellDidTouchOptionThreeRadioButton(cell: self)
    }
    
}
