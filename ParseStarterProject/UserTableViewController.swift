//
//  UserTableViewController.swift
//  snapChatProject
//
//  Created by p.mitev on 08.07.16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse


class UserTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    var usernames = [String]()
    var recipientUserName = ""
    
    func checkForMessage() {
        
        
        if  PFUser.currentUser()!.username != nil {
            
        let query = PFQuery(className:"pic")
        query.whereKey("recipientUserName", equalTo: (PFUser.currentUser()?.username)!)
        let images = try!query.findObjects()
            
       
        
        if let pfObjects = images as? [PFObject] {
            
            if pfObjects.count  > 0 {
        
            let imageView: PFImageView = PFImageView()
            imageView.file = pfObjects[0]["photo"] as? PFFile
                imageView.loadInBackground({
                    
                    (photo , error) -> Void in
                    
                        if error == nil {
                        
                        var senderUserName = "Unknown User"
                            
                            if let username = pfObjects[0]["senderUserName"] as? String {
                            
                            senderUserName = username
                                
                                
                            }
                        
                            if #available(iOS 8.0, *) {
                                let alert = UIAlertController(title: "You have a message" , message:"Message from "  +  senderUserName , preferredStyle: UIAlertControllerStyle.Alert)
                                                      alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) in
                                                        
                          let backgroundView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                               backgroundView .backgroundColor = UIColor.blackColor()
                               backgroundView.tag = 10
                               backgroundView .alpha = 0.8
                               backgroundView .contentMode = UIViewContentMode.ScaleAspectFit
                                                        self.view.addSubview(backgroundView )
 
                                
                                let dysplayedImage = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                                    dysplayedImage.image = photo
                                    dysplayedImage.tag = 10
                                    dysplayedImage.contentMode = UIViewContentMode.ScaleToFill
                                    self.view.addSubview(dysplayedImage)
                                                        
                                      try?pfObjects[0].delete()
                                                        
                               _ = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector:Selector("hideMessage"), userInfo: nil, repeats: false)
                                                        
                            }))
                            
                            self.presentViewController(alert, animated: true, completion: nil)
                                
                            } else {
                                // Fallback on earlier versions
                            }


                        }
                    
                        
                })
                
            }         }
        } else {
            
            print("ne64o ne e nared")
        }
    }
    
    func hideMessage()  {
        
        for subview in self.view.subviews {
        
            if subview.tag == 10 {
            
             subview.removeFromSuperview()
                
            }
        
        }
    }
    override func viewDidLoad() {
          super.viewDidLoad()
        
        _ = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(UserTableViewController.checkForMessage), userInfo: nil, repeats: false)
        
        let query = PFUser.query()
        query?.whereKey("username", notEqualTo: (PFUser.currentUser()?.username)!)
        
        let users = try!query?.findObjects()
            
        
    
        for user in users! as! [PFUser] {
        
            usernames.append(user.username!)
        
         
        
        }
            
            tableView.reloadData()
     }
        
    
 
     
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

    cell.textLabel?.text = usernames[indexPath.row]

        return cell
    }
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        recipientUserName = usernames[indexPath.row]

         let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.Camera
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let imageToSend = PFObject(className: "pic")
        imageToSend["photo"] = PFFile(name:"photo.jpg", data:UIImageJPEGRepresentation(image, 0.5)!)
        imageToSend["senderUserName"] = PFUser.currentUser()?.username
        imageToSend["recipientUserName"] = recipientUserName
        let acl = PFACL()
        acl.publicReadAccess = true
        acl.publicWriteAccess = true
        
        imageToSend.ACL = acl
        
        imageToSend.saveInBackground()
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
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

  

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      
      
        
            PFUser.logOut()
            
        
        
        
    }


}
