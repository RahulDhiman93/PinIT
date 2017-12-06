//
//  TableView.swift
//  PinIT
//
//  Created by Rahul Dhiman on 06/12/17.
//  Copyright © 2017 Rahul Dhiman. All rights reserved.
//

import Foundation
import UIKit

class TableView:Origin,UITableViewDelegate,UITableViewDataSource
{
    
    @IBOutlet weak var Table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Table.delegate=self
        Table.dataSource=self
        
        notification()
        studentData(resp: {
            error in
            if error != nil
            {
                
                self.alert(message: error!)
            }
            
            
        })
        
    }
    
    func NoOfCell(en tableview:UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllOverData.personInfo.count
    }
    
    @IBAction func RefreshData(_ sender:Any){
        super.data(response: {
            error in
            if error != nil
            {
                self.alert(message: error!)
                
            }
            
            
        })
        
}

    
    @IBAction func AddLoc(_ sender:Any){
        super.postVC()
    }
    
    @IBAction func Logout(_ sender:Any){
        super.LoggingOut()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
       // cell.configureCell(person: AllOverData.personInfo[indexPath.row])
        
        
        return cell
    }
    
    @objc func reload()
    {
        DispatchQueue.main.async {
            
            
            self.Table.reloadData()
        }
    }
    func notification()
    {
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: Ckey.pinAdded) , object: nil)
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
    
    func ViewTable(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let url = AllOverData.personInfo[indexPath.row].link
        if let url = NSURL(string:  url) {
            if UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.open(url as URL)
            } else {
                alert(message: "Url passing Failed")
            }
            
            
            
        }
        
    }
    
    
}
