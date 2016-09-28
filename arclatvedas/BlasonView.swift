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
    func getScoreForPoint(_ point:CGPoint)->CGPoint;
}

class BlasonView: UIView ,FaceViewDelegate {
     var nombrezone:Int {
        return 10
    }

    
    var scores:[Int] {
        return [100,10,9,8,7,6,5,4,3,2,1]
    }
    
    var colors:[UIColor] { return [UIColor.yellow,UIColor.yellow,UIColor.yellow,UIColor.red,UIColor.red,UIColor.blue,UIColor.blue,UIColor.black,UIColor.black,UIColor.white,UIColor.white]}
    
    var colorslines:[UIColor] { return [UIColor.black,UIColor.black,UIColor.black,UIColor.black,UIColor.white,UIColor.white,UIColor.white,UIColor.white,UIColor.black,UIColor.black,UIColor.black]}
    
    // 3 cercles pour les trispots
    var circles:[[UIBezierPath]]=[[],[],[]]
    
    
    //containsPoint
    
    //MARK: Constructors
    convenience init(){
        self.init(frame:CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    func getScoreForPoint(_ point:CGPoint)->CGPoint{
        var result:CGPoint = CGPoint(x: 0,y: 0)
        var x=nombrezone
        repeat {
            let circle = circles[0][x]
            
            if circle.contains(point) {
                result.x = CGFloat(scores[nombrezone-x])
                return result
                
            }
            x -= 1
        }while (x > -1)
        
        return result
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    */
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let pathck = UIBezierPath(rect: rect)
        UIColor.white.setFill()
        pathck.fill()
        
        let delta:CGFloat = (rect.size.width / CGFloat(2 * nombrezone))
        var inrect = rect
        var lastgoodrect = rect
        var x=nombrezone
        repeat {
            let path = UIBezierPath(ovalIn: inrect)
            
            if x !=  0{
                circles[0].append(path)
            }
            colors[x].setFill()
            
            
            path.fill()
            
            colorslines[x].setStroke()
            path.lineWidth = 1.0
            path.stroke()
            
            x -= 1
            inrect = inrect.insetBy(dx: delta,dy: delta)
            if x == 1{
                lastgoodrect = inrect
            }
            if inrect.isEmpty{
                break
            }
        }while (x > -1)
        
        // and the X !
        
        inrect = lastgoodrect.insetBy(dx: delta/2,dy: delta/2)
        if !inrect.isEmpty{
            let path = UIBezierPath(ovalIn: inrect)
            circles[0].append(path)
            
            colorslines[0].setStroke()
            path.lineWidth = 1.0
            path.stroke()
            
        }
        
    }
    
    
}
