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


extension RefugeMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RefugeMO> {
        return NSFetchRequest<RefugeMO>(entityName: "Refuge");
    }

    @NSManaged public var address: String?
    @NSManaged public var city: String?
    @NSManaged public var id: Int64
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var name: String?
    @NSManaged public var status: String?
    @NSManaged public var catego: NSSet?
    @NSManaged public var count: CountryMO?
    @NSManaged public var pending: NSSet?

}

// MARK: Generated accessors for catego
extension RefugeMO {

    @objc(addCategoObject:)
    @NSManaged public func addToCatego(_ value: CategoryMO)

    @objc(removeCategoObject:)
    @NSManaged public func removeFromCatego(_ value: CategoryMO)

    @objc(addCatego:)
    @NSManaged public func addToCatego(_ values: NSSet)

    @objc(removeCatego:)
    @NSManaged public func removeFromCatego(_ values: NSSet)

}

// MARK: Generated accessors for pending
extension RefugeMO {

    @objc(addPendingObject:)
    @NSManaged public func addToPending(_ value: PendingMO)

    @objc(removePendingObject:)
    @NSManaged public func removeFromPending(_ value: PendingMO)

    @objc(addPending:)
    @NSManaged public func addToPending(_ values: NSSet)

    @objc(removePending:)
    @NSManaged public func removeFromPending(_ values: NSSet)

}
