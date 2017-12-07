//
//  Post2ViewController.swift
//  PinIT
//
//  Created by Rahul Dhiman on 07/12/17.
//  Copyright © 2017 Rahul Dhiman. All rights reserved.
//

import UIKit
import MapKit


class Post2ViewController: UIViewController {

    @IBOutlet weak var link: UITextField!
    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var submit: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func submitIT(_ sender: Any) {
        
    }
    
    func setUI(enable:Bool){
        DispatchQueue.main.async {
            
            
            self.link.isHidden=enable
            self.mapview.isHidden=enable
            self.submit.isHidden=enable
            
        }
    }
    
    

}
