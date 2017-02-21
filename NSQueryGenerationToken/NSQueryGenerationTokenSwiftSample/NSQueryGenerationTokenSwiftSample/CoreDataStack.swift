//
//  CoreDataStack.swift
//  NSPersistentContainerSwiftSample
//
//  Created by nikolay.andonov on 10/9/16.
//  Copyright © 2016 nikolay.andonov. All rights reserved.
//

import CoreData

private let sharedCoreDataStack = CoreDataStack()

class CoreDataStack {
    
    class var sharedInstance: CoreDataStack {
        return sharedCoreDataStack
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NSQueryGenerationTokenModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error))")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error)")
            }
        }
    }
}
