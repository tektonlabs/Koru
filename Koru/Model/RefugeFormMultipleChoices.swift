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

class RefugeFormMultipleChoices: Mappable {
    
    fileprivate struct Keys {
        static let committess = "committees"
        static let services = "services"
        static let housingStatuses = "housing_statuses"
        static let areas = "areas"
        static let lightManagements = "light_managements"
        static let waterManagements = "water_managements"
        static let stoolManagements = "stool_managements"
        static let wasteManagements = "waste_managements"
        static let foodManagements = "food_managements"
    }
    
    var committees: [MultipleChoice]?
    var services: [MultipleChoice]?
    var housingStatuses: [MultipleChoice]?
    var areas: [MultipleChoice]?
    var lightManagements: [MultipleChoice]?
    var waterManagements: [MultipleChoice]?
    var stoolManagements: [MultipleChoice]?
    var wasteManagements: [MultipleChoice]?
    var foodManagements: [MultipleChoice]?
    
    required init(map: Mapper) throws {
        committees = map.optionalFrom(Keys.committess)
        services = map.optionalFrom(Keys.services)
        housingStatuses = map.optionalFrom(Keys.housingStatuses)
        areas = map.optionalFrom(Keys.areas)
        lightManagements = map.optionalFrom(Keys.lightManagements)
        waterManagements = map.optionalFrom(Keys.waterManagements)
        stoolManagements = map.optionalFrom(Keys.stoolManagements)
        wasteManagements = map.optionalFrom(Keys.wasteManagements)
        foodManagements = map.optionalFrom(Keys.foodManagements)
    }
    
}
