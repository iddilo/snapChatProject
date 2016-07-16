/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse




class ViewController: UIViewController,UITextFieldDelegate {
    
    func displayAlert(title: String, message: String) {
        
        
        if #available(iOS 8.0, *) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            
            // Fallback on earlier versions
        }
    }

 var signUpState = true
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var toggleSignUpButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet var signUpButton: UIButton!
    
    @IBAction func signUp(sender: AnyObject) {
        
        
        if username.text == "" || password.text == "" {
            
            displayAlert("Missing Field(s)", message: "Username and Password are required")
            
        } else {
        
            
            
            if signUpState == true {
                
                
                let user = PFUser()
                user.username = self.username.text
                user.password = self.password.text
                   

                user.signUpInBackgroundWithBlock {
                    
                    (succeeded: Bool,error: NSError?) -> Void in
                    
                    if let error = error {
                    
                        let errorString = error.userInfo["error"]! as! String
                        self.errorLabel.text = "Error:" + errorString
                    
                    } else {
                    
                        
                        print("Signed Up")
                    
                        self.performSegueWithIdentifier("showUserTable", sender: self)
                
                
                }
            
            }
                
                 } else {
             
                    PFUser.logInWithUsernameInBackground(username.text!, password: password.text!){
                        (user:PFUser?, error: NSError?)-> Void in
                        
                        if user != nil {
                            
                            
                            print("Logged In")
                            
                            self.performSegueWithIdentifier("showUserTable", sender: self)
                            
                        } else {
                        
                            let errorString = error!.userInfo["error"]! as! String
                            self.errorLabel.text = "Error:" + errorString

                        }
                
                
                
        
        
            
        }
    
    }
  }
}
    @IBAction func toggleLogin(sender: AnyObject) {
        
        if signUpState == true {
            
            signUpButton.setTitle("Log In", forState: UIControlState.Normal)
            toggleSignUpButton.setTitle("Switch to Sign Up", forState: UIControlState.Normal)
            
            signUpState = false
          
            
        } else {
            
            
            
            signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
            toggleSignUpButton.setTitle("Switch to Login", forState: UIControlState.Normal)
            
            signUpState = true
         
            
            
            
        }

    }
    
       override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser()?.username != nil {
          
                
                
                self.performSegueWithIdentifier("showUserTable", sender: self)
            
            }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBar.hidden = true
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.username.delegate = self;
        self.password.delegate = self;
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    
        }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
