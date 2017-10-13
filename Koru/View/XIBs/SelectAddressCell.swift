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

class SelectAddressCell: UITableViewCell {

    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var placeholderTitleLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var disclosureImageView: UIImageView!
    
    var placeholder: String = "" {
        didSet {
            optionLabel.text = placeholder
            optionLabel.textColor = ColorPalette.separatorViewColor
        }
    }
    
    var address: String = "" {
        didSet {
            placeholderTitleLabel.alpha = 1
            placeholderTitleLabel.text = placeholder
            optionLabel.text = address
            optionLabel.textColor = UIColor.black
            self.layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.placeholderTitleLabel.alpha = 0
    }
    
}
