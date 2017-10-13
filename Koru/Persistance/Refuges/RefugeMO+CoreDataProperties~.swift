//
//  RefugeMO+CoreDataProperties.swift
//  
//
//  Created by Tekton Labs on 8/10/17.
//
//

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
