//
//  CoreDataHandler.swift
//  NSPersistentContainerSwiftSample
//
//  Created by nikolay.andonov on 10/10/16.
//  Copyright © 2016 nikolay.andonov. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHandler {
    
    static func loadHardcodedDatabaseIfNeccessary() {
        
        let sharedDataStack = CoreDataStack.sharedInstance
        let context = sharedDataStack.persistentContainer.viewContext
        if let allSamples = fetchAllSamples(context: context) {
            if allSamples.count > 0 {
                return
            }
        }
        
        for i in 1..<10 {
            insertSampleEntity(name: "Entity #\(i)", context: context)
        }
        
        context.performAndWait {
            sharedDataStack.saveContext()
        }
    }
    
    static func insertSampleEntity(name: String, context: NSManagedObjectContext) {
        
        let sampleEntity = SampleEntity(context: context)
        sampleEntity.name = name
    }
    
   static func fetchAllSamples(context: NSManagedObjectContext) -> NSArray? {
        
        var result : NSArray? = nil
        context.performAndWait({
            let request : NSFetchRequest<SampleEntity> = SampleEntity.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [nameSortDescriptor]
            result = try! context.fetch(request) as NSArray?
        })
        
        return result
    }
}
