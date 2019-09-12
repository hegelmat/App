//
//  PropertiesViewController.swift
//  
//
//  Created by user158423 on 9/4/19.
//

import Foundation
import UIKit
import Parse


class PropertiesViewController: UIViewController {
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    
    //IBOutlet variables
    @IBOutlet weak var tableView: UITableView!
    
    //All property object
    var objects :[PFObject] = []
    
    //Used in the menu
    var actionButton: ActionButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()   //to remove the keyboard
        self.getMenu() //customized menu
          //get objects from the backend
        getProperties()
          //set delegate
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    //IBA functions
   
    
    
    //Navigation
    func loadHomeScreen(){     //loggedInVC is the homescreen
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInViewController = storyBoard.instantiateViewController(withIdentifier: "LoggedInViewController") as! LoggedInViewController
        self.present(loggedInViewController, animated: true, completion: nil)
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
    func getMenu (){
        let deleteImage = UIImage(named: "delete.png")!
        let addImage = UIImage(named: "add.png")!
        
        let add = ActionButtonItem(title: "Add Properties", image: addImage)
        add.action = { item in print("Add...") }
        add.action = { item in print("hello")}
        
        let remove = ActionButtonItem(title: "Delete Properties", image: deleteImage)
        remove.action = { item in print("Remove...") }
        
        actionButton = ActionButton(attachedToView: self.view, items: [add, remove])
        actionButton.action = { button in button.toggleMenu() }
        actionButton.setTitle("+", forState: UIControl.State())
        
        actionButton.backgroundColor = UIColor(red: 238.0/255.0, green: 130.0/255.0, blue: 34.0/255.0, alpha:1.0)
        
    }
    func getProperties(){
        let query = PFQuery(className:"Property")
        query.findObjectsInBackground{(objects: [PFObject]?, error:Error?) in
            if let error = error {
                // There was an error.
                print(error.localizedDescription)
            } else if let objects = objects{
                print(objects.count)
                //print(objects)
                
                //self.houseType.text = (objects[0]["houseType"] as! String)
                //self.price.text = "\(String(describing: objects[0]["price"] as! Int))"
                //print(objects[0])
                //self.getPropertyDetails(objects[0]["propertyDetailsID"] as! PFObject) //pass the object to get the details
                //self.getAddress(objects[0]["addressID"] as! PFObject) //pass the object to get the address details
            }
        }
    }
    /*
    func getPropertyDetails(_ propertyDetailsID : PFObject){
        let query1 = PFQuery(className :"PropertyDetails")
        query1.whereKey( "objectId", equalTo: propertyDetailsID.objectId ?? "")
        query1.getFirstObjectInBackground{(object: PFObject?, error:Error?) in
            if let error = error {
                // There was an error.
                print(error.localizedDescription)
            } else if let object = object{
                // self.noOfBedrooms.text = "\(String(describing: object["noOfBedrooms"] as! Int))"
               // self.noOfBathrooms.text = "\(String(describing: object["noOfBathrooms"] as! Int))"
               // self.surface.text = "\(String(describing: object["surface"] as! Int))"
                //to display the picture
                //self.getPropertyPictures(object["propertyPicturesID"] as! PFObject) //pass propertyPictures Pointer
            }
        }
    }
    func getPropertyPictures(_ propertyPicturesID : PFObject){
        let query2 = PFQuery(className :"PropertyPictures")
        query2.whereKey( "objectId", equalTo: propertyPicturesID.objectId ?? "")
        query2.getFirstObjectInBackground{(object: PFObject?, error:Error?) in
            if let error = error {
                // There was an error.
                print(error.localizedDescription)
            } else if let object = object{
                //to display the picture
                /*
                if object["picture1"] != nil {
                    let imageFile = object["picture1"] as! PFFileObject
                    imageFile.getDataInBackground { (imageData: Data?, error: Error?) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else if let imageData = imageData {
                            let image = UIImage(data:imageData)
                            //self.propertyPicture.image = image
                        }
                    }
                }
              */
            }
        }
    }
    func getAddress(_ addressID :PFObject){
        let query3 = PFQuery(className :"Address")
        query3.whereKey( "objectId", equalTo: addressID.objectId ?? "")
        query3.getFirstObjectInBackground{(object: PFObject?, error:Error?) in
            if let error = error {
                // There was an error.
                print(error.localizedDescription)
            } else if let object = object{
                /*
                self.streetNumber.text = "\(String(describing: object["streetNumber"] as! Int))"
                self.streetName.text = object["streetName"] as? String
                self.suburb.text = object["surburbName"] as? String
          */  }
        }
    }
 */
    
}

extension PropertiesViewController: UITableViewDataSource, UITableViewDelegate{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("You got  \(objects.count) objects")
        return objects.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(" in 2nd function of table view")
        let obj = objects[indexPath.row] //every time a cell appear, assign the property
        print("Well, I got these details \(obj)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertiesCell") as! PropertiesCell
        cell.setProperty(obj) //Set property details to cell
        print(cell)
        return cell
    }
}
