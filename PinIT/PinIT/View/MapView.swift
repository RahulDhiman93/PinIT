//
//  MapView.swift
//  PinIT
//
//  Created by Rahul Dhiman on 06/12/17.
//  Copyright © 2017 Rahul Dhiman. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Map:Origin,MKMapViewDelegate
{
    
    
    @IBOutlet weak var mapKit:MKMapView!
    
    var pin = [MKPointAnnotation]()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mapKit.delegate=self
        notification()
        studentData(resp: {
            error in
            if error != nil
            {
                
                self.alert(message: error!)
            }
            
            
        })
    }
    
    @objc func PinDown()
    {
        
        if !AllOverData.ann.isEmpty
        {
            DispatchQueue.main.async {
                self.pin = AllOverData.ann
                self.mapKit.removeAnnotations(self.mapKit.annotations)
                self.mapKit.addAnnotations(self.pin)
            }
        }
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    func notification()
    {
        
        NotificationCenter.default.addObserver(self, selector: #selector(PinDown), name: NSNotification.Name(rawValue: Ckey.pinAdded) , object: nil)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        if control == view.rightCalloutAccessoryView {
            let url:NSString = ( view.annotation?.subtitle)!! as NSString
            let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
            
            if let URL = NSURL(string:  urlStr as String)
            {
                if UIApplication.shared.canOpenURL(URL as URL) {
                    UIApplication.shared.open(URL as URL)
                }
                else {
                    alert(message:"URL problem")
                }
            }
            
            
        }
        
        
        
    }
    
    func alert(message:String )
    {
        DispatchQueue.main.async {
            
            
            let alertview = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alertview.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {
                action in
                
            }))
            self.present(alertview, animated: true, completion: nil)
        }
    }
 
    @IBAction func refreshData(_ sender:Any){
        super.data(response: {
            error in
            if error != nil
            {
                self.alert(message: error!)
                
            }
            
            
        })
    }
    
    @IBAction func pinit(_ sender:Any){
        super.postVC()
    }
    
    @IBAction func loggingout(_ sender:Any){
        super.LoggingOut()
    }
    
    
    
}
