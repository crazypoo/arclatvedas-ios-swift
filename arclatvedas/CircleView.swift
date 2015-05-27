//
//  CircleView.swift
//  cropcircles
//
//  Created by divol on 26/05/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//


//https://github.com/c9dong/DCDMagnifyingGlassView


import UIKit

class CircleView: UIView {
    let colors = [UIColor.yellowColor(),UIColor.yellowColor(),UIColor.yellowColor(),UIColor.redColor(),UIColor.redColor(),UIColor.blueColor(),UIColor.blueColor(),UIColor.blackColor(),UIColor.blackColor(),UIColor.whiteColor(),UIColor.whiteColor()]
    let colorslines = [UIColor.blackColor(),UIColor.blackColor(),UIColor.blackColor(),UIColor.blackColor(),UIColor.whiteColor(),UIColor.whiteColor(),UIColor.whiteColor(),UIColor.whiteColor(),UIColor.blackColor(),UIColor.blackColor(),UIColor.blackColor()]

    
    
    //MARK: Constructors
    convenience init(){
        self.init(frame:CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.

  */
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        var pathck = UIBezierPath(rect: rect)
        UIColor.whiteColor().setFill()
        pathck.fill()
        
        let delta = (rect.size.width/20)
       var inrect = rect
        var lastgoodrect = rect
        var x=10
        do {
            var path = UIBezierPath(ovalInRect: inrect)
            colors[x].setFill()
            
           
            path.fill()
        
            colorslines[x].setStroke()
            path.lineWidth = 1.0
            path.stroke()
        
        x--
         inrect = CGRectInset(inrect,delta,delta)
        if x == 1{
            lastgoodrect = inrect
        }
        }while (x > -1)

        // and the X !
        
         inrect = CGRectInset(lastgoodrect,delta/2,delta/2)
        if !CGRectIsEmpty(inrect){
            var path = UIBezierPath(ovalInRect: inrect)
            colorslines[0].setStroke()
            path.lineWidth = 1.0
            path.stroke()

        }
        
    }


}
