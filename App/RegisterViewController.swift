//
//  RegisterViewController.swift
//  App
//
//  Created by user158423 on 8/13/19.
//  Copyright © 2019 Stage. All rights reserved.
//

import Foundation
import UIKit
import Parse


class RegisterViewController: UIViewController {
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    
    //IBOutlet variables
    @IBOutlet weak var signUpUsernameField: UITextField!
    var user_name = ""
    @IBOutlet weak var signUpEmailField: UITextField!
    var user_email = ""
    @IBOutlet weak var signUpPasswordField: UITextField!
    var user_password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()   //to remove the keyboard
        
        signUpUsernameField.text = user_name   //Initialize variables.Important for fcbk
        signUpPasswordField.text = user_password
        signUpEmailField.text = user_email
    }
    
    //IBA functions
    @IBAction func signUp(_ sender: Any) {
        //this is for back4app
        let user = PFUser()
        user.username = signUpUsernameField.text
        user.password = signUpPasswordField.text
        user.email = signUpEmailField.text
        print(user)
        //user.ACL = "Client"
       // user.email = signUpEmailField.text
        let sv = UIViewController.displaySpinner(onView: self.view)
        user.signUpInBackground { (success, error) in
            UIViewController.removeSpinner(spinner: sv)
            if success{
                //initialize local User class
                let userLocal = User(user.username ?? "", user.password ?? "", user.email ?? "")
                //pass local user user class to create the profile
                self.createUserProfile(userLocal,user)
                
                self.loadHomeScreen()     //load the homeScreeen
            }else{
                if let descrip = error?.localizedDescription{
                    self.displayErrorMessage(message: descrip)
                }
            }
        }
    }
    @IBAction func cancelSignUp(_ sender: Any) {//when the user press the cancel,Load VC
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func logoutOfApp(_ sender: UIButton) {
        let sv = UIViewController.displaySpinner(onView: self.view)
        PFUser.logOutInBackground { (error: Error?) in
            UIViewController.removeSpinner(spinner: sv)
            if (error == nil){
                self.loadLoginScreen()
            }else{
                if let descrip = error?.localizedDescription{
                    self.displayMessage(message: descrip)
                }else{
                    self.displayMessage(message: "error logging out")
                }
            }
        }
    }
    
    func loadHomeScreen(){     //loggedInVC is the homescreen
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInViewController = storyBoard.instantiateViewController(withIdentifier: "LoggedInViewController") as! LoggedInViewController
        self.present(loggedInViewController, animated: true, completion: nil)
    }
    func displayErrorMessage(message:String) {
        let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
       //appDelegate?.startPushNotifications()
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
    
    func createUserProfile(_ userLocal: User, _ user: PFUser){
        //This class create a user profile when the user sign up.
        //for local UserProfileClass
        _ = Profile(userLocal)  //create a local profile class USINF
        
        //for back4App . Take data from profileLocal
        let profile = PFObject(className: "Profile")
        profile["userStatus"] = "Client"
        profile["userID"] = user      //userID links USER and PROFILE CLASSES( FK)
        profile.saveInBackground { (succeeded, error)  in
            if (succeeded) {
                // The object has been saved.
                print("Object saved")
            } else {
                // There was a problem, check error.description
                print("Object not saved")
            }
        }
        
    }
   
}

