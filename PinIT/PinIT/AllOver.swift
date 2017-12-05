//
//  AllOver.swift
//  PinIT
//
//  Created by Rahul Dhiman on 05/12/17.
//  Copyright © 2017 Rahul Dhiman. All rights reserved.
//

import Foundation
import MapKit

struct AllOverData
{
    static var personInfo = [Student]()
    static var ann = [MKPointAnnotation]()
    static var login = Student()
    
    static func AddToCloud(person:Student,_ annotion:MKPointAnnotation? ){
        personInfo.append(person)
        
        if annotion != nil{
            ann.append(annotion!)
        }
        
    }
    
    func url(api: String?, para: [String: AnyObject]?=nil)->URL{
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
}
