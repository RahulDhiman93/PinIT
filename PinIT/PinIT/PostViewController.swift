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

    var update:Bool!
    
    @IBOutlet weak var enterlocation: UITextField!
    @IBOutlet weak var Pinit: UIButton!
    @IBOutlet weak var upperText: UITextView!
    @IBOutlet var linkurl: UITextField!
    @IBOutlet var mapview: MKMapView!
    @IBOutlet var submit: UIButton!
    
    
    
    
    override func viewDidLoad() {
 
        super.viewDidLoad()
        enterlocation.delegate = self
        linkurl.delegate = self
        submit.isEnabled = false
        linkurl.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        self.view.frame.origin.y=0
        
        return true
    }
    
    
    
    @IBAction func pinIt(_ sender:Any){
       
       
        
        if enterlocation.text == ""
        {
            alert(message: "Enter Valid Location",tryAgain: false, res: { })
            return
        }
        
        
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
       
        
        let rq=MKLocalSearchRequest()
        rq.naturalLanguageQuery=enterlocation.text
        
        
        let search=MKLocalSearch(request: rq)
        UIApplication.shared.endIgnoringInteractionEvents()
        search.start { (MKLocalSearchResponse, Error) in
            if MKLocalSearchResponse == nil
            {
                self.alert(message: "No Internet Connection Or Not a Valid Location ",tryAgain: true,res: {
                    self.dismiss(animated: true, completion: nil)
                })
            }
            else
            {
                guard let coor=MKLocalSearchResponse?.boundingRegion.center else{
                    return
                }
                
                let annotation1=MKPointAnnotation()
                
                annotation1.coordinate=coor
                annotation1.title=self.enterlocation.text
                self.mapview.addAnnotation(annotation1)
                
                AllOverData.login.latitude1 = (coor.latitude)
                AllOverData.login.longitude1 = (coor.longitude)
                
                self.setUI(enable: true)
                
                let span=MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region=MKCoordinateRegion(center: coor, span: span)
                self.mapview.setRegion(region, animated: true)
                
                self.submit.isEnabled = true
                self.linkurl.isHidden = false
                
               }
             }
           }
    

    @IBAction func cancel(_ sender: Any) {
        let editor = storyboard!.instantiateViewController(withIdentifier: "tab")
        present(editor, animated: true, completion: nil)
    }

   
    @IBAction func submit(_ sender: Any) {
        AllOverData.login.url = enterlocation.text!
        if update == nil
        {
            UploadLocation(http: "POST",obj: nil,resp: response(e:))
            
        }
        else
        {
            UploadLocation(http: "PUT",obj: "\(AllOverData.login.objId)",resp:response(e:))
            
            
            
        }
        let editor = storyboard!.instantiateViewController(withIdentifier: "tab")
        present(editor, animated: true, completion: nil)
    }
    
    func response(e error:String?)
    {
        
        if error == nil
        {
            self.dismiss(animated: true, completion: nil)
            DispatchQueue.main.async {
               
            }
        }
            
            
        else
        {   DispatchQueue.main.async {
            
            
            
            self.alert(message: error!, tryAgain: true, res: {
                self.dismiss(animated: true, completion: nil)
                
            })
            
            
            }
            
        }
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
            
            
        
            self.Pinit.isHidden=enable
            self.enterlocation.isHidden=enable
            
        }
    }
   

}
