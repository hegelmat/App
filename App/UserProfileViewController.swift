//
//  UserProfileViewController.swift
//  App
//
//  Created by user158423 on 8/28/19.
//  Copyright © 2019 Stage. All rights reserved.
//

import Foundation
import UIKit
import Parse

class UserProfileViewController: UIViewController {
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameValue: UILabel!
    @IBOutlet weak var userStatusValue: UILabel!
    @IBOutlet weak var budgetValue: UILabel!
    
    
    //Get current user variables
    let currentUser = PFUser.current()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()   //to remove the keyboard
        
        //initialize User data
        nameValue.text = currentUser?.username ?? "No name";
        
        // Query the object in the background
        let query = PFQuery(className:"Profile")
        query.fromLocalDatastore()
        query.whereKey("userID", equalTo: currentUser ?? "")
        query.getFirstObjectInBackground{(object: PFObject?, error:Error?) in
            if let error = error {
                // There was an error.
                print(error.localizedDescription)
            } else if let object = object{
                self.budgetValue.text = "\(String(describing: object["budget"] as! Int))"
                self.userStatusValue.text = object["userStatus"] as? String
                print(object["budget"] as! Int)
                //to display the picture
                if object["picture"] != nil {
                    let imageFile = object["picture"] as! PFFileObject
                    imageFile.getDataInBackground { (imageData: Data?, error: Error?) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else if let imageData = imageData {
                            let image = UIImage(data:imageData)
                            self.profilePicture.image = image
                        }
                    }
                    
                }
                
            }
            
           
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        //appDelegate?.startPushNotifications()
    }
    
    @IBAction func editProfile(_ sender: Any) {
        loadEditProfileScreen()
    }
    @IBAction func properties(_ sender: Any) {
       // loadBrowsePropertiesScreen()
        loadPropertiesScreen()
    }
    @IBAction func deleteAccount(_ sender: Any) {
        PFUser.current()?.deleteInBackground()
        //needs to delete profile as well
        loadLoginScreen()
    }
    @IBAction func logout(_ sender: Any) {
        PFUser.logOut()
        loadLoginScreen()
    }
    func displayMessage(message:String) {
        let alertView = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
    }
    func loadLoginScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(viewController, animated: true, completion: nil)
    }
    func loadEditProfileScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInViewController = storyBoard.instantiateViewController(withIdentifier: "LoggedInViewController") as! LoggedInViewController
        self.present(loggedInViewController, animated: true, completion: nil)
    }
    func loadBrowsePropertiesScreen(){  //MyDashboardScreen
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let browsePropertiesViewController = storyBoard.instantiateViewController(withIdentifier:"BrowsePropertiesViewController") as! BrowsePropertiesViewController
        self.present(browsePropertiesViewController, animated: true, completion: nil)
    }
    func loadPropertiesScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let propertiesViewController = storyBoard.instantiateViewController(withIdentifier:"PropertiesViewController") as! PropertiesViewController
        self.present(propertiesViewController, animated: true, completion: nil)
    }
}
