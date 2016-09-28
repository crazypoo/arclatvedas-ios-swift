//
//  MatosCell.swift
//  arclatvedas
//
//  Created by divol on 27/04/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import UIKit

class MatosCell: UITableViewCell {
      @IBOutlet weak var matos: UILabel!
      @IBOutlet weak var serialnumber: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
