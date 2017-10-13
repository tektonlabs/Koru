//
//  SortedQuestionMO+CoreDataProperties.swift
//  
//
//  Created by Tekton Labs on 8/10/17.
//
//

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
