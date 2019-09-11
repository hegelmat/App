//
//  ActionButtonItem.swift
//  App
//
//  Created by user158423 on 9/4/19.
//  Copyright © 2019 Stage. All rights reserved.
//
import UIKit

public typealias ActionButtonItemAction = (ActionButtonItem) -> Void

open class ActionButtonItem: NSObject {
    
    /// The action the item should perform when tapped
    open var action: ActionButtonItemAction?
    
    /// Description of the item's action
    open var text: String {
        get {
            return self.label.text!
        }
        
        set {
            self.label.text = newValue
        }
    }
    /// View that will hold the item's button and label
    internal var view: UIView!
    
    /// Label that contain the item's *text*
    fileprivate var label: UILabel!
    
    /// Main button that will perform the defined action
    //fileprivate
    var button: UIButton!
    
    /// Image used by the button
    fileprivate var image: UIImage!
    
    /// Size needed for the *view* property presente the item's content
    fileprivate let viewSize = CGSize(width: 200, height: 35)
    
    /// Button's size by default the button is 35x35
    fileprivate let buttonSize = CGSize(width: 35, height: 35)
    
    fileprivate var labelBackground: UIView!
    fileprivate let backgroundInset = CGSize(width: 10, height: 10)
    
    /**
     :param: title Title that will be presented when the item is active
     :param: image Item's image used by the it's button
     */
    public init(title optionalTitle: String?, image: UIImage?) {
        super.init()
        
        self.view = UIView(frame: CGRect(origin: CGPoint.zero, size: self.viewSize))
        self.view.alpha = 0
        self.view.isUserInteractionEnabled = true
        self.view.backgroundColor = UIColor.clear
        
        self.button = UIButton(type: .custom)
        self.button.setTitle(optionalTitle, for: .normal)
        self.button.frame = CGRect(origin: CGPoint(x: self.viewSize.width - self.buttonSize.width, y: 0), size: buttonSize)
        self.button.layer.shadowOpacity = 1
        self.button.layer.shadowRadius = 2
        self.button.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.button.layer.shadowColor = UIColor.gray.cgColor
        self.button.addTarget(self, action: #selector(ActionButtonItem.buttonPressed(_:)), for: .touchUpInside)
       
        
        if let unwrappedImage = image {
            self.button.setImage(unwrappedImage, for: UIControl.State())
        }
        
        if let text = optionalTitle , text.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == false {
            self.label = UILabel()
            self.label.font = UIFont(name: "HelveticaNeue-Medium", size: 13)
            self.label.textColor = UIColor.darkGray
            self.label.textAlignment = .right
            self.label.text = text
            self.label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ActionButtonItem.labelTapped(_:))))
            self.label.sizeToFit()
            
            self.labelBackground = UIView()
            self.labelBackground.frame = self.label.frame
            self.labelBackground.backgroundColor = UIColor.white
            self.labelBackground.layer.cornerRadius = 3
            self.labelBackground.layer.shadowOpacity = 0.8
            self.labelBackground.layer.shadowOffset = CGSize(width: 0, height: 1)
            self.labelBackground.layer.shadowRadius = 0.2
            self.labelBackground.layer.shadowColor = UIColor.lightGray.cgColor
            
            // Adjust the label's background inset
            self.labelBackground.frame.size.width = self.label.frame.size.width + backgroundInset.width
            self.labelBackground.frame.size.height = self.label.frame.size.height + backgroundInset.height
            self.label.frame.origin.x = self.label.frame.origin.x + backgroundInset.width / 2
            self.label.frame.origin.y = self.label.frame.origin.y + backgroundInset.height / 2
            
            // Adjust label's background position
            self.labelBackground.frame.origin.x = CGFloat(130 - self.label.frame.size.width)
            self.labelBackground.center.y = self.view.center.y
            self.labelBackground.addSubview(self.label)
            
            // Add Tap Gestures Recognizer
            let tap = UITapGestureRecognizer(target: self, action: #selector(ActionButtonItem.labelTapped(_:)))
            self.view.addGestureRecognizer(tap)
            
            self.view.addSubview(self.labelBackground)
        }
        
        self.view.addSubview(self.button)
    }
    
    //MARK: - Button Action Methods
    @objc func buttonPressed(_ sender: UIButton){
        if let unwrappedAction = self.action {
            unwrappedAction(self)
        }
        if let text = sender.titleLabel?.text { //Addition of title to id the button
           // print(text)             //take actions based on the title
            if text == "Add Properties"{ //call the view from another place!
                print(text)
                
                let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let controller = storyBoard.instantiateViewController(withIdentifier: "ViewController") as? UINavigationController
                print(controller as Any)
                //set storyboard ID to your root navigationController.
                let vc = storyBoard.instantiateViewController(withIdentifier: "AddPropertyViewController") as? AddPropertyViewController
                print(vc as Any)
                // //set storyboard ID to viewController.
                controller?.setViewControllers([vc!], animated: true)
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                appDelegate?.window?.rootViewController = controller
                //controller!.present(vc!, animated: true, completion: nil)
                //  let browsePropertiesViewController = BrowsePropertiesViewController()
              //  browsePropertiesViewController.loadAddPropertyScreen()
                
                
                
            }
        }
    }
    
    //MARK: - Gesture Recognizer Methods
    @objc func labelTapped(_ gesture: UIGestureRecognizer) {
        if let unwrappedAction = self.action {
            unwrappedAction(self)
        }
        
    }
}
