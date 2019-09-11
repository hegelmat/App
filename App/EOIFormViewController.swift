//
//  EOIFormViewController.swift
//  App
//
//  Created by user158423 on 9/6/19.
//  Copyright © 2019 Stage. All rights reserved.
//

import Foundation
import UIKit
import Parse


class EOIFormViewController: UIViewController {
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()   //to remove the keyboard
        let user = PFUser.current()
        self.userName.text = user?.username
        self.userEmail.text =  user?.email
        
    }
    //IBOutlet variables
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var data1: UITextField!
    @IBOutlet weak var data2: UITextField!
    @IBOutlet weak var data3: UITextField!
    @IBOutlet weak var data4: UITextField!
    //IBA functions
    @IBAction func loadPreviousPage(_ sender: Any) {
        loadBrowsePropertiesScreen()
    }
    @IBAction func loadNextPage(_ sender: Any) {
        loadHomeScreen()
    }
    
    @IBAction func saveForm(_ sender: Any){
        
        let eoiForm = PFObject(className: "EOIForm")
        eoiForm["userName"] = self.userName.text ?? "0"
        eoiForm["email"] = self.userEmail.text ?? "0"
        eoiForm["data1"] = self.data1.text ?? "0"
        eoiForm["data2"] = self.data2.text ?? "0"
        eoiForm["data3"] = self.data3.text ?? "0"
        eoiForm["data3"] = self.data4.text ?? "0"
        eoiForm.saveInBackground()
        loadBrowsePropertiesScreen()
    }
    
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
    func loadBrowsePropertiesScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let browsePropertiesViewController = storyBoard.instantiateViewController(withIdentifier: "BrowsePropertiesViewController") as! BrowsePropertiesViewController
        self.present(browsePropertiesViewController, animated: true, completion: nil)
    }
    func loadEOIFormScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let EOIFormViewController = storyBoard.instantiateViewController(withIdentifier: "EOIFormViewController") as! EOIFormViewController
        self.present(EOIFormViewController, animated: true, completion: nil)
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
    
}
