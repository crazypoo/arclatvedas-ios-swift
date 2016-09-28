//
//  DistanceCellEdit.swift
//  arclatvedas
//
//  Created by divol on 29/04/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import UIKit

import CoreDataProxy

protocol resultDelegateProtocol {
    func resultChange(_ therow : Int , name:String , hausse : String)
}


class DistanceCellEdit: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var distance: UITextField!
    @IBOutlet weak var hausse: UITextField!
    var rowindice = -1
    var resultDelegate:resultDelegateProtocol! ;
    
   var datahausse: Hausse!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        distance.delegate = self
        
        hausse.delegate = self
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === distance {
            datahausse.name = distance.text!
        } else {
            
            if textField === hausse {
                datahausse.hausse = hausse.text!
            }
        }
        resultDelegate.resultChange(rowindice, name: distance.text!, hausse: hausse.text!)
    }
}
