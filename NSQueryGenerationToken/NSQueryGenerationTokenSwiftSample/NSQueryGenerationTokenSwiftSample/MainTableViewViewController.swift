//
//  MainTableViewViewController.swift
//  NSQueryGenerationTokenSwiftSample
//
//  Created by Nikolay Andonov on 10/26/16.
//  Copyright © 2016 Mentormate. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewViewController: UITableViewController {
    
    @IBOutlet weak var firstGenButton: UIBarButtonItem!
    @IBOutlet weak var currentGenButton: UIBarButtonItem!

    var samplesArray: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        let context : NSManagedObjectContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        CoreDataHandler.sharedHandler.setCurrentGenerationTokenOnMainContext()
        //The initial fetch would create and save a token associated with the first generation
        samplesArray = CoreDataHandler.sharedHandler.fetchAllSamples(context: context)!
    }
    
    func configureTableView() {
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.tableFooterView = UIView()
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

    // MARK: - Button Actions
    
    @IBAction func firstGenButtonAction(_ sender: AnyObject) {
        
        currentGenButton.isEnabled = true
        firstGenButton.isEnabled = false
        CoreDataHandler.sharedHandler.setFirstGenerationTokenOnMainContext()
        tableView.reloadData()

    }

    @IBAction func currentGenButtonAction(_ sender: AnyObject) {
        
        //Performing data modification specific for the current generation
        CoreDataHandler.sharedHandler.generateDataUpdate()
        
        currentGenButton.isEnabled = false
        firstGenButton.isEnabled = true
        CoreDataHandler.sharedHandler.setCurrentGenerationTokenOnMainContext()
        tableView.reloadData()
        
    }
}
