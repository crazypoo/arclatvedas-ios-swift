//
//  ViewController.swift
//  cropcircles
//
//  Created by divol on 26/05/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import UIKit

class TargetController: UIViewController,DCDMagnifyingGlassViewDelegate {
var magnifyingView: DCDMagnifyingGlassView?
    var magnifyingViewVisible:Bool=false
    
    let tapGestureRecognizer = UITapGestureRecognizer()
    var cv:CircleView?
     var iv: ImpactView?
    
    
    override func loadView() {
        super.loadView()
        let r = self.view.frame
        let cote = min(self.view.frame.size.width,self.view.frame.size.height)
        let rect = CGRect(x: 0 ,y: 100 ,width: cote, height:cote)
        cv = CircleView(frame: rect)
        magnifyingViewVisible=false

        //Set up gesture recognizer
        
        tapGestureRecognizer.addTarget(self, action: "tapAction:")
        tapGestureRecognizer.enabled = true
        self.view.addGestureRecognizer(tapGestureRecognizer)

        self.view.addSubview(cv!)

        self.iv = ImpactView(frame: rect)
//        self.iv!.addPoint(CGPointMake(50,50))
//        self.iv!.addPoint(CGPointMake(100,100))
        self.view.addSubview(self.iv!)


        
        DCDMagnifyingGlassView.setTargetView(self.view)
        DCDMagnifyingGlassView.setScale(5)
        DCDMagnifyingGlassView.setContentFrame(CGRect(x: 115,y: 90,width: 100,height: 100))
        DCDMagnifyingGlassView.setIndicatorColor(UIColor.greenColor())
        DCDMagnifyingGlassView.setShadowColor(UIColor.redColor())
        DCDMagnifyingGlassView.sharedInstance.glassDelegate=self



    }
    
    func tapAction(sender: UITapGestureRecognizer) {
        
        magnifyingViewVisible = !magnifyingViewVisible
        
        let pt1:CGPoint = sender.locationOfTouch(0,inView: self.view)
        let pt2:CGPoint = sender.locationOfTouch(0,inView: self.iv)
        
        //pour etre sous le doigt
        DCDMagnifyingGlassView.setContentFrame(CGRect(x: pt1.x-50,y: pt1.y-50,width: 100,height: 100))
        
        if  magnifyingViewVisible  {
            DCDMagnifyingGlassView.show(true)
        } else {
            DCDMagnifyingGlassView.dismiss(true)
        }
        
        
        

        
    }

    func managePanBegin(sender: UIPanGestureRecognizer){
        
    }
    func managePanEnd(sender: UIPanGestureRecognizer){
        
        let pt2 = DCDMagnifyingGlassView.sharedInstance.indicatorView.center
        
         let pt3 = self.iv?.convertPoint(pt2, fromView: DCDMagnifyingGlassView.sharedInstance.indicatorView)

        self.iv!.addPoint(CGPointMake(pt3!.x-40,pt3!.y-40))
         DCDMagnifyingGlassView.dismiss(true)
        magnifyingViewVisible=false
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

