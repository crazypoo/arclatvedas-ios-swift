//
//  ImpactView.swift
//  cropcircles
//
//  Created by divol on 27/05/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import UIKit

class ImpactView: UIView {
    var impacts:[CGPoint] = []
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    */
    
    //MARK: Constructors
    convenience init(){
        self.init(frame:CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    func addPoint(pt :CGPoint){
        
        let t:CGAffineTransform = CGAffineTransformMakeScale(1.0 / self.frame.size.width, 1.0 / self.frame.size.height);
        let unipoint:CGPoint = CGPointApplyAffineTransform(pt, t);
        //we add normalized point here
        self.impacts.append(unipoint)
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.value), 0)) { // 1
            dispatch_async(dispatch_get_main_queue()) { // 2
                
                //this is needed otherwise ....
                self.setNeedsDisplay()
            }
        }
        
        
    }
    
    

    func removePoint(){
        
        self.impacts.removeLast()
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.value), 0)) { // 1
            dispatch_async(dispatch_get_main_queue()) { // 2
                
                //this is needed otherwise ....
                self.setNeedsDisplay()
            }
        }

        
    }
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        for (var i = 0 ; i < impacts.count ; i++){
            let pt = impacts[i]
            
            //points are normalized
            let t:CGAffineTransform = CGAffineTransformMakeScale( rect.size.width,  rect.size.height);
            let realpoint:CGPoint = CGPointApplyAffineTransform(pt, t);
            
            
            var inrect = CGRectMake(realpoint.x-2,realpoint.y-2,4,4)
            
            var path = UIBezierPath(ovalInRect: inrect)
            UIColor.blackColor().setFill()
            
            
            path.fill()
            
            UIColor.whiteColor().setStroke()
            path.lineWidth = 1.0
            path.stroke()
            
            
        }
        
        super.drawRect(rect)
    }
    
    
}
