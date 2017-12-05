//
//  Networking.swift
//  PinIT
//
//  Created by Rahul Dhiman on 06/12/17.
//  Copyright © 2017 Rahul Dhiman. All rights reserved.
//

import Foundation
import UIKit
import MapKit

func studentData(resp:@escaping(_ error:String?)->()){
    
    let rqst = NSMutableURLRequest(url: URL(string:CUrl.studentsurl)!)
     rqst.addValue(CValue.parseAppId, forHTTPHeaderField: Ckey.parseAppId)
    rqst.addValue(CValue.X_Parse_API, forHTTPHeaderField: Ckey.X_Parse_API)
    
    
    let session = URLSession.shared
    let task = session.dataTask(with: rqst as URLRequest){ data,response,error in
        if error != nil {
            resp(error?.localizedDescription)
            return
        }
        
        do{
            let parsedata = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
            let jsondata = parsedata["results"] as! [[String:Any]]
            AllOverData.personInfo = [Student]()
            AllOverData.ann = [MKPointAnnotation]()
            
            for dataa in jsondata {
                let person = Student(obj: dataa)
                let anno = person.getMap()
                AllOverData.AddToCloud(person: person, anno)
            }
        }
        catch{
            
        }
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: Ckey.pinAdded)))

    }
    task.resume()
}


