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
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    func addPoint(_ pt :CGPoint){
        
        let t:CGAffineTransform = CGAffineTransform(scaleX: 1.0 / self.frame.size.width, y: 1.0 / self.frame.size.height);
        let unipoint:CGPoint = pt.applying(t);
        //we add normalized point here
        self.impacts.append(unipoint)
        
        DispatchQueue.global(qos:DispatchQoS.QoSClass.userInteractive).async { // 1
            DispatchQueue.main.async { // 2
                
                //this is needed otherwise ....
                self.setNeedsDisplay()
            }
        }
        
        
    }
    
    

    func removePoint(){
        
        self.impacts.removeLast()
        
        DispatchQueue.global(qos:DispatchQoS.QoSClass.userInteractive).async { // 1
            DispatchQueue.main.async { // 2
                
                //this is needed otherwise ....
                self.setNeedsDisplay()
            }
        }

        
    }
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        for i in 0 ..< impacts.count{
            let pt = impacts[i]
            
            //points are normalized
            let t:CGAffineTransform = CGAffineTransform( scaleX: rect.size.width,  y: rect.size.height);
            let realpoint:CGPoint = pt.applying(t);
            
            
            let inrect = CGRect(x: realpoint.x-2,y: realpoint.y-2,width: 4,height: 4)
            
            let path = UIBezierPath(ovalIn: inrect)
            UIColor.black.setFill()
            
            
            path.fill()
            
            UIColor.white.setStroke()
            path.lineWidth = 1.0
            path.stroke()
            
            
        }
        
        super.draw(rect)
    }
    
    
}
