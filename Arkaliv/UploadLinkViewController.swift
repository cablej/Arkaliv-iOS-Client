//
//  UploadLinkViewController.swift
//  Arkaliv
//
//  Created by Jack Cable on 7/3/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit

class UploadLinkViewController: UIViewController {

    @IBOutlet var urlTextField: UITextField!
    
    @IBOutlet var titleTextField: UITextField!
    
    @IBOutlet var messageLabel: UILabel!
    
    let serverHelper = ServerHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onUploadButtonTapped(sender: AnyObject) {
        let url = urlTextField.text!
        let title = titleTextField.text!
        
        if let key = serverHelper.getKey() {
            
            let postString = "url=\(url)&title=\(title)&key=\(key)"
            
            serverHelper.sendRequest(serverHelper.UPLOAD_LINK_URL, postString: postString ) {
                response in
                
                var message = "Successfully uploaded link!"
                
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
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissView()
    }
    
    func dismissView() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {
            let secondPresentingVC = self.presentingViewController?.presentingViewController;
            secondPresentingVC?.dismissViewControllerAnimated(true, completion: {})
        })
    }

    
}
