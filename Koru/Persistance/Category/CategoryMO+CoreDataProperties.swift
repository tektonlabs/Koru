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


extension CategoryMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryMO> {
        return NSFetchRequest<CategoryMO>(entityName: "Category");
    }

    @NSManaged public var id: Int64
    @NSManaged public var level: String?
    @NSManaged public var name: String?
    @NSManaged public var ref: NSSet?
    @NSManaged public var sortedques: NSSet?

}

// MARK: Generated accessors for ref
extension CategoryMO {

    @objc(addRefObject:)
    @NSManaged public func addToRef(_ value: RefugeMO)

    @objc(removeRefObject:)
    @NSManaged public func removeFromRef(_ value: RefugeMO)

    @objc(addRef:)
    @NSManaged public func addToRef(_ values: NSSet)

    @objc(removeRef:)
    @NSManaged public func removeFromRef(_ values: NSSet)

}

// MARK: Generated accessors for sortedques
extension CategoryMO {

    @objc(addSortedquesObject:)
    @NSManaged public func addToSortedques(_ value: SortedQuestionMO)

    @objc(removeSortedquesObject:)
    @NSManaged public func removeFromSortedques(_ value: SortedQuestionMO)

    @objc(addSortedques:)
    @NSManaged public func addToSortedques(_ values: NSSet)

    @objc(removeSortedques:)
    @NSManaged public func removeFromSortedques(_ values: NSSet)

}
