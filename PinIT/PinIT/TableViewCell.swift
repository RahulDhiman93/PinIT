//
//  TableViewCell.swift
//  PinIT
//
//  Created by Rahul Dhiman on 06/12/17.
//  Copyright © 2017 Rahul Dhiman. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var high: UILabel!
    @IBOutlet weak var low: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func ConfigCell(person:Student)
    {
        high.text = person.firstName + person.lastName
        low.text = person.url
       
    }

}
