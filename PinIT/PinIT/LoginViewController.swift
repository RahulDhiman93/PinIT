//
//  LoginViewController.swift
//  PinIT
//
//  Created by Rahul Dhiman on 25/11/17.
//  Copyright © 2017 Rahul Dhiman. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox


class LoginViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginbutton: UIButton!
    
    
    var getemail:CGFloat!
    var getpwd:CGFloat!
    var btn:CGFloat!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            //code here
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            //code here
        }
    }
    

    func firstStep(){
        getemail = username.center.x
        getpwd = password.center.x
        btn = loginbutton.center.x
        username.delegate = self
        password.delegate = self
        password.isSecureTextEntry = true
        
        //code here
        
        
    }
    
    func design(){
        username.center.x+=10
        password.center.x+=10
        loginbutton.center.x+=10
        UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: .autoreverse , animations: {
            self.username.center.x-=20
            self.password.center.x-=20
            self.loginbutton.center.x-=20
            
        },completion: { a in
            
            UIView.animateKeyframes(withDuration: 0.1, delay: 0, options: .beginFromCurrentState, animations: {
                
                self.username.center.x=self.getemail
                self.password.center.x=self.getpwd
                self.loginbutton.center.x=self.btn
                
            }, completion: nil)
            
        })
           AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
    }
    
    

}
