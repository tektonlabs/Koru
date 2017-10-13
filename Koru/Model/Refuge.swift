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
import Mapper

class Refuge: Mappable {
    
    let id: Int?
    let name: String?
    var sortedName: String {
        return name!.lowercased()
    }
    let longitude: String?
    let latitude: String?
    let status: String?
    let address: String?
    let city: String?
    let country: Country?
    var category: [Category]? = nil
    var pendingSortedQuestion: [PendingQuestionForm]? = nil
    
    
    init(id: Int, name: String, longitude: String, latitude: String, status: String, address: String, city:String, country: Country, category: [Category]?, pendingSortedQuestion: [PendingQuestionForm]?) {
        self.id = id
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
        self.status = status
        self.address = address
        self.city = city
        self.country = country
        self.category = category
        self.pendingSortedQuestion = pendingSortedQuestion
    }

    
    init(id: Int, name: String, longitude: String, latitude: String, status: String, address: String, city:String, country: Country) {
        self.id = id
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
        self.status = status
        self.address = address
        self.city = city
        self.country = country
    }
    
    required init(map: Mapper) throws {
        id          = map.optionalFrom(RefugeKeys.id)
        name        = map.optionalFrom(RefugeKeys.name)
        longitude   = map.optionalFrom(RefugeKeys.longitude)
        latitude    = map.optionalFrom(RefugeKeys.latitude)
        status      = map.optionalFrom(RefugeKeys.status)
        address     = map.optionalFrom(RefugeKeys.address)
        city        = map.optionalFrom(RefugeKeys.city)
        country     = map.optionalFrom(RefugeKeys.country)
    }
}

extension Refuge {
    
    fileprivate struct RefugeKeys {
        static let id           = "id"
        static let name         = "name"
        static let longitude    = "longitude"
        static let latitude     = "latitude"
        static let status       = "status"
        static let address      = "address"
        static let city         = "city"
        static let country      = "country"
    }
}
