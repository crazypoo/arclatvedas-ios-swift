//
//  GlassView.swift
//  cropcircles
//
//  Created by divol on 27/05/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import UIKit

class ReticuleView: UIView {
    
    
    
    //MARK: Constructors
    convenience init(){
        self.init(frame:CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }
    
    
    
    func drawPlus(){
        
        //from http://www.raywenderlich.com/90690/modern-core-graphics-with-swift-part-1
        
        //set up the width and height variables
        //for the horizontal stroke
        let plusHeight: CGFloat = 3.0
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * 0.3
        
        //create the path
        let plusPath = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        plusPath.lineWidth = plusHeight
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        plusPath.move(to: CGPoint(
            x:bounds.width/2 - plusWidth/2 + 0.5,
            y:bounds.height/2 + 0.5))
        
        //add a point to the path at the end of the stroke
        plusPath.addLine(to: CGPoint(
            x:bounds.width/2 + plusWidth/2 + 0.5,
            y:bounds.height/2 + 0.5))
        
        //Vertical Line
        //move to the start of the vertical stroke
        plusPath.move(to: CGPoint(
            x:bounds.width/2 + 0.5,
            y:bounds.height/2 - plusWidth/2 + 0.5))
        
        //add the end point to the vertical stroke
        plusPath.addLine(to: CGPoint(
            x:bounds.width/2 + 0.5,
            y:bounds.height/2 + plusWidth/2 + 0.5))
        
        //set the stroke color
        UIColor.green.setStroke()
        
        //draw the stroke
        plusPath.stroke()
        
    }
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    */
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        // super.drawRect(rect)
        //        var pathck = UIBezierPath(rect: rect)
        //        UIColor.whiteColor().setFill()
        //        pathck.fill()
        
        drawPlus()
    }
    
    
}
