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
            
            self.navigationItem.title = NSLocalizedString(detail.valueForKey("name")!.description, comment:"data")
            
            if let web = self.web {
                let page :String = detail.valueForKey("url")!.description
                let request: NSURLRequest = NSURLRequest(URL: NSURL(string: page)!)
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

