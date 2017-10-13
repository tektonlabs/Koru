//
//  CategoryMO+CoreDataProperties.swift
//  
//
//  Created by Tekton Labs on 8/2/17.
//
//

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
