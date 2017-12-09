//
//  Origin.swift
//  PinIT
//
//  Created by Rahul Dhiman on 06/12/17.
//  Copyright © 2017 Rahul Dhiman. All rights reserved.
//

import UIKit

class Origin: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    func data(response :@escaping(_ error:String?)->()){
        studentData(resp: {
            error in
            response(error)
        })
    }
    
    func postVC(){
        if AllOverData.login.objId != ""
        {
            DispatchQueue.main.async {
                
                self.alert(message: " Overwrite Location ? ", rahul: {
                    
                    let control = self.storyboard?.instantiateViewController(withIdentifier: "post") as! PostViewController
                    //control.update = true
                    self.present(control, animated: true, completion: nil)
                    
                })
            }
        }
        else
        {
            
            gotoPost()
            
        }
        
        
    }
    
    func alert(message:String,rahul:@escaping ()->()){
        DispatchQueue.main.async {
            
            
            let alertview = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alertview.addAction(UIAlertAction(title: "Add New ", style: .default, handler: {
                a in
                self.gotoPost()
            }))
            alertview.addAction(UIAlertAction(title: "Overwrite", style: .default, handler:{
                a in
                rahul()
            }))
            
            self.present(alertview, animated: true, completion: nil)
        }
        
        
    }
    
    private func gotoPost()
    {
        let control = self.storyboard?.instantiateViewController(withIdentifier: "post") as! PostViewController
        self.present(control, animated: true, completion: nil)
        
    }
    
    func LoggingOut(){
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()

        dismiss(animated: true, completion: nil)
}
    
}
    
    

