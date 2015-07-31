//
//  CircleView.swift
//  cropcircles
//
//  Created by divol on 26/05/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//


//https://github.com/c9dong/DCDMagnifyingGlassView


import UIKit

protocol FaceViewDelegate:NSObjectProtocol {
    func getScoreForPoint(point:CGPoint)->CGPoint;
}

class BlasonView: UIView ,FaceViewDelegate {
     var nombrezone:Int {
        return 10
    }

    
    var scores:[Int] {
        return [100,10,9,8,7,6,5,4,3,2,1]
    }
    
    var colors:[UIColor] { return [UIColor.yellowColor(),UIColor.yellowColor(),UIColor.yellowColor(),UIColor.redColor(),UIColor.redColor(),UIColor.blueColor(),UIColor.blueColor(),UIColor.blackColor(),UIColor.blackColor(),UIColor.whiteColor(),UIColor.whiteColor()]}
    
    var colorslines:[UIColor] { return [UIColor.blackColor(),UIColor.blackColor(),UIColor.blackColor(),UIColor.blackColor(),UIColor.whiteColor(),UIColor.whiteColor(),UIColor.whiteColor(),UIColor.whiteColor(),UIColor.blackColor(),UIColor.blackColor(),UIColor.blackColor()]}
    
    // 3 cercles pour les trispots
    var circles:[[UIBezierPath]]=[[],[],[]]
    
    
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
    
    
    func getScoreForPoint(point:CGPoint)->CGPoint{
        var result:CGPoint = CGPointMake(0,0)
        var x=nombrezone
        do {
            let circle = circles[0][x]
            
            if circle.containsPoint(point) {
                result.x = CGFloat(scores[nombrezone-x])
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
        
        let delta:CGFloat = (rect.size.width / CGFloat(2 * nombrezone))
        var inrect = rect
        var lastgoodrect = rect
        var x=nombrezone
        do {
            var path = UIBezierPath(ovalInRect: inrect)
            
            if x !=  0{
                circles[0].append(path)
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
            if CGRectIsEmpty(inrect){
                break
            }
        }while (x > -1)
        
        // and the X !
        
        inrect = CGRectInset(lastgoodrect,delta/2,delta/2)
        if !CGRectIsEmpty(inrect){
            var path = UIBezierPath(ovalInRect: inrect)
            circles[0].append(path)
            
            colorslines[0].setStroke()
            path.lineWidth = 1.0
            path.stroke()
            
        }
        
    }
    
    
}
