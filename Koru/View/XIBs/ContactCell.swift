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
protocol ContactCellDelegate: class {
    func deleteContact(cell: ContactCell)
}

class ContactCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    weak var delegate: ContactCellDelegate?
    var colorNameLabel: UIColor = UIColor.white {
        didSet {
            nameLabel.textColor = colorNameLabel
            
        }
    }
    
    var colorLabel: UIColor = UIColor.white {
        didSet {
            phoneNumberLabel.textColor = colorLabel
            emailLabel.textColor = colorLabel
        }
    }
    
    var backgroundViewContainer: UIColor =  UIColor.white {
        didSet {
            containerView.backgroundColor = backgroundViewContainer
        }
    }
    
    var imageDeleteButton: UIImage = UIImage(named: "delete-white")! {
        didSet {
            deleteButton.setImage(imageDeleteButton, for: .normal)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        styleUI()
    }
    
    func styleUI() {
        
        containerView.layer.cornerRadius = 2
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: -1, height: 1)
        containerView.layer.shadowRadius = 1
        
    } 
    @IBAction func didTouchDeleteButton(_ sender: Any) {
        delegate?.deleteContact(cell: self)
    }

}
