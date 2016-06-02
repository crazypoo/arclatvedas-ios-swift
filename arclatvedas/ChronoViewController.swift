//
//  ChronoViewController.swift
//  arclatvedas
//
//  Created by Nicolas CHEVALIER on 4/11/16.
//  modified by divol on 01/06/2016.
//

import UIKit
import AVFoundation

class ChronoViewController: UIViewController,VPRangeSliderDelegate  {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timePreference: UISwitch!
    @IBOutlet weak var centerview:UIView!
    @IBOutlet weak var rangeSlider:VPRangeSlider!
    @IBOutlet weak var startstopButton:UIButton!
    
    var timer = NSTimer()
    var mincount = 10
    var maxcount = 30
    var count = 10
    var tapRecognizer: UITapGestureRecognizer!
    let beep = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bip", ofType: "wav")!)
    let doubleBeep = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bip2", ofType: "wav")!)
    let tripleBeep = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bip3", ofType: "wav")!)
    var audioPlayer =  AVAudioPlayer()
    
    
     func viewWillDisappear() {
         UIApplication.sharedApplication().idleTimerDisabled = false
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let app = UIApplication.sharedApplication()
        
        if  let mainwindow = app.delegate?.window {
            let splitViewController = mainwindow!.rootViewController as! UISplitViewController
            
            
            
            splitViewController.presentsWithGesture = false // SplitView won't recognize right swipe
            splitViewController.preferredDisplayMode = .PrimaryHidden
        }

        
        
        
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        self.tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChronoViewController.manageTimer))
        self.view.addGestureRecognizer(tapRecognizer)
        self.initViewWithValue(mincount, andColor: UIColor.redColor().colorWithAlphaComponent(0.70))
        
        timeLabel.font = UIFont(name: "DBLCDTempBlack", size: 60.0)
        
        timeLabel.textColor = UIColor.greenColor().colorWithAlphaComponent(0.70)
        timeLabel.backgroundColor = UIColor.blackColor()
        
        
        centerview.layer.cornerRadius = 10.0;
        centerview.layer.masksToBounds = true;
       
        
        self.updateLabel()
        
        
        
        self.rangeSlider.rangeDisplayLabelColor = UIColor.blackColor()
        
        self.rangeSlider.requireSegments = false
        self.rangeSlider.sliderSize = CGSizeMake(10, 10)
        self.rangeSlider.segmentSize = CGSizeMake(10, 10)
        
        self.rangeSlider.rangeSliderForegroundColor = UIColor.blackColor()
        self.rangeSlider.rangeSliderButtonImage = UIImage(named:"slider")
        self.rangeSlider.delegate=self
        
        
        let amax:CGFloat = self.timePreference.on ? 240.0 : 120.0
        
        
        
        self.rangeSlider.scrollStartSliderToStartRange(CGFloat(mincount) * 100.0 / amax,andEndRange: (amax-CGFloat(maxcount)) * 100.0 / amax)
        
        
        
        timePreference.addTarget(self, action: #selector(ChronoViewController.switchChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        
        
        
        startstopButton.titleLabel?.text="DÉBUT"
    }
    
    func playSound(file: NSURL) {
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: file)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            try AVAudioSession.sharedInstance().setActive(true)
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
            audioPlayer.play()
        } catch {
            print(error)
        }
    }
    
    func updateLabel() {
        self.timeLabel.text = "\(self.count)"
    }
    
    func initViewWithValue(value: Int, andColor color: UIColor) {
        count = value
        self.view.backgroundColor = color
    }
    
    func firstTimer() {
        count -= 1
        if (count <= 0) {count = 0}
        updateLabel()

        if (count == 0) {
            // Play sound
            playSound(doubleBeep)
            initViewWithValue(self.timePreference.on ? 240 : 120, andColor: UIColor.greenColor().colorWithAlphaComponent(0.70))
            updateLabel()
            timer.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ChronoViewController.timerAction), userInfo: nil, repeats: true)
        }
    }
    
    func manageTimer() {
        
        if ("STOP".compare((self.startstopButton.titleLabel?.text)!)==NSComparisonResult.OrderedSame){
            self.startstopButton.setTitle("DÉBUT", forState: UIControlState.Normal)
        }else{
            self.startstopButton.setTitle("STOP", forState: UIControlState.Normal)
        }
        
        if (timer.valid) {
            timer.invalidate()
            playSound(tripleBeep)
            initViewWithValue(mincount, andColor: UIColor.redColor().colorWithAlphaComponent(0.70))
            updateLabel()
            timePreference.enabled=true
            rangeSlider.partialyHide(false)
            
        } else {
            // Play sound
            playSound(beep)
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ChronoViewController.firstTimer), userInfo: nil, repeats: true)
            timePreference.enabled=false
            rangeSlider.partialyHide(true)

        }
    }
    
    func timerAction() {
        count -= 1
        if (count <= 0) {
            // Play sound
            playSound(tripleBeep)
            self.view.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.70)
            timer.invalidate()
            initViewWithValue(mincount, andColor: UIColor.redColor().colorWithAlphaComponent(0.70))
            self.startstopButton.setTitle("DÉBUT", forState: UIControlState.Normal)
            timePreference.enabled=true
            rangeSlider.partialyHide(false)


        } else if (count <= maxcount) {
            self.view.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.70)
        } else {
            self.view.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.70)
        }
        updateLabel()
    }
    
    
    //MARK: - VPRangeSliderDelegate
    // - (void)sliderScrolling:(VPRangeSlider *)slider withMinPercent:(CGFloat)minPercent andMaxPercent:(CGFloat)maxPercent
    func sliderScrolling(slider : VPRangeSlider, withMinPercent:CGFloat , andMaxPercent:CGFloat)
    {
        let amax:CGFloat = self.timePreference.on ? 240.0 : 120.0
        
        if ((withMinPercent * amax) / 100) < 1 {
            self.mincount=0
        }else {
            self.mincount = Int(round ((withMinPercent * amax) / 100) )
        }
        self.initViewWithValue(self.mincount, andColor: UIColor.redColor().colorWithAlphaComponent(0.70))
        updateLabel()
        
        self.maxcount = Int(round(amax - ((andMaxPercent * amax / 100))))
        self.rangeSlider.minRangeText = String(self.mincount)
        self.rangeSlider.maxRangeText = String(self.maxcount)
    }
    
    
    
    
    
    //MARK: - switchChanged
    func switchChanged(mySwitch: UISwitch) {
        let amax:CGFloat = self.timePreference.on ? 240.0 : 120.0
        if amax-CGFloat(maxcount) < 0 {
            maxcount = 30
        }
        self.rangeSlider.scrollStartSliderToStartRange(CGFloat(mincount) *  100.0 / amax,andEndRange: (amax-CGFloat(maxcount)) * 100.0 / amax)
        
        self.rangeSlider.slideRangeSliderButtonsIfNeeded();
    }
    
     //MARK: - startstop
    
    @IBAction func startStoppressed(sender: UIButton!){
       

        
        manageTimer()
    }
    
}