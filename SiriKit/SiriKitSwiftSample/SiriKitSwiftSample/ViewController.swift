//
//  ViewController.swift
//  SiriKitSwiftSample
//
//  Created by Nikolay Andonov on 12/7/16.
//  Copyright © 2016 Mentormate. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let provider = PhotosProvider.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return provider.allPhotos().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "Cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: reuseIdentifier)
        }
        cell?.textLabel?.text = (provider.allPhotos())[indexPath.row]
        cell?.accessoryType = .disclosureIndicator
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let imageName = (provider.allPhotos())[indexPath.row]
        performSegue(withIdentifier: "Show", sender: imageName)
        
    }
    
    //MARK: - Public
    
    func showPhotoForSearchTerm(term: String) {
        if provider.containsPhotoForSearchTerm(term: term) {
            performSegue(withIdentifier: "Show", sender: term)
        }
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetailViewController {
            let detailViewController = segue.destination as! DetailViewController
            if let imageName = sender as? String {
                detailViewController.image = provider.photoForSearchTerm(term: imageName)
            }
        }
    }


}

