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
    
    let scores = [100,10,9,8,7,6,5,4,3,2,1]
    
    let colors = [UIColor.yellowColor(),UIColor.yellowColor(),UIColor.yellowColor(),UIColor.redColor(),UIColor.redColor(),UIColor.blueColor(),UIColor.blueColor(),UIColor.blackColor(),UIColor.blackColor(),UIColor.whiteColor(),UIColor.whiteColor()]
    
    let colorslines = [UIColor.blackColor(),UIColor.blackColor(),UIColor.blackColor(),UIColor.blackColor(),UIColor.whiteColor(),UIColor.whiteColor(),UIColor.whiteColor(),UIColor.whiteColor(),UIColor.blackColor(),UIColor.blackColor(),UIColor.blackColor()]
    
    var circles:[UIBezierPath]=[]
    
    
    //containsPoint
    
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
    
    
    func getScoreForPoint(point:CGPoint)->Int{
        var result:Int = 0
        var x=10
        do {
            let circle = circles[x]
            
            if circle.containsPoint(point) {
                result = scores[10-x]
                return result
                
            }
            x--
        }while (x > -1)
        
        return result
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
            if x !=  0{
                circles.append(path)
            }
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
            circles.append(path)
            
            colorslines[0].setStroke()
            path.lineWidth = 1.0
            path.stroke()
            
        }
        
    }
    
    
}
