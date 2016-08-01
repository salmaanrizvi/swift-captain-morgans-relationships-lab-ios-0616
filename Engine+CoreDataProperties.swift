//
//  Engine+CoreDataProperties.swift
//  swift-captain-morgans-relationships-lab
//
//  Created by Salmaan Rizvi on 8/1/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Engine {

    @NSManaged var propulsionType: String?
    @NSManaged var ship: Ship?

}
