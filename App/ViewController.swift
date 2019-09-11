//
//  ViewController.swift
//  App
//
//  Created by user158423 on 8/10/19.
//  Copyright © 2019 Stage. All rights reserved.
//

import UIKit
import Parse
import FacebookCore
import FacebookLogin
import FBSDKLoginKit
import FBSDKCoreKit


class ViewController: UIViewController {
    
    
    //Define all Outlets
    
    @IBOutlet weak var signInUsernameField: UITextField!
    
    @IBOutlet weak var signInPasswordField: UITextField!
    
    //USED FOR FACEBOOK, type dictionary [key:value]
    var dict : [String :AnyObject]!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()   //to remove the keyboard
        
        signInUsernameField.text=""   //Initialize variables
        signInPasswordField.text = ""
    }
    
    //Added funtion to check if the user is login already. Add this function when signout is working
   /*
    override func viewDidAppear(_ animated: Bool) {
        let currentUser = PFUser.current()
        if currentUser != nil {
            loadHomeScreen()
        }
    }
    */

    //@IBActions
    //when user presses Login with Facebook
    @IBAction func loginWithFacebook(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [ .publicProfile,.email ], viewController: self) {
            loginResult in
            switch loginResult {
            case.failed(let error):
                print(error)
            case.cancelled:
                print("User cancelled Login")
            case.success://(let grantedPermission, let declinedPermissions, _let accessToken):
                                        self.getFBUserData()  //fetch data from the user
                                       // print("After FBUSER")   //just for testing
                                        self.loadSignUpWithFacebookScreen()
            }
         }
     }
    //Fetching the User data
    func getFBUserData(){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name, picture.type(large)"]).start(completionHandler: { (connection, result , error)-> Void in
                if (error == nil){
                    self.dict = result as? [String : AnyObject]  //Modified from the original
                    
                }
            })
        }
    }
    
    //When User press SIGNUP
    
    @IBAction func loadSignUpScreen(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let registerViewController = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.present(registerViewController, animated: true, completion: nil)
    }
    
    
    //for signIn button 
    @IBAction func signIn(_ sender: Any) {
        let sv = UIViewController.displaySpinner(onView: self.view)
        PFUser.logInWithUsername(inBackground: signInUsernameField.text!, password: signInPasswordField.text!) { (user, error) in
            UIViewController.removeSpinner(spinner: sv)
            if user != nil {
                self.loadHomeScreen()
            }else{
                if let descrip = error?.localizedDescription{
                    self.displayErrorMessage(message: (descrip))
                }
            }
        }
    }
    
    func loadHomeScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInViewController = storyBoard.instantiateViewController(withIdentifier: "LoggedInViewController") as! LoggedInViewController
        
        self.present(loggedInViewController, animated: true, completion: nil)
    }
    func loadSignUpWithFacebookScreen() {    //Set username & email from facebook data
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let registerViewController = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
       //DispatchQueue.main.async {
              registerViewController.user_name = "hegelmat"
             //Array(self.dict.values)[2] as? String
              registerViewController.user_email = "hegelmat@gmail.com" //Array(self.dict.values)[0] as? String
       // }
        self.present(registerViewController, animated: true, completion: nil)
        
        
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
  
    
    
    
}

