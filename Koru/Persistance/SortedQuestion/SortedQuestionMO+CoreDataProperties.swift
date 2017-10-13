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


extension SortedQuestionMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SortedQuestionMO> {
        return NSFetchRequest<SortedQuestionMO>(entityName: "SortedQuestion");
    }

    @NSManaged public var id: Int64
    @NSManaged public var maxValue: String?
    @NSManaged public var minValue: String?
    @NSManaged public var questionType: String?
    @NSManaged public var text: String?
    @NSManaged public var answer: NSSet?
    @NSManaged public var categor: NSSet?
    @NSManaged public var subquest: NSSet?
    @NSManaged public var pending: NSSet?

}

// MARK: Generated accessors for answer
extension SortedQuestionMO {

    @objc(addAnswerObject:)
    @NSManaged public func addToAnswer(_ value: AnswerMO)

    @objc(removeAnswerObject:)
    @NSManaged public func removeFromAnswer(_ value: AnswerMO)

    @objc(addAnswer:)
    @NSManaged public func addToAnswer(_ values: NSSet)

    @objc(removeAnswer:)
    @NSManaged public func removeFromAnswer(_ values: NSSet)

}

// MARK: Generated accessors for categor
extension SortedQuestionMO {

    @objc(addCategorObject:)
    @NSManaged public func addToCategor(_ value: CategoryMO)

    @objc(removeCategorObject:)
    @NSManaged public func removeFromCategor(_ value: CategoryMO)

    @objc(addCategor:)
    @NSManaged public func addToCategor(_ values: NSSet)

    @objc(removeCategor:)
    @NSManaged public func removeFromCategor(_ values: NSSet)

}

// MARK: Generated accessors for subquest
extension SortedQuestionMO {

    @objc(addSubquestObject:)
    @NSManaged public func addToSubquest(_ value: SortedQuestionMO)

    @objc(removeSubquestObject:)
    @NSManaged public func removeFromSubquest(_ value: SortedQuestionMO)

    @objc(addSubquest:)
    @NSManaged public func addToSubquest(_ values: NSSet)

    @objc(removeSubquest:)
    @NSManaged public func removeFromSubquest(_ values: NSSet)

}

// MARK: Generated accessors for pending
extension SortedQuestionMO {

    @objc(addPendingObject:)
    @NSManaged public func addToPending(_ value: PendingMO)

    @objc(removePendingObject:)
    @NSManaged public func removeFromPending(_ value: PendingMO)

    @objc(addPending:)
    @NSManaged public func addToPending(_ values: NSSet)

    @objc(removePending:)
    @NSManaged public func removeFromPending(_ values: NSSet)

}
