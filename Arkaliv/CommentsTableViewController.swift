//
//  CommentsTableViewController.swift
//  Arkaliv
//
//  Created by Jack Cable on 7/6/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController {
    
    var postID: String = "";
    
    let serverHelper = ServerHelper()
    let arkalivHelper = ArkalivHelper()
    
    var comments: [Comment] = []
    var link: Link = Link(newProperties: Dictionary<String, String>())

    override func viewDidLoad() {
        super.viewDidLoad()
        arkalivHelper.initializeViewController(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        loadLink()
    }
    
    func loadLink() {
        
        comments = []
        
        let postString = "action=GetLink&id=\(postID)"
        
        serverHelper.sendRequest(serverHelper.REQUEST_URL, postString:postString) {
            response in
            
            if let error = self.serverHelper.error(response) {
                print(error)
                return
            }
            
            if let responseJSON = self.serverHelper.stringToJSON(response) {
                self.link = self.serverHelper.linkObjectFromJSON(responseJSON["link"])
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.navigationItem.title = self.link.properties["title"]
                })
                
                for comment in responseJSON["comments"] {
                    self.comments.append(self.serverHelper.commentObjectFromJSON(comment.1))
                }
                
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender!.tag == 1  {
            let navVC = segue.destinationViewController as! UINavigationController
            
            let dvc = navVC.topViewController as! AddCommentViewController
            
            var parent = ""
            
            if let _ = sender as? UITableViewCell { //parent is a comment
                if tableView.indexPathForSelectedRow!.section == 1 {
                    parent = comments[(tableView.indexPathForSelectedRow?.row)!].properties["id"]!
                }
            }
            
            dvc.parent = link.properties["id"]!
            dvc.parentCommentID = parent
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : comments.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("CommentTableViewCell", forIndexPath: indexPath) as! CommentTableViewCell
            
            cell.commentTextLabel.text = link.properties["title"]
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentTableViewCell", forIndexPath: indexPath) as! CommentTableViewCell
        
        let comment = comments[indexPath.row]
        
        var text = ""
        
        for _ in 0..<Int(comment.properties["level"]!)! {
            text += "   "
        }
        
        cell.commentTextLabel.text = text + comment.properties["text"]!
        
        return cell
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
