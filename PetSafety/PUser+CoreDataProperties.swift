//
//  PUser+CoreDataProperties.swift
//  PetSafety
//
//  Created by Lambiase Salvatore on 14/07/18.
//  Copyright © 2018 De Cristofaro Paolo. All rights reserved.
//
//

import Foundation
import CoreData


extension PUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PUser> {
        return NSFetchRequest<PUser>(entityName: "PUser")
    }

    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var phonenumber: String?
    @NSManaged public var surname: String?
    @NSManaged public var userid: String?
    @NSManaged public var photouuid: String?

}
