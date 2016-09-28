//
//  WebViewController.swift
//  arclatvedas
//
//  Created by divol on 24/04/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var web: UIWebView!
    
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            
            let value = detail.value(forKey: "name") as! String
            self.navigationItem.title = NSLocalizedString(value, comment:"data")
            
            if let web = self.web {
                 let page = detail.value(forKey: "url") as! String
                //let page :String = value.description
                let request: URLRequest = URLRequest(url: URL(string: page)!)
                web.loadRequest(request)
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

