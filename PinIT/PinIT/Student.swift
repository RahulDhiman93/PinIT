//
//  Student.swift
//  PinIT
//
//  Created by Rahul Dhiman on 05/12/17.
//  Copyright © 2017 Rahul Dhiman. All rights reserved.
//

import Foundation
import MapKit

struct Student
{
    var firstName = ""
    var lastName = ""
    var longitude1:Double = 0.0
    var latitude1:Double = 0.0
    var url = ""
    var key = ""
    var objId=""
    var mapLen = ""
    var link = ""
    
    init(key:String,name:String)
    {
    }
    
    init()
    {
    }
   
    init(obj:[String:Any]  ){
        
        self.firstName = "\(obj["firstName"] ?? "")"
        
        self.lastName =   "\(obj["lastName"] ?? "")"
        
        self.longitude1 = obj["longitude"] as? Double ?? 0
        
        self.latitude1 = obj["latitude"] as? Double ?? 0
        
        self.url = "\(obj["mediaURL"] ?? "") "
        
        self.objId = "\(obj["objectId"]  ?? "")"
        
        self.mapLen = "\(obj["mapString"] ?? "")"
        
        self.link = "\(obj["mediaURL"] ?? "")"
    }
    
    func getMap()->MKPointAnnotation{
        let ann = MKPointAnnotation()
        let coor = CLLocationCoordinate2D(latitude:latitude1,longitude:longitude1)
        ann.coordinate = coor
        ann.title = self.firstName + self.lastName
        ann.subtitle = self.url
        return ann
    }
}
