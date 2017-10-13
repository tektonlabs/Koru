//
//  PendingMO+CoreDataProperties.swift
//  
//
//  Created by Tekton Labs on 8/10/17.
//
//

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
