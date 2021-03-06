//
//  MyDietsControllerViewController.swift
//  Cleverdiet
//
//  Created by Jose Luis Molina on 9/3/16.
//  Copyright © 2016 Jose Luis Molina. All rights reserved.
//

import UIKit

class MyDietsViewController: UITableViewController {
    var diets : [Diet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        diets = DietDataLoader.downloadFromDatabase(UserManager.sharedInstance.currentUser!)!
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MyDietCellTableViewCell
        cell.title.text = diets[indexPath.row].name
        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diets.count
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "OpenDiet") {
            let svc = segue.destinationViewController as! DietViewController;
            if let indexPath = self.tableView.indexPathForSelectedRow?.row {
                svc.diet = diets[indexPath]
            }
        } else if (segue.identifier == "GenerateNewDiet") {
            let svc = segue.destinationViewController as! DietViewController;
            let dateFormatter: NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
            svc.diet = DietGenerator.generateFor(UserManager.sharedInstance.currentUser!, withName: "Dieta del día \(dateFormatter.stringFromDate(NSDate()))")
            DietDataLoader.loadToDatabase(svc.diet)
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            if (DietDataLoader.removeFromDatabase(diets[indexPath.row])) {
                diets.removeAtIndex(indexPath.row)
                tableView.reloadData()
            }
        }
    }
    
}
