//
//  SampleEntity+CoreDataProperties.swift
//  NSQueryGenerationTokenSwiftSample
//
//  Created by Nikolay Andonov on 10/26/16.
//  Copyright © 2016 Mentormate. All rights reserved.
//

import Foundation
import CoreData


extension SampleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SampleEntity> {
        return NSFetchRequest<SampleEntity>(entityName: "SampleEntity");
    }

    @NSManaged public var name: String?

}
