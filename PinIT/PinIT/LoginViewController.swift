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
            
            self.TextField([self.username,self.password])
            self.UI()
            self.firstStep()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.TextField([self.username,self.password])
            self.UI()
        }
    }
    

    func firstStep(){
        getemail = username.center.x
        getpwd = password.center.x
        btn = loginbutton.center.x
        username.delegate = self
        password.delegate = self
        password.isSecureTextEntry = true
     
        
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
    
    func HH(notification: Notification) -> CGFloat {
        let information = (notification as NSNotification).userInfo
        let size = information![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return size.cgRectValue.height
    }
    
    @objc func up(notification: Notification) {
        if self.view.frame.origin.y >= 0
        {
            self.view.frame.origin.y -= self.HH(notification: notification) - 15
        }
    }
    
    @objc func down(notification: Notification) {
        
            self.view.frame.origin.y += self.HH(notification: notification) - 15
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        self.view.frame.origin.y=0
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.text = ""
        
       ///
        //
        //
        if username.isEditing || password.isEditing{
            subscribeToKeyboardNotifications()
        }
        else{
            unsubscribeFromKeyboardNotifications()
        }
    }
    
    
    @IBAction func loginButton(_ sender: Any)
         { if username.text == "" || password.text == ""
        {
            alert(message: "Please Enter The Details")
        }
        else
        {
            UISetup(enable: false)
            //validateLogin(name: name.text!, password: password.text!, responsee: responseAfterLogin(e:))
            Login()
            
            }
            
        }
        
    
    
    func LoginWork(error: String?){
        
        if error != nil {
            
            loginFailed()
            alert(message: error!)
        
        }
            
        else{
            
            DispatchQueue.main.async {
                self.UISetup(enable: true)
                self.Login()
            }
        }
    }

    func UI(){
        let tool = UIToolbar()
        let ok = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(Pin))
        tool.sizeToFit()
        tool.setItems([ok], animated: true)
        password.inputAccessoryView = tool
        
    }
    
    @objc  func Pin()
    { view.endEditing(true)
    }
    
    
    func TextField(_ textFields: [UITextField]) {
        
        for textField in textFields {
            
            let textFieldPaddingViewFrame = CGRect(x: 0.0, y: 0.0, width: 13.0, height: 0.0)
            let textFieldPaddingView = UIView(frame: textFieldPaddingViewFrame)
            textField.leftView = textFieldPaddingView
            textField.leftViewMode = .always
            textField.textColor = UIColor.black
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!,attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
            
        }
    }
    
    
    func Login()
    {
        UISetup(enable: true)
        let steer = storyboard?.instantiateViewController(withIdentifier: "tab") as! UITabBarController
        present(steer, animated: true, completion:  nil );
    }
    func loginFailed()
    {
        self.UISetup(enable: true)
    }
    
    
    func UISetup(enable:Bool)
    {
        self.username.isEnabled=enable
        self.password.isEnabled=enable
        self.loginbutton.isEnabled=enable
        if !enable
        {
            self.view.alpha = 0.3
        }
        else
        {
            self.view.alpha = 1.2
            
        }
        
    }
}

private extension LoginViewController{
  
    @objc func keyboardWillShow(_ notification:Notification) {
        
        
        view.frame.origin.y  -= getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        
    }
    
    
    
    func alert(message:String )
    {
        DispatchQueue.main.async {
            
            
            let alertview = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alertview.addAction(UIAlertAction(title: "Terminated!!!", style: .default, handler: {
                action in
                DispatchQueue.main.async {
                    
                    self.UISetup(enable: true)
                }
            }))
            self.present(alertview, animated: true, completion: nil)
        }
    }
    
    
}
    
    

