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


extension PendingMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PendingMO> {
        return NSFetchRequest<PendingMO>(entityName: "Pending");
    }

    @NSManaged public var dni: String?
    @NSManaged public var date: Int64
    @NSManaged public var refug: RefugeMO?
    @NSManaged public var sortedQues: NSSet?

}

// MARK: Generated accessors for sortedQues
extension PendingMO {

    @objc(addSortedQuesObject:)
    @NSManaged public func addToSortedQues(_ value: SortedQuestionMO)

    @objc(removeSortedQuesObject:)
    @NSManaged public func removeFromSortedQues(_ value: SortedQuestionMO)

    @objc(addSortedQues:)
    @NSManaged public func addToSortedQues(_ values: NSSet)

    @objc(removeSortedQues:)
    @NSManaged public func removeFromSortedQues(_ values: NSSet)

}
