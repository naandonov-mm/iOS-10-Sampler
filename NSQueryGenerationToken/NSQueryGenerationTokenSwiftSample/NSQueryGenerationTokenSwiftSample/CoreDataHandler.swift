
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
    
    static let sharedHandler = CoreDataHandler()
    var firstGenerationToken : NSQueryGenerationToken!
    
    func loadHardcodedDatabase() {
        
        let sharedDataStack = CoreDataStack.sharedInstance
        let context = sharedDataStack.persistentContainer.viewContext
        if let allSamples = fetchAllSamples(context: context) {
            if allSamples.count > 0 {
                for sampleEntity in allSamples {
                    context .delete(sampleEntity as! SampleEntity)
                }
            }
        }
        
        for i in 1..<10 {
            insertSampleEntity(name: "Entity #\(i)", context: context)
        }
        
        context.performAndWait {
            sharedDataStack.saveContext()
        }
    }
    
    private func insertSampleEntity(name: String, context: NSManagedObjectContext) {
        
        let sampleEntity = SampleEntity(context: context)
        sampleEntity.name = name
    }
    
   func fetchAllSamples(context: NSManagedObjectContext) -> NSArray? {
    
    var result : NSArray? = nil
        context.performAndWait({
            let request : NSFetchRequest<SampleEntity> = SampleEntity.fetchRequest()
            request.shouldRefreshRefetchedObjects = true
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [nameSortDescriptor]
            result = try! context.fetch(request) as NSArray?
        })
    
    if firstGenerationToken == nil {
        //New NSQueryGenerationToken object is created and assigned to the context during each database transaction
        firstGenerationToken = context.queryGenerationToken
    }
    
    return result
    }
    
    func setFirstGenerationTokenOnMainContext() {
        
        if (firstGenerationToken != nil) {
            
            let sharedDataStack = CoreDataStack.sharedInstance
            let context = sharedDataStack.persistentContainer.viewContext
            
            weak var weakSelf = self
            context.performAndWait {
                
                do {
                    try context.setQueryGenerationFrom(weakSelf?.firstGenerationToken)
                    //NSQueryGenerationToken tells the context to lazily retrieve the most recent version on its next read operation (fetching or faulting)
                    //So in order to retrive the updated data from already fired properties we are refreshing all the objects in the context
                    context.refreshAllObjects()
                    
                } catch {
                    print("Error in setting QueryGenerationToken")
                }
            }
        }
    }
    
    func setCurrentGenerationTokenOnMainContext() {
        
        let sharedDataStack = CoreDataStack.sharedInstance
        let context = sharedDataStack.persistentContainer.viewContext
        
        context.performAndWait {
            
            do {
                try context.setQueryGenerationFrom(NSQueryGenerationToken.current)
                //NSQueryGenerationToken tells the context to lazily retrieve the most recent version on its next read operation (fetching or faulting)
                //So in order to retrive the updated data from already faulted properties we are refreshing all the objects in the context
                context.refreshAllObjects()
                
            } catch {
                print("Error in setting QueryGenerationToken")
            }
        }
    }

    
    func generateDataUpdate() {
        
        //Updating the persitent data on a background context
        let sharedDataStack = CoreDataStack.sharedInstance
        let backgroundManagedObjectContext = sharedDataStack.persistentContainer.newBackgroundContext()
        
        backgroundManagedObjectContext.performAndWait() {
            let update = NSBatchUpdateRequest(entityName:"SampleEntity")
            update.propertiesToUpdate = ["name" : NSExpression(forConstantValue:"New Cell")]
            do {
                _ = try backgroundManagedObjectContext.execute(update)
            } catch {
                print("Error executing update: \(error)")
            }
        }
        
    }
}
