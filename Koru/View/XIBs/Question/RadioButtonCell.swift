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

class RadioButtonCell: UITableViewCell {

    @IBOutlet var radioButtonView: RadioButtonControl!
   
    @IBOutlet var titleLabel: UILabel!
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                radioButtonView.isSelected = true
                
            } else {
                radioButtonView.isSelected = false
            }
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        styleUI()
    }

    func styleUI() {
        
        self.backgroundColor = ColorPalette.purple
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textColor = UIColor.white
        radioButtonView.backgroundColor = UIColor.clear
        radioButtonView.layer.borderWidth = 3
        radioButtonView.layer.borderColor = UIColor.white.cgColor
        radioButtonView.layer.cornerRadius  = CGFloat(roundf(Float(self.radioButtonView.frame.size.width/2.0)))
    }
    
}
