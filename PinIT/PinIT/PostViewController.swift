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
    
    
    let vc = UIActivityIndicatorView()
    
    override func viewDidLoad() {
 
        super.viewDidLoad()
        enterlocation.delegate = self
        linkurl.delegate = self
        submit.isEnabled = false
        linkurl.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        self.view.frame.origin.y=0
        
        return true
    }
    
    
    
    @IBAction func pinIt(_ sender:Any){
        view.endEditing(true)
        if enterlocation.text == ""
        {
            alert(message: "Enter Valid Location",tryAgain: false, res: { })
            return
        }
        
        
        //  setUI(enable: true)
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        vc.activityIndicatorViewStyle = .gray
        vc.hidesWhenStopped=true
        vc.center=self.view.center
        vc.startAnimating()
        self.view.addSubview(vc)
        
        
        let searchrq=MKLocalSearchRequest()
        searchrq.naturalLanguageQuery=enterlocation.text
        
        
        let search=MKLocalSearch(request: searchrq)
        UIApplication.shared.endIgnoringInteractionEvents()
        search.start { (MKLocalSearchResponse, Error) in
            if MKLocalSearchResponse == nil
            {   self.vc.stopAnimating()
                self.alert(message: "No Internet Connection Or Not a Valid Location ",tryAgain: true,res: {
                    self.dismiss(animated: true, completion: nil)
                })
            }
            else
            {
                let coordinate=MKLocalSearchResponse?.boundingRegion.center
                //print(coordinate!.latitude)
                
                //print(coordinate!.longitude)
                
                
                let annotation=MKPointAnnotation()
                
                annotation.coordinate=coordinate!
                
                AllOverData.login.latitude1 = (coordinate?.latitude) ?? 0.0
                
                AllOverData.login.longitude1 = (coordinate?.longitude) ?? 0.0
                
               // print(AllOverData.login.longitude1)
               // print("sdjkfjd")
               // print(AllOverData.login.latitude1)
                
                annotation.title=self.enterlocation.text
                
                print("sdfsd")
                
                
                self.vc.stopAnimating()
                self.setUI(enable: true)
                
                self.mapview.addAnnotation(annotation)
                
                let span=MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                
                let region=MKCoordinateRegion(center: coordinate!, span: span)
                
                self.mapview.setRegion(region, animated: true)
               
                self.submit.isEnabled = true
                self.linkurl.isEnabled = true
            }
            
            
        }
        
    }
    

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

   
    @IBAction func submit(_ sender: Any) {
        AllOverData.login.url = enterlocation.text!
        if linkurl.text == ""
        {
            self.alert(message: "Enter Valid Link",tryAgain: false, res: { })
            return
            
        }
        vc.startAnimating()
        AllOverData.login.url = linkurl.text!
        if update == nil
        {
            UploadLocation(http: "POST",obj: nil,resp: response(e:))
            
        }
        else
        {
            UploadLocation(http: "PUT",obj: "\(AllOverData.login.objId)",resp:response(e:))
            
            
            
        }
       
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
