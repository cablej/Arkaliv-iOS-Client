//
//  SignInViewController.swift
//  Arkaliv
//
//  Created by Jack Cable on 7/3/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var messageLabel: UILabel!
    
    let serverHelper = ServerHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func onSignInButtonTapped(sender: UIButton) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        let postString = "username=\(username!)&password=\(password!)"
        
        serverHelper.sendRequest(serverHelper.SIGN_IN_URL, postString: postString ) {
            response in
            
            var message = "Successfully signed in!"
            
            if let error = self.serverHelper.error(response) {
                message = error
            } else {
                self.serverHelper.saveUserInformation(response)
                self.dismissView()
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.messageLabel.text = message
            }
            
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
