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
protocol AddContactCellDelegate: class {
    func didTouchAddButton(cell: AddContactCell)
}
class AddContactCell: UITableViewCell {

    @IBOutlet weak var addButton: UIButton!
    var viewModel: AddContactCellViewModel?
    weak var delegate: AddContactCellDelegate?
    var title: String = "" {
        didSet {
            addButton.setTitle(title, for: .normal)
        }
    }
    
    var colorTitle: UIColor =  UIColor.black {
        didSet {
            addButton.setTitleColor(colorTitle, for: .normal)
        }
    }
    
    var backbraoundColorButton: UIColor = UIColor.gray {
        didSet {
            addButton.backgroundColor = backbraoundColorButton
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        styleUI()
    }
    
    func styleUI() {
        
        addButton.layer.cornerRadius = 2
        addButton.layer.masksToBounds = false
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOpacity = 0.5
        addButton.layer.shadowOffset = CGSize(width: -1, height: 1)
        addButton.layer.shadowRadius = 1
        addButton.titleLabel!.font =  UIFont(name: "Roboto-Bold", size: 14)
        addButton.titleLabel?.adjustsFontSizeToFitWidth = true
        addButton.titleEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20)

    } 
    
    @IBAction func didTouchAddButton(_ sender: Any) {
        delegate?.didTouchAddButton(cell: self)
    }
  
}
