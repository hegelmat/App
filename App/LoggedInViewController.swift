//
//  LoggedInViewController.swift
//  App
//
//  Created by user158423 on 8/12/19.
//  Copyright © 2019 Stage. All rights reserved.
//


import UIKit
import Parse

class LoggedInViewController: UIViewController {
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    
   
    @IBOutlet weak var nameValue: UILabel!
    @IBOutlet weak var dobValue: UITextField!
    @IBOutlet weak var budgetValue: UITextField!
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var userStatusValue: UILabel!
    
    

    
    //GET Current User Object
    let currentUser = PFUser.current()
    
    //Initialise the imagePicker
    var imagePicker = UIImagePickerController()
    
    //When the user clicks upload
    @IBAction func uploadPicture(_ sender: Any) {
        getImage()
    }
    @IBAction func saveProfile(_ sender: Any) {
        //Get current user variables
        //Query to fetch user profile
        let query = PFQuery(className:"Profile")   //className
        query.whereKey("userID", equalTo: currentUser ?? "")   //userID stores User Object
        query.getFirstObjectInBackground { (object: PFObject?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if let object = object {
                // The find succeeded.update values here
                
                let imageData:NSData? = self.profilePicture.image!.pngData() as NSData?
                let imageFile = PFFileObject(name:"pp.png", data:imageData! as Data)
                object["picture"] = imageFile
                
                //for date
                if self.dobValue.text == nil {
                    //Error handling here
                }
                else{
                   // update online
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yyyy"
                    object["dob"] = formatter.date(from: self.dobValue.text ?? "01/01/1111")
                    }
                //for budget
                object["budget"] = Int(self.budgetValue.text ?? "0")
                object.pinInBackground() //save them locally first
                object.saveInBackground() //save them online after
                }
        }
        loadUserProfileScreen()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()   //to remove the keyboard
        //initiatiaze
        getUserStatus() //assign userStatus
        nameValue.text = currentUser?.username ?? "No name";
        
        
        //picking image from the library
        imagePicker.delegate = self
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        //appDelegate?.startPushNotifications()
    }
    
    @IBAction func deleteAccount(_ sender: Any) {
        PFUser.current()?.deleteInBackground()
        loadLoginScreen()
        }
    @IBAction func signOut(_ sender: Any) {
        print("User signed out successfully")
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
    //get the user status from profile table and display 
    func getUserStatus(){
        let query = PFQuery(className:"Profile")   //className
        query.whereKey("userID", equalTo: currentUser ?? "")   //userID stores User Object
        query.getFirstObjectInBackground { (object: PFObject?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if object != nil {
                self.userStatusValue.text = object!["userStatus"] as? String
            }
        }
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
    func loadUserProfileScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let userProfileViewController = storyBoard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        self.present(userProfileViewController, animated: true, completion: nil)
    }
    
    func displayPicture(_ imageFile: PFFileObject){
        
        imageFile.getDataInBackground { (imageData: Data?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let imageData = imageData {
                let image = UIImage(data:imageData)
                self.profilePicture.image = image
            }
         }
    }
    func getImage(){
        imagePicker.sourceType =  .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
}

//Just for the image
extension LoggedInViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            profilePicture.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
}
