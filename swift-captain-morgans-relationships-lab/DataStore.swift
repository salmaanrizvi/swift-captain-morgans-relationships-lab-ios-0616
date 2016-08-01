//
//  DataStore.swift
//  swift-captain-morgans-relationships-lab
//
//  Created by Salmaan Rizvi on 8/1/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import CoreData

class DataStore {
    
    static let sharedData = DataStore()
    
    var pirates : [Pirate] = []
    
    func fetchData() {
        let fetchRequest = NSFetchRequest(entityName: "Pirate")
        
        do {
            self.pirates = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Pirate]
        } catch let error as NSError {
            print("Error fetching data. \(error)")
            pirates = []
        }
        
        if pirates.count == 0 {
            generateTestData()
        }
    }
    
    func generateTestData() {
        
        let pirate : Pirate = NSEntityDescription.insertNewObjectForEntityForName("Pirate", inManagedObjectContext: self.managedObjectContext) as! Pirate
        
        pirate.name = "Salmaan"
        
        let ship : Ship = NSEntityDescription.insertNewObjectForEntityForName("Ship", inManagedObjectContext: self.managedObjectContext) as! Ship
        
        ship.name = "Black Flag"
        ship.pirate = pirate
        
        let engine : Engine = NSEntityDescription.insertNewObjectForEntityForName("Engine", inManagedObjectContext: self.managedObjectContext) as! Engine
        
        engine.propulsionType = "Electric, ya bish"
        ship.engine = engine
        
        pirate.ships.insert(ship)
        
        self.saveContext()
        self.fetchData()
//

//        var numberOfShips = [4, 3, 5]
//        
//        for pirateNumber in 0..<numberOfShips.count
//        {
//            let currentPirate = NSEntityDescription.insertNewObjectForEntityForName("Pirate", inManagedObjectContext: managedObjectContext) as! Pirate
//            currentPirate.name = "AAARGH! Pirate #" + String(pirateNumber + 1)
//            
//            for shipNumber in 0..<numberOfShips[pirateNumber]
//            {
//                let currentShip = NSEntityDescription.insertNewObjectForEntityForName("Ship", inManagedObjectContext: managedObjectContext) as! Ship
//                currentShip.name = "Awesome Ship #" + String(shipNumber + 1)
//                currentShip.engine = NSEntityDescription.insertNewObjectForEntityForName("Engine", inManagedObjectContext: managedObjectContext) as! Engine
//                currentShip.engine.propulsionType = "Electric"
//                currentPirate.ships.insert(currentShip)
//            }
//        }
//        
//        saveContext()
//        fetchData()
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    // MARK: - Core Data stack
    // Managed Object Context property getter. This is where we've dropped our "boilerplate" code.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("swift_captain_morgans_relationships_lab", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("swift_captain_morgans_relationships_lab.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    //MARK: Application's Documents directory
    // Returns the URL to the application's Documents directory.
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.FlatironSchool.SlapChat" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
}