//
//  PPet+CoreDataProperties.swift
//  PetSafety
//
//  Created by Lambiase Salvatore on 12/07/18.
//  Copyright © 2018 De Cristofaro Paolo. All rights reserved.
//
//

import Foundation
import CoreData


extension PPet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PPet> {
        return NSFetchRequest<PPet>(entityName: "PPet")
    }

    @NSManaged public var name: String?
    @NSManaged public var birthdate: NSDate?
    @NSManaged public var race: String?
    @NSManaged public var type: String?
    @NSManaged public var photouuid: UUID?
    @NSManaged public var microchipid: String?
    @NSManaged public var beaconid: String?
    @NSManaged public var order: Int16

}
