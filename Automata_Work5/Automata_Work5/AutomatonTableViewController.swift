
//
//  AutomatonTableViewController.swift
//  Automata_Work5
//
//  Created by Jeremie Roche on 1/24/16.
//  Copyright © 2016 jeremieroche. All rights reserved.
//

import UIKit

class AutomatonTableViewController: UITableViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let autoCollection = sender as? Automaton
        
        if let avc = segue.destinationViewController as? AutomatonViewController{
            if let identifier = segue.identifier{
                switch identifier{
                case "form_auto":
                    avc.insertAuto = autoCollection!
                    break
                default : break
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(AutomatonTableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.union_button.enabled = true
        self.intersect_button.enabled = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
        
        self.union_button.enabled = true
        self.intersect_button.enabled = true
    }
    
    
    // MARK: Table Cell
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model : AutomatonCollectionModel = AutomatonCollectionModel.sharedMegaCollAutoModel()
        return model.megaAuto.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell",forIndexPath: indexPath) as! AutomatonTableViewCell
        
        let model = AutomatonCollectionModel.sharedMegaCollAutoModel()
        
        let auto = model.megaAuto[indexPath.row]
        
        var cellText : String = ""
        
        cellText.appendContentsOf(String(format: "Automaton %d", indexPath.row))
        
        cell.textLabel!.text = (cellText == "") ? "N/A" : cellText
        
        cell.automaton = auto
        
        return cell
    }
    
    // MARK: methods
    
    @IBOutlet weak var union_button: UIBarButtonItem!
    @IBAction func union_action(sender: AnyObject) {
        self.new_auto_merge = true
        self.union_button.enabled = false
        self.intersect_button.enabled = false
        
    }
    
    @IBOutlet weak var intersect_button: UIBarButtonItem!
    @IBAction func intersect_action(sender: AnyObject) {
        self.new_auto_inter = true
        self.union_button.enabled = false
        self.intersect_button.enabled = false
        
    }
    
    var new_auto_merge : Bool = false
    var new_auto_inter : Bool = false
    
    var mergeAuto0 : Automaton?
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = AutomatonCollectionModel.sharedMegaCollAutoModel()
        
        
        let row_num : Int = indexPath.row
        
        if !new_auto_merge && !new_auto_inter{
            let auto : Automaton = model.megaAuto[row_num]
            self.performSegueWithIdentifier("form_auto", sender: auto)
        } else {
            
            if mergeAuto0 == nil {
                mergeAuto0 = model.megaAuto[row_num]
            } else {
                
                let mergeAuto1 : Automaton = model.megaAuto[row_num]
                
                // Create New Automaton
                var newAuto : Automaton? = nil
                if self.new_auto_merge{
                    newAuto = mergeAuto1.union(with: self.mergeAuto0!)!
                    self.new_auto_merge = false
                } else if self.new_auto_inter{
                    newAuto = mergeAuto1.intersect(with: self.mergeAuto0!)!
                    self.new_auto_inter = false
                }
                
                // Clear 'self.mergeAuto0'
                self.mergeAuto0 = nil
                model.megaAuto.append(newAuto!)
                self.performSegueWithIdentifier("form_auto", sender: newAuto!)
            }

        }
        
    }
    
}
