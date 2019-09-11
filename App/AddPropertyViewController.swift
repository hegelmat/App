//
//  AddPropertyViewController.swift
//  App
//
//  Created by user158423 on 8/31/19.
//  Copyright © 2019 Stage. All rights reserved.
//

import Foundation
import Parse
import UIKit

class AddPropertyViewController: UIViewController {
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    
    //Initialise the imagePicker
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()   //to remove the keyboard
        //picking image from the library
        imagePicker.delegate = self
    }
    //IBOutlet variables
    @IBOutlet weak var type: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var status: UITextField!
    @IBOutlet weak var streetName: UITextField!
    @IBOutlet weak var streetNumber: UITextField!
    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var suburb: UITextField!
    @IBOutlet weak var noOfBedrooms: UITextField!
    @IBOutlet weak var noOfBathrooms: UITextField!
    @IBOutlet weak var surface: UITextField!
    
    
    @IBOutlet weak var propertyImageViewer: UIImageView!
    
    //IBA functions
    @IBAction func upLoadPropertyImage(_ sender: Any) {
        getImage()
    }
    
    @IBAction func saveProperty(_ sender: Any) {
        let property = PFObject(className:"Property")   //className
        property["houseType"] = self.type.text
        property["price"] = Int(self.price.text ?? "")
        property["propertyDetailsID"] = self.setPropertyDetails()
        property["addressID"] = self.setAddress()
        
                
                
        property.pinInBackground() //save them locally first
        property.saveInBackground() //save them online after
        
       
        loadBrowsePropertiesScreen()
    }
    
    
    @IBAction func loadPreviousPage(_ sender: Any) {
        loadBrowsePropertiesScreen() 
    }
    
    //Navigation
    func loadHomeScreen(){     //loggedInVC is the homescreen
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInViewController = storyBoard.instantiateViewController(withIdentifier: "LoggedInViewController") as! LoggedInViewController
        self.present(loggedInViewController, animated: true, completion: nil)
    }
    func loadBrowsePropertiesScreen(){     //loggedInVC is the homescreen
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let browsePropertiesViewController = storyBoard.instantiateViewController(withIdentifier: "BrowsePropertiesViewController") as! BrowsePropertiesViewController
        self.present(browsePropertiesViewController, animated: true, completion: nil)
    }
    func loadLoginScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(viewController, animated: true, completion: nil)
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
    func setPropertyDetails() -> PFObject{
        let propertyDetails = PFObject(className: "PropertyDetails")
        propertyDetails["price"] = Int(self.price.text ?? "0")
        propertyDetails["noOfBathrooms"] = Int(self.noOfBathrooms.text ?? "0")
        propertyDetails["noOfBedrooms"] = Int(self.noOfBedrooms.text ?? "0")
        propertyDetails["surface"] = Int(self.surface.text ?? "0")
        propertyDetails["propertyPicturesID"] = self.setPropertyPictures() //store the object in this pointer
        propertyDetails.saveInBackground {
            (success: Bool, error: Error?) in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
        return propertyDetails
    }
    func setPropertyPictures()-> PFObject {  //check if the imageViewwer is nil next time
        let propertyPictures = PFObject(className: "PropertyPictures")
        if propertyImageViewer.image != nil{
           let imageData:NSData? = self.propertyImageViewer.image!.pngData() as NSData?
           let imageFile = PFFileObject(name:"pp.png", data:imageData! as Data)
           propertyPictures["picture1"] = imageFile
           //propertyPictures["picture2"] = ""
          //propertyPictures["picture3"] = ""
           propertyPictures.saveInBackground {
              (success: Bool, error: Error?) in
              if (success) {
                // The object has been saved.
              } else {
                // There was a problem, check error.description
              }
           }
        }
        return propertyPictures
    }
    func setAddress()-> PFObject {
        let address = PFObject(className: "Address")
        address["streetNumber"] = Int(self.streetNumber.text ?? "0")
        address["streetName"] = self.streetName.text ?? ""
        address["suburb"] = self.suburb.text ?? ""
        address["postCode"] = Int(self.zipCode.text ?? "0")
        address.saveInBackground {
            (success: Bool, error: Error?) in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
        return address
    }
    func getImage(){  //Get the image from the library
        imagePicker.sourceType =  .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
}
extension AddPropertyViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            propertyImageViewer.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
}

