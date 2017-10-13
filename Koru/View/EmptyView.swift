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

class EmptyView: UIView {

    var messageLabel: UILabel!
    var reloadButton: UIButton!
    let viewModel = EmptyViewModel()

    override init(frame: CGRect) {
        messageLabel = UILabel()
        reloadButton = UIButton()
        super.init(frame: frame)
        
        styleUI()
        setupConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        messageLabel = UILabel()
        reloadButton = UIButton()

        super.init(coder: aDecoder)
        
        styleUI()
        setupConstraint()
    }
    
    private func styleUI() {
        messageLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        messageLabel.text = "No Found Refuges."
        
        reloadButton.setTitle("Intentar de nuevo", for: .normal)
        reloadButton.setTitleColor(UIColor.gray, for: .normal)
    }
    
    private func setupConstraint() {
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)
        
        NSLayoutConstraint(item: messageLabel, attribute: .centerX, relatedBy: .equal, toItem:   self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: messageLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(reloadButton)
        NSLayoutConstraint(item: reloadButton, attribute: .centerX, relatedBy: .equal, toItem:   self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: reloadButton, attribute: .top, relatedBy: .equal, toItem: messageLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
    }


}
