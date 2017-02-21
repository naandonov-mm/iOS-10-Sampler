//
//  SampleTableViewController.swift
//  NSPersistentContainerSwiftSample
//
//  Created by nikolay.andonov on 10/10/16.
//  Copyright © 2016 nikolay.andonov. All rights reserved.
//

import UIKit
import CoreData

class SampleTableViewController: UITableViewController {
    
    var samplesArray: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.lightGray
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.tableFooterView = UIView()
        
        let context : NSManagedObjectContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        samplesArray = CoreDataHandler.fetchAllSamples(context: context)!
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return samplesArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let sampleEntity : SampleEntity = samplesArray[indexPath.row] as! SampleEntity
        cell.textLabel?.text = sampleEntity.name
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
