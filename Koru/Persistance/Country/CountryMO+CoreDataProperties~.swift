//
//  CountryMO+CoreDataProperties.swift
//  
//
//  Created by Tekton Labs on 7/24/17.
//
//

import Foundation
import CoreData


extension CountryMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CountryMO> {
        return NSFetchRequest<CountryMO>(entityName: "Country");
    }

    @NSManaged public var id: Int64
    @NSManaged public var iso: String?
    @NSManaged public var name: String?
    @NSManaged public var ref: RefugeMO?

}
