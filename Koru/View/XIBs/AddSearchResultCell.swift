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

protocol AddSearchResultCellDelegate: class {
    func addSearchResultCell(didTapAddButton cell: AddSearchResultCell)
    func addSearchResultCell(didTapDeleteButton cell: AddSearchResultCell)
}

class AddSearchResultCell: UITableViewCell {
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    
    var result: String? = "" {
        didSet {
            if let result = result,  result.characters.count > 0 {
                self.resultLabel.text = result
            } else {
                self.resultLabel.text = ""
            }
        }
    }
    
    var showAddButton: Bool = true {
        didSet {
            if !showAddButton {
                self.addButton.setTitle("x", for: .normal)
            } else {
                self.addButton.setTitle("+", for: .normal)
            }
        }
    }
    
    weak var delegate: AddSearchResultCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addButton.tintColor = ColorPalette.borderRose
    }
    
    @IBAction func didTapAddButton(_ sender: UIButton) {
        if showAddButton {
            delegate?.addSearchResultCell(didTapAddButton: self)
        } else {
            delegate?.addSearchResultCell(didTapDeleteButton: self)
        }
    }
    
    
}
