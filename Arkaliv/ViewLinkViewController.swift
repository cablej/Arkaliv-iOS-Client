//
//  ViewLinkViewController.swift
//  Arkaliv
//
//  Created by Jack Cable on 7/6/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit

class ViewLinkViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!
    
    var postID: String = "";
    
    let serverHelper = ServerHelper()
    let arkalivHelper = ArkalivHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        arkalivHelper.initializeViewController(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        loadLink()
    }
    
    
    func loadLink() {
        
        let postString = "action=GetLink&id=\(postID)"
        
        serverHelper.sendRequest(serverHelper.REQUEST_URL, postString:postString) {
            response in
            
            if let error = self.serverHelper.error(response) {
                print(error)
                return
            }
            
            if let responseJSON = self.serverHelper.stringToJSON(response) {
                let link = self.serverHelper.linkObjectFromJSON(responseJSON["link"])
                
                var url = link.properties["url"]!
                
                if !url.hasPrefix("http://") && !url.hasPrefix("https://")  {
                    url = "http://" + url
                }
                
                self.webView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
            }
        }
    }

    @IBAction func onStopButtonTapped(sender: AnyObject) {
        webView.stopLoading()
    }
    
    @IBAction func onRefreshButtonTapped(sender: AnyObject) {
        webView.reload()
    }
    
    @IBAction func onBackButtonTapped(sender: AnyObject) {
        webView.goBack()
    }
    
    @IBAction func onForwardButtonTapped(sender: AnyObject) {
        webView.goForward()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        
        let dvc = segue.destinationViewController as! CommentsTableViewController
        dvc.postID = postID
    }
    
}
