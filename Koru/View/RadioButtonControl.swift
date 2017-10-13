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

import Foundation
import UIKit

class RadioButtonControl: UIControl {
    // MARK: Properties
    
    var RadioButtonImageView: UIImageView
    
    let selectedImage = UIImage(named: "radioButton-selected")
    let regularImage = UIImage(named: "radioButton")
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                animateIsSelected()
                RadioButtonImageView.image = selectedImage
                
            }else{
                animateIsNotSelected()
                RadioButtonImageView.image = regularImage
            }
            
        }
    }
    
    
    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        self.RadioButtonImageView = UIImageView(image: regularImage)
        
        super.init(coder: aDecoder)
        
        RadioButtonImageView.isUserInteractionEnabled = false
        RadioButtonImageView.translatesAutoresizingMaskIntoConstraints=false
        addSubview(RadioButtonImageView)
        
        let topConstraintTop = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: RadioButtonImageView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let topConstraintBottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: RadioButtonImageView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let topConstraintRigth = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: RadioButtonImageView, attribute: .right, multiplier: 1.0, constant: 0.0)
        let topConstraintLeft = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: RadioButtonImageView, attribute: .left, multiplier: 1.0, constant: 0.0)
        
        topConstraintTop.isActive = true
        topConstraintBottom.isActive = true
        topConstraintRigth.isActive = true
        topConstraintLeft.isActive = true
        
        
        addTarget(self, action: #selector(RadioButtonControl.RadioButtonTapped(button:)), for: .touchUpInside)
        
    }
    
    
    
    @objc func RadioButtonTapped(button: UIButton) {
        
        isSelected = !isSelected
        
    }
    
    
    func animateIsSelected(scale: CGFloat = 1.5){
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .allowAnimatedContent, animations: {
            self.RadioButtonImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: { (Bool) in
            if scale == 1.5 {
                self.animateIsSelected(scale: 1.0)
            }
            
        })
        
    }
    
    func animateIsNotSelected(scale: CGFloat = -0.5){
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .allowAnimatedContent, animations: {
            self.RadioButtonImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: { (Bool) in
            if scale == -0.5 {
                self.animateIsNotSelected(scale: 1.0)
            }
            
        })
        
    }
}
