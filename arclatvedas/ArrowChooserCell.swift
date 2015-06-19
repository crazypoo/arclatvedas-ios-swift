//
//  ArrowChooserCell.swift
//  arclatvedas
//
//  Created by divol on 18/06/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import UIKit

import CoreData
import CoreDataProxy

class ArrowChooserCell: UITableViewCell {
    @IBOutlet weak var texte: UITextView!
    
    var arrow:SpinFleche?{
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    func configureView() {
        if let fleche = arrow {
        
         if let detail = self.texte {
        //    NSLog(fleche.grain.description)
            detail.text = String(stringInterpolation: "Modele: ","\(fleche.modele)\n","nom: \(fleche.name)\n", "Grain: ","\(fleche.grain) ","Spin: ","\(fleche.spin) ","Taille: ","\(fleche.taille)\n","Fabricant: ","\(fleche.fabricant)\n")
        }
        }
        
    }

    
//    @NSManaged public var modele: String
//    @NSManaged public var name: String
//    @NSManaged public var surname: String
//    @NSManaged public var grain: NSNumber
//    @NSManaged public var spin: String
//    @NSManaged public var diametreoutside: NSNumber
//    @NSManaged public var taille: NSNumber
//    @NSManaged public var fabricant: String
//    @NSManaged public var groupsofarrow: NSMutableOrderedSet

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
