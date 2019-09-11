//
//  PropertiesCell.swift
//  App
//
//  Created by user158423 on 9/7/19.
//  Copyright © 2019 Stage. All rights reserved.
//

import UIKit
import Parse

class PropertiesCell: UITableViewCell {
    
    @IBOutlet weak var propertyPicture: UIImageView!
    
    @IBOutlet weak var streetName: UILabel!
    
    @IBOutlet weak var suburb: UILabel!
    
    @IBOutlet weak var noOfBathrooms: UILabel!
    
    @IBOutlet weak var noOfBedrooms: UILabel!
    
    func setProperty(_ object : PFObject){
        
       // propertyPicture.image = object[]
        self.streetName.text = object["price"] as? String
        self.suburb.text = object["houseType"] as? String
        print("property values here")
        print(self.streetName as Any, self.suburb as Any)
    }
}
