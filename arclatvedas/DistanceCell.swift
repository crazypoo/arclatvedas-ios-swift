//
//  DistanceCell.swift
//  arclatvedas
//
//  Created by divol on 27/04/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import UIKit
import CoreDataProxy

class DistanceCell: UITableViewCell ,UITableViewDataSource,UITableViewDelegate{
    
 @IBOutlet weak var nom: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureView() {
        
    }

    
    
    
    //MARK: tabledatasource
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath)-> CGFloat{
        return 40
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("basicDistance", forIndexPath: indexPath) as! UITableViewCell
        
        
        let toto:NSArray
        
        toto = detailItem as! NSArray
        
        
        
      // let h:Hausse = toto[indexPath.row] as! Hausse
        for (var i = 0 ; i < toto.count ; i++){
            let h:Hausse = toto[i] as! Hausse
            var texte:String=""
            
            if indexPath.row == 0 {
                texte = h.name
            } else {
                texte =  h.hausse
            }
            let x = (30 * i)
            
            let rect = CGRect(x: x ,y: 9 ,width: 30, height:21)
            
            
            let label:UILabel = UILabel(frame: rect)
            label.text = texte
            label.textAlignment = .Center
            if i % 2 == 0 {
                label.backgroundColor = UIColor.whiteColor()

            }else {
                label.backgroundColor = UIColor.lightGrayColor()
            }
             if indexPath.row == 0 {
                label.textColor = UIColor.redColor()
            }
            
            cell.contentView.addSubview(label)
            
        }
        

        return cell;
    }

    
}
