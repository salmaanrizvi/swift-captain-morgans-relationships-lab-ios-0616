//
//  PiratesViewController.swift
//  swift-captain-morgans-relationships-lab
//
//  Created by Salmaan Rizvi on 8/1/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import CoreData

class PiratesViewController: UITableViewController, NSFetchedResultsControllerDelegate
{
    let CellIdentifier  = "pirateCell"
    var store: DataStore = DataStore.sharedData
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        let store = DataStore.sharedData
        store.fetchData()
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return store.pirates.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath)
        let pirates = Array(store.pirates)
        let currentPirate = pirates[indexPath.row]
        cell.textLabel?.text = currentPirate.name
        cell.detailTextLabel?.text = String.init(format: "%lu", currentPirate.ships.count)
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "shipsSegue"
        {
            let nextVC = segue.destinationViewController as! ShipsViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            let selectedPirate = store.pirates[selectedIndexPath.row]
            nextVC.pirate = selectedPirate
        }
    }
    
}