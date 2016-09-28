//
//  DetailViewController.swift
//  arclatvedas
//
//  Created by divol on 23/04/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
             var value = detail.value(forKey: "name") as AnyObject
            self.navigationItem.title = value.description
            
            if let label = self.detailDescriptionLabel {
                value = detail.value(forKey: "timeStamp") as AnyObject
                label.text = value.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

