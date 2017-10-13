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
protocol MultipleChoiseCellDelegate: class {
    func multipleChoiseCellDidTouchCheckBodx(cell: MultipleChoiseCell)
}


class MultipleChoiseCell: UITableViewCell {
    
    fileprivate let defaultBottomSpace = 5

    @IBOutlet weak var checkBoxView: CheckboxControl!
    @IBOutlet weak var bottomContraintLayout: NSLayoutConstraint!
    
    var isLastCell : Bool = false {
        didSet {
            if isLastCell {
                bottomContraintLayout.constant = 20
            } else {
                bottomContraintLayout.constant = 5
            }
            self.layoutIfNeeded()
        }
    }
    
    weak var delegate: MultipleChoiseCellDelegate?
    
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
        backgroundColor = ColorPalette.purple
        checkBoxView.backgroundColor = UIColor.clear
        checkBoxView.titleLabel.font = UIFont.systemFont(ofSize: 19)
        checkBoxView.titleLabel.textColor = UIColor.white
        checkBoxView.titleLabel.numberOfLines = 0
    }
    @IBAction func didTouchCheckBox(_ sender: CheckboxControl) {
        delegate?.multipleChoiseCellDidTouchCheckBodx(cell: self)
    }

}
