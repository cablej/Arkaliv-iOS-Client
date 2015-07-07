//
//  SignUpViewController.swift
//  Arkaliv
//
//  Created by Jack Cable on 7/3/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    @IBOutlet var messageLabel: UILabel!
    
    let serverHelper = ServerHelper()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onSignUpButtonTapped(sender: UIButton) {
        let username = usernameTextField.text!
        if let password = passwordTextField.text == confirmPasswordTextField.text! ? passwordTextField.text : nil {
            
            let postString = "username=\(username)&password=\(password)"
            
            serverHelper.sendRequest(serverHelper.SIGN_UP_URL, postString: postString ) {
                response in
                
                var message = "Successfully signed up!"
                
                if let error = self.serverHelper.error(response) {
                    message = error
                } else {
                    self.serverHelper.saveUserInformation(response)
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.messageLabel.text = message
                    self.dismissView()
                }
            }
            
        } else {
            messageLabel.text = "Passwords are not the same."
            return;
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
