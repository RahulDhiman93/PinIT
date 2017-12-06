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

func verifyLogin(username:String, password:String, resp:@escaping (_ error:String?)->()){
    
    let rqst = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
    rqst.httpMethod = "POST"
    rqst.addValue("application/json", forHTTPHeaderField: "Accept")
    rqst.addValue("application/json", forHTTPHeaderField: "Content-Type")
    rqst.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
    
    
    let session = URLSession.shared
    
    let task = session.dataTask(with: rqst as URLRequest){data,response,error in
        if error != nil{
            DispatchQueue.main.async {
                
                resp(  error?.localizedDescription)
            }
            return
        }
        
        let range = Range(5..<data!.count)
        let InitData = data?.subdata(in: range)
        (NSString(data: InitData!, encoding: String.Encoding.utf8.rawValue)!)
        
        do{
            let datta = try JSONSerialization.jsonObject(with: InitData!, options: .allowFragments) as! [String:Any]
           if (datta["status"] as? Double) != nil
           {
            
            DispatchQueue.main.async {
                
                resp("Invalid Details")
            }
            return
        }
           else{
            let Dic = datta["account"] as! [String:Any]
            AllOverData.login.key = Dic["key"] as! String
            let url = URL(string :"https://www.udacity.com/api/users/\(AllOverData.login.key)")
            var rqstURL = URLRequest(url: url!)
            rqstURL.addValue(CValue.parseAppId, forHTTPHeaderField: Ckey.parseAppId)
            rqstURL.addValue(CValue.X_Parse_API, forHTTPHeaderField: Ckey.X_Parse_API)
            rqstURL.addValue("application/json", forHTTPHeaderField: "Accept")
            rqstURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession.shared
            let task = session.dataTask(with: rqstURL, completionHandler: {(Data1,responseData,error) in
                
            let range = Range(5..<Data1!.count)
            let InitData = Data1?.subdata(in: range)
                do{
                    let apidata = try JSONSerialization.jsonObject(with: InitData!, options: .allowFragments   ) as! [String : Any]
                    if let userdata = apidata["user"] as? [String:Any] ,let firstname = userdata["first_name"]  as? String , let lastname = userdata["last_name"] as? String
                    {
                        AllOverData.login.firstName=firstname
                        AllOverData.login.lastName=lastname
                        
                        DispatchQueue.main.async {
                            resp(nil)
                        }
                    }
                        
                    else
                    {     DispatchQueue.main.async {
                        resp("error in logging in") }
                        return
                    }
                
                }
                catch{
                    DispatchQueue.main.async {
                        resp("error in logging in ")
                    }
                    
                }
            
            
            })
            task.resume()
            
            }
    }
        catch{
            
        }
}
    task.resume()
}



