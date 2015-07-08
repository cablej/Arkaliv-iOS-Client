//
//  AddCommentViewController.swift
//  Arkaliv
//
//  Created by Jack Cable on 7/7/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit

class AddCommentViewController: UIViewController {
    
    @IBOutlet var commentTextView: UITextView!
    
    @IBOutlet var usernameLabel: UILabel!
    
    @IBOutlet var messageLabel: UILabel!
    
    var parent = ""
    var parentCommentID = ""
    
    let serverHelper = ServerHelper()
    let arkalivHelper = ArkalivHelper()
    
    let userDefaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(parent + " and " + parentCommentID)
        
        arkalivHelper.initializeViewController(self)
        
        if let username = serverHelper.getUsername() {
            usernameLabel.text = "Commenting as \(username)."
        }
        
    }

    @IBAction func onReplyButtonTapped(sender: UIBarButtonItem) {
        
        let comment = commentTextView.text
        
        if let key = serverHelper.getKey() {
            
            let postString = "action=AddComment&parent=\(parent)&parentComment=\(parentCommentID)&key=\(key)&text=\(comment)"
            
            serverHelper.sendRequest(serverHelper.REQUEST_URL, postString: postString ) {
                response in
                
                var message = "Successfully added comment!"
                
                if let error = self.serverHelper.error(response) {
                    message = error
                } else {
                    self.dismissView()
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.messageLabel.text = message
                }
            }
        } else {
            self.messageLabel.text = "Please log in."
        }
    }
    
    @IBAction func onCancelButtonTapped(sender: AnyObject) {
        dismissView()
    }
    
    func dismissView() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {
            let secondPresentingVC = self.presentingViewController?.presentingViewController;
            secondPresentingVC?.dismissViewControllerAnimated(true, completion: {})
        })
    }
    
}
