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
        self.view.alpha = 0.6
        UIApplication.shared.beginIgnoringInteractionEvents()
        logoutMessC{ error in
            if error == nil{
                let ctrl = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
                self.present(ctrl, animated: true, completion: {
                    self.view.alpha = 1
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                })
            }
            else{
        
                let AV = UIAlertController(title: "", message: error!, preferredStyle: .alert)
                AV.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {
                    action in
                    
                    self.view.alpha = 1
                }))
                DispatchQueue.main.async {
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.present(AV, animated: true, completion: nil)
                }
        
            }
    }
    

}
}
