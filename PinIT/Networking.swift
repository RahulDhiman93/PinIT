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

func RqstURL(api: String?, para: [String: AnyObject]?=nil)->URL{
    var cam = URLComponents()
    cam.scheme = "https"
    cam.host = "parse.udacity.com"
    cam.path = "/parse/classes"
        + (api ?? "")
    
    if let para = para {
        cam.queryItems = [URLQueryItem]()
        for(key, value) in para {
            let queryItem = URLQueryItem(name: key,value:"\(value)")
            cam.queryItems?.append(queryItem)
        }
    }
    return cam.url!
}

func PinLocation(rahul:@escaping ()->()){
    
    let PInURL = RqstURL(api: "/StudentLocation",para: [PKeys.Where:"{\"\(PKeys.uniqueKey)\":\"  " + "\(AllOverData.login.key)"  + "\"}" as AnyObject])
    
    let rqst = NSMutableURLRequest(url: PInURL)
    rqst.addValue(CValue.parseAppId, forHTTPHeaderField: Ckey.parseAppId)
    rqst.addValue(CValue.X_Parse_API, forHTTPHeaderField: Ckey.X_Parse_API)
    
    let session = URLSession.shared

    let task = session.dataTask(with: rqst as URLRequest){data,response,error in
        if error != nil{
            return
        }
        do{
            let metaData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
            let output = metaData["results"] as! [[String:Any]]
            if output.count == 0
            {
                DispatchQueue.main.sync {
                    
                    
                    rahul()
                }
            }
            else{
                DispatchQueue.main.sync{
                    AllOverData.login = Student(obj: output[0])
                    
                }
            }
        }
        catch{
            
        }
    }
    
    task.resume()
}

func UploadLocation(http:String, obj:String?, resp:@escaping (_ error :String?)->()){
    
    UIApplication.shared.beginIgnoringInteractionEvents()
    
    let rqst = NSMutableURLRequest(url : URL(string: "https://parse.udacity.com/parse/classes/StudentLocation\(obj ?? "")")!)
    rqst.addValue(CValue.parseAppId, forHTTPHeaderField: Ckey.parseAppId)
    rqst.addValue(CValue.X_Parse_API, forHTTPHeaderField: Ckey.X_Parse_API)
    rqst.addValue("application/json", forHTTPHeaderField: "Content-Type")
    rqst.httpBody = "{\"uniqueKey\": \"\(AllOverData.login.key)\", \"firstName\": \"\(AllOverData.login.firstName)\", \"lastName\": \"\(AllOverData.login.lastName)\",\"mapString\": \"\(AllOverData.login.mapLen)\", \"mediaURL\": \"\(AllOverData.login.url)\",\"latitude\": \(AllOverData.login.latitude1) , \"longitude\":  \(AllOverData.login.longitude1)}".data(using: String.Encoding.utf8)
    
    
    rqst.httpMethod =  http
    let session = URLSession.shared
    let task = session.dataTask(with: rqst as URLRequest) { data, response, error in
        
        if error != nil {
            UIApplication.shared.endIgnoringInteractionEvents()
            resp(error?.localizedDescription)
            return
        }
        
        let data = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
        if obj == nil
        {   UIApplication.shared.endIgnoringInteractionEvents()
            AllOverData.login.objId = data["objectId"] as! String
        }
        UIApplication.shared.endIgnoringInteractionEvents()
        resp(nil)
        
    }
    task.resume()
    
}


func logoutMessC(handler:@escaping (_ message : String?)->())
{
    let rqst = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
    rqst.httpMethod = "DELETE"
    var xsrfCookie: HTTPCookie? = nil
    let sharedCookieStorage = HTTPCookieStorage.shared
    for cookie in sharedCookieStorage.cookies! {
        if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
    }
    if let xsrfCookie = xsrfCookie {
        rqst.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
    }
    let session = URLSession.shared
    let task = session.dataTask(with: rqst as URLRequest) { data, response, error in
        if error != nil {
            handler( error?.localizedDescription)
            return
        }
        else{
            handler(nil)
        }
        let range = Range(5..<data!.count)
        let Oppo = data?.subdata(in: range) 
    }
    task.resume()
}
