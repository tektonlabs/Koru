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

class CategoryListViewModel {
    
    var categoryArray = [String]()
    var refugeSelected: Refuge!
    
    var isSelectedCategory = false {
        didSet {
            didSelectedCategory?()
        }
    }
    
    var isSelectedAll = false {
        didSet {
            didSelectedAll?()
        }
    }
    
    var needLoading = false {
        didSet {
            didLoading?()
            callService(refuge: refugeSelected)
        }
    }
    
    var isSuccess = false {
        didSet {
            didSuccess?()
        }
    }
    
    var isFailure = false {
        didSet {
            didFailure?()
        }
    }
    
    var touchedContinue = false {
        didSet {
            didTouchContinue?()
        }
    }
    
    var didSelectedCategory: (() -> Void)?
    var didSelectedAll: (() -> Void)?
    var didLoading: (() -> Void)?
    var didSuccess: (() -> Void)?
    var didFailure: (() -> Void)?
    var didTouchContinue: (() -> Void)?
    
    
    func fillData() {
        categoryArray = [ "cutlery-Image","hospital-image","shower-image","mop-image","light-image","water-image","trash-image","policeman-image"]
    }
    
    func didSelectCategoryWith(indexPath: IndexPath) {
        if let category = refugeSelected.category?[indexPath.row] {
        if category.selected! {
            category.selected = false
        } else {
            category.selected = true
        }
        }
    }
    

    func verifyCategoriesStatus() -> Bool {
        if let categories = refugeSelected.category {
        for category in categories {
            if category.selected! {
                return true
                }
            }
        }
        return false
        
    }
    
    func selectAll() {
        if let categories = refugeSelected.category {
            for category in categories {
                category.selected = true
            }
            isSelectedAll = true
        }
    }
    
    func deselectAll() {
         if let categories = refugeSelected.category {
            for category in categories {

            category.selected = false
            }
        
        isSelectedAll = true
        }
    }
    
    func sort(category: [Category]) -> [Category] {
        return category.sorted  { $0.id! < $1.id! }
    }
    
    
    func callService(refuge: Refuge) {
        EntityService.getEntity(refuge: refuge) { (categories, error) in
            OperationQueue.main.addOperation {
                
                if let categories = categories {
                        self.refugeSelected.category = categories
                        RefugePersistence().updateRefuge(with: categories, refuge: refuge)  { (result) in
                            if result  {
                                print("save data")
                            } else {
                                print("error")
                            }
                        }
                    self.isSuccess = true
                } else {
                    self.fetchCategoryFromCoreData()
                }
                
            }
        }
    }
    
    func fetchCategoryFromCoreData() {
      
        let refuge = RefugePersistence().fetchRefugeWithCategory(refuge: refugeSelected)
        OperationQueue.main.addOperation {
            let categoryArray = self.sort(category: refuge.category!)
            refuge.category = categoryArray
            self.refugeSelected = refuge
            
            if let categories = refuge.category {
                if categories.count > 0 {
                    self.isSuccess = true
                } else {
                    self.isFailure = true
                }
            }
        }
    }

    
}

