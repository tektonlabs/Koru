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

protocol OneChoiseThreeOptionCellDelegate: class {
    func oneChoiseThreeOptionCellDidTouchOptionOneRadioButton(cell: OneChoiseThreeOptionCell)
    func oneChoiseThreeOptionCellDidTouchOptionTwoRadioButton(cell: OneChoiseThreeOptionCell)
    func oneChoiseThreeOptionCellDidTouchOptionThreeRadioButton(cell: OneChoiseThreeOptionCell)

}
class OneChoiseThreeOptionCell: UITableViewCell {

    @IBOutlet weak var oneOptionRadioButton: RadioButtonControl!
    
    @IBOutlet weak var twoOptionRadioButton: RadioButtonControl!
    
    @IBOutlet weak var threeOptionRadioButton: RadioButtonControl!
    
    @IBOutlet weak var oneOptionLabel: UILabel!
    @IBOutlet weak var twoOptionLabel: UILabel!
    @IBOutlet weak var threeOptionLabel: UILabel!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    weak var delegate: OneChoiseThreeOptionCellDelegate?
    
    
    
    
    
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

        self.layer.cornerRadius = 5
    }

    @IBAction func didTouchOneOptionRadioButton(_ sender: RadioButtonControl) {
        delegate?.oneChoiseThreeOptionCellDidTouchOptionOneRadioButton(cell: self)
    }
    @IBAction func didTouchTwoOptionRadioButton(_ sender: RadioButtonControl) {
        delegate?.oneChoiseThreeOptionCellDidTouchOptionTwoRadioButton(cell: self)
    }
   
    @IBAction func didTouchThreeOptionRadioButton(_ sender: RadioButtonControl) {
        delegate?.oneChoiseThreeOptionCellDidTouchOptionThreeRadioButton(cell: self)
    }
   
}
