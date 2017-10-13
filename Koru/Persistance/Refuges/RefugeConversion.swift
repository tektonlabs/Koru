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
import CoreData

extension Refuge {
    
    convenience init(refugeMO: RefugeMO) {
        
        let id = refugeMO.id
        let name = refugeMO.name!
        let city = refugeMO.city!
        let address = refugeMO.address ?? ""
        let latitude = refugeMO.latitude!
        let longitude = refugeMO.longitude ?? ""
        let status = refugeMO.status!
        let country = Country(id: Int(refugeMO.count!.id), name: refugeMO.count!.name!, iso: refugeMO.count!.iso!)
    
        var categoryArray = [Category]()
        if let categoriesMO = refugeMO.catego?.allObjects as! [CategoryMO]? {
            for categoryMO in categoriesMO {
                let newCategory = Category(categoryMO: categoryMO)
                categoryArray.append(newCategory)
            }
        }
        
        var pendingFormArray = [PendingQuestionForm]()
        if let pendingsMO = refugeMO.pending?.allObjects as! [PendingMO]? {
            for pendingMO in pendingsMO {
                let newPendingForm = PendingQuestionForm(pendingMO: pendingMO)
                pendingFormArray.append(newPendingForm)
            }
        }
        
        self.init(id: Int(id), name: name, longitude: longitude, latitude: latitude, status: status, address: address, city: city, country: country, category: categoryArray, pendingSortedQuestion: pendingFormArray)
    }
}
