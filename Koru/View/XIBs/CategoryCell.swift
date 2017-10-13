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

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    let viewModel = CategoryCellViewModel()
    
    
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        styleUI()
        
        viewModel.didSelectCategory = { [weak self] in
            self?.changeBorderColorDidSelected()
        }
       
        viewModel.didDeselectCategory = { [weak self] in
            self?.changeBorderColorDidDeselected()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.makeItCircle()
    }
    
    func changeBorderColorDidSelected() {
        UIView.animate(withDuration: 0.2, animations: {
            self.categoryImageView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        }, completion: { (true) in
            self.categoryImageView.layer.borderColor = ColorPalette.borderRose.cgColor
            UIView.animate(withDuration: 0.2, animations: {
                self.categoryImageView.transform = CGAffineTransform.identity
            }, completion: nil)
        })
    }

    func changeBorderColorDidDeselected() {
        UIView.animate(withDuration: 0.2, animations: {
            self.categoryImageView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        }, completion: { (true) in
            self.categoryImageView.layer.borderColor = ColorPalette.borderGray.cgColor
            UIView.animate(withDuration: 0.2, animations: {
                self.categoryImageView.transform = CGAffineTransform.identity
            }, completion: nil)
        })
    }
    
    func changeBorderColorWith(status: Bool) {
        if status {
          categoryImageView.layer.borderColor = ColorPalette.borderRose.cgColor
        } else {
          categoryImageView.layer.borderColor = ColorPalette.borderGray.cgColor
        }
    }

    func styleUI() {
        categoryImageView.layer.borderWidth = 3
        categoryImageView.layer.borderColor = ColorPalette.borderGray.cgColor
    }
    
    
    func makeItCircle() {
        self.categoryImageView.layer.masksToBounds = true
        self.categoryImageView.layer.cornerRadius  = CGFloat(roundf(Float(self.categoryImageView.frame.size.width/2.0)))
    }
    
    func fillCategory(image: String) {
        categoryImageView.image = UIImage(named: image)
    }
}
