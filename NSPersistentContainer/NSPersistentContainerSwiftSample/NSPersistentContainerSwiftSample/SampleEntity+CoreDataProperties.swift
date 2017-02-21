//
//  SampleEntity+CoreDataProperties.swift
//  NSPersistentContainerSwiftSample
//
//  Created by nikolay.andonov on 10/10/16.
//  Copyright © 2016 nikolay.andonov. All rights reserved.
//

import Foundation
import CoreData


extension SampleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SampleEntity> {
        return NSFetchRequest<SampleEntity>(entityName: "SampleEntity");
    }

    @NSManaged public var name: String?

}
