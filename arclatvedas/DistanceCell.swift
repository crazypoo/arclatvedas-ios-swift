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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureView() {
        
    }

    
    
    
    //MARK: tabledatasource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)-> CGFloat{
        return 40
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicDistance", for: indexPath) 
        
        
        let toto:NSArray
        
        toto = detailItem as! NSArray
        
        
        
      // let h:Hausse = toto[indexPath.row] as! Hausse
        for i in 0 ..< toto.count {
            let h:Hausse = toto[i] as! Hausse
            var texte:String=""
            
            if (indexPath as NSIndexPath).row == 0 {
                texte = h.name
            } else {
                texte =  h.hausse
            }
            let x = (30 * i)
            
            let rect = CGRect(x: x ,y: 9 ,width: 30, height:21)
            
            
            let label:UILabel = UILabel(frame: rect)
            label.text = texte
            label.textAlignment = .center
            if i % 2 == 0 {
                label.backgroundColor = UIColor.white

            }else {
                label.backgroundColor = UIColor.lightGray
            }
             if (indexPath as NSIndexPath).row == 0 {
                label.textColor = UIColor.red
            }
            
            cell.contentView.addSubview(label)
            
        }
        

        return cell;
    }

    
}
