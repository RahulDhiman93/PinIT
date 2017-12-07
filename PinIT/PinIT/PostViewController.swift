//
//  PostViewController.swift
//  PinIT
//
//  Created by Rahul Dhiman on 06/12/17.
//  Copyright © 2017 Rahul Dhiman. All rights reserved.
//

import UIKit
import MapKit

class PostViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var enterlocation: UITextField!
    @IBOutlet weak var Pinit: UIButton!
    @IBOutlet weak var upperText: UITextView!
    
    
    
    
    override func viewDidLoad() {
 
        super.viewDidLoad()
        enterlocation.delegate = self
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        self.view.frame.origin.y=0
        
        return true
    }
    
    
    
    @IBAction func pinIt(_ sender:Any){
       
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        
        if enterlocation.text == ""{
            alert(message: "Enter Valid Location",tryAgain: true, res: { })
        }
        
       
        else{
        AllOverData.loc = self.enterlocation.text!
        let editor = storyboard!.instantiateViewController(withIdentifier: "locate")
        present(editor, animated: true, completion: nil)
        
        }
            
        }
    

    @IBAction func cancel(_ sender: Any) {
        
    }

    
    func alert(message:String, tryAgain: Bool  ,res:@escaping (()->()))
{
    DispatchQueue.main.async {
        
        
        let alertview = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertview.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {
            action  in
            res()
        }))
        if tryAgain
        {
            alertview.addAction(UIAlertAction(title: " Try again  ", style: .default, handler: { (UIAlertAction) in
                self.setUI(enable: false)
            }))
        }
        self.present(alertview, animated: true, completion: nil)
    }
}
    
    func setUI(enable:Bool){
        DispatchQueue.main.async {
            
            
            self.upperText.isHidden=enable
            self.Pinit.isHidden=enable
            self.enterlocation.isHidden=enable
            
        }
    }
   

}
