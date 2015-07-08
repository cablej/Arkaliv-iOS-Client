//
//  HomeTableViewController.swift
//  Arkaliv
//
//  Created by Jack Cable on 7/3/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    @IBOutlet var signUpButton: UIBarButtonItem!
    @IBOutlet var signInButton: UIBarButtonItem!
    @IBOutlet var logOutButton: UIBarButtonItem!
    @IBOutlet var usernameButton: UIBarButtonItem!
    
    let serverHelper = ServerHelper()
    let arkalivHelper = ArkalivHelper()
    var links: [Link] = []
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arkalivHelper.initializeViewController(self)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        tableView.backgroundColor = UIColor.whiteColor()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        updateUsername()
        updateLinks()
    }
    
    func updateUsername() {
        if let _ = userDefaults.objectForKey("key") {
            if let username = userDefaults.objectForKey("username") {
                usernameButton.title = username as? String
            }
        }
    }
    
    func updateLinks() {
        serverHelper.sendRequest(serverHelper.REQUEST_URL, postString:"action=GetLinks") {
            response in
            
            self.links = []
            
            if let error = self.serverHelper.error(response) {
                print(error)
                return
            }
            
            if let responseJSON = self.serverHelper.stringToJSON(response) {
                for link in responseJSON {
                    self.links.append(self.serverHelper.linkObjectFromJSON(link.1))
                }
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }
    
    @IBAction func onLogOutButtonTapped(sender: AnyObject) {
        
        userDefaults.setObject("", forKey: "key")
        userDefaults.setObject("", forKey: "username")
        
        updateUsername()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let _ = sender as? LinkTableViewCell {
            let dvc = segue.destinationViewController as! ViewLinkViewController
            let index = tableView.indexPathForSelectedRow?.row
            dvc.postID = links[index!].properties["id"]!
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LinkCell", forIndexPath: indexPath) as! LinkTableViewCell

        let properties = links[indexPath.row].properties
        
        cell.titleLabel.text = properties["title"]
        cell.authorLabel.text = properties["author"]
        cell.commentsLabel.text = properties["numComments"]! + " comments"

        return cell
    }
    
//    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        
//    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print("selected " + String(indexPath.row))
        
//        let viewLinkController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewLinkViewController") as! ViewLinkViewController
//        viewLinkController.postID = links[indexPath.row].properties["id"]!
//        
//        self.navigationController?.pushViewController(viewLinkController, animated: true)
//        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
