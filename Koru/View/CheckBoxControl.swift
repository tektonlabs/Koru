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

enum CheckboxStyle {
    case left
    case right
}

class CheckboxControl: UIControl {
    
    
    
    var checkboxImageView: UIImageView
    
    let selectedImage = UIImage(named: "checkbox-selected")?.withRenderingMode(.alwaysTemplate)
    let regularImage = UIImage(named: "checkbox")?.withRenderingMode(.alwaysTemplate)
    
    
    var titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    var style: CheckboxStyle = .right {
        didSet {
            if style == .right {
                self.setLayoutToRight()
            }
        }
    }
    
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                animateIsSelected()
                checkboxImageView.image = selectedImage
                
            }else{
                animateIsNotSelected()
                checkboxImageView.image = regularImage
            }
            
        }
    }
    
    var selectedColor: UIColor?
    var unselectedColor: UIColor?
    
    required init?(coder aDecoder: NSCoder) {
        self.checkboxImageView = UIImageView(image: regularImage)
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
        titleLabel.numberOfLines = 0
        titleLabel.isUserInteractionEnabled = false
        titleLabel.translatesAutoresizingMaskIntoConstraints=false
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
        
        let topConstraintTop = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .top, multiplier: 1.0, constant: 0.0)
        let topConstraintBottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let topConstraintRigth = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: titleLabel, attribute: .right, multiplier: 1.0, constant: 0.0)
        let topConstraintLeft = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: titleLabel, attribute: .left, multiplier: 1.0, constant: -30.0)
        
        topConstraintTop.isActive = true
        topConstraintBottom.isActive = true
        topConstraintRigth.isActive = true
        topConstraintLeft.isActive = true
        
        titleLabel.text = "title label"
        
        checkboxImageView.tintColor = UIColor.white
        checkboxImageView.isUserInteractionEnabled = false
        checkboxImageView.translatesAutoresizingMaskIntoConstraints=false
        addSubview(checkboxImageView)
        
        NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: checkboxImageView, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        
        
        NSLayoutConstraint(item: checkboxImageView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 21.0).isActive = true
        
        NSLayoutConstraint(item: checkboxImageView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 18.0).isActive = true
        
        NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: checkboxImageView, attribute: .left, multiplier: 1.0, constant: 0.0).isActive = true
        
        addTarget(self, action: #selector(CheckboxControl.checkBoxTapped(button:)), for: .touchUpInside)
    }
    
    fileprivate func setLayoutToRight() {
        self.removeConstraints(self.constraints)
        self.titleLabel.removeConstraints(self.titleLabel.constraints)
        self.checkboxImageView.removeConstraints(self.checkboxImageView.constraints)
        
        self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive =  true
        
        self.checkboxImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.checkboxImageView.widthAnchor.constraint(equalToConstant: 21.0).isActive = true
        self.checkboxImageView.heightAnchor.constraint(equalToConstant: 21.0).isActive = true
        self.checkboxImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.checkboxImageView.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 8).isActive = true
    }
    
    
    @objc func checkBoxTapped(button: UIButton) {
        isSelected = !isSelected
    }
    
    func animateIsSelected(scale: CGFloat = 1.25){
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .allowAnimatedContent, animations: {
            self.checkboxImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            if let selectedColor = self.selectedColor {
                self.checkboxImageView.tintColor = selectedColor
            }
        }, completion: { (Bool) in
            if scale == 1.25 {
                self.animateIsSelected(scale: 1.0)
            }
        })
    }
    
    func animateIsNotSelected(scale: CGFloat = 0.75){
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .allowAnimatedContent, animations: {
            self.checkboxImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            if let unselectedColor = self.unselectedColor {
                self.checkboxImageView.tintColor = unselectedColor
            }
        }, completion: { (Bool) in
            if scale == 0.75 {
                self.animateIsNotSelected(scale: 1.0)
            }
            
        })
    }
    
    
}
