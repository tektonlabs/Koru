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

class RefugeCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var refugeStatusImage: UIImageView!
    @IBOutlet weak var pendingQuestionLabel: UILabel!
    
    let viewModel = RefugeCellViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        styleUI()
        viewModel.statusBad = { [weak self] in
            self?.showStatusBad()
        }
        
        viewModel.statusGood = { [weak self] in
            self?.showStatusGood()
        }
    }
    
    func showStatusBad() {
        refugeStatusImage.image = UIImage(named: "red-oval")
    }
    
    func showStatusGood() {
        refugeStatusImage.image = UIImage(named: "green-oval")
    }

    func styleUI() {
        pendingQuestionLabel.textColor = ColorPalette.lightRose
        pendingQuestionLabel.text = ""
    }
}
