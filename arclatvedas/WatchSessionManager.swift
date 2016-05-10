//
//  WatchSessionManager.swift
//  arclatvedas
//
//  Created by divol on 03/05/2016.
//  Copyright © 2016 jack. All rights reserved.
//

//
//  WatchSessionManager.swift
//  WCApplicationContextDemo
//
//  Created by Natasha Murashev on 9/22/15.
//  Copyright © 2015 NatashaTheRobot. All rights reserved.
//

import WatchConnectivity
import CoreData
import CoreDataProxy


protocol DataSourceChangedDelegate {
    func dataSourceDidUpdate(userInfo: [String : AnyObject])
}


//@available(iOS 9.0, *)
class WatchSessionManager: NSObject, WCSessionDelegate {
    
    static let sharedManager = WatchSessionManager()
    private override init() {
        super.init()
    }
    private var dataSourceChangedDelegates = [DataSourceChangedDelegate]()
    private let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    private var validSession: WCSession? {
        
        // paired - the user has to have their device paired to the watch
        // watchAppInstalled - the user must have your watch app installed
        
        // Note: if the device is paired, but your watch app is not installed
        // consider prompting the user to install it for a better experience
        
        if let session = session where session.paired && session.watchAppInstalled {
            return session
        }
        return nil
    }
    
    func startSession() {
        session?.delegate = self
        session?.activateSession()
    }
    
    
    func addDataSourceChangedDelegate<T where T: DataSourceChangedDelegate, T: Equatable>(delegate: T) {
        dataSourceChangedDelegates.append(delegate)
    }
    
    func removeDataSourceChangedDelegate<T where T: DataSourceChangedDelegate, T: Equatable>(delegate: T) {
        for (index, dataSourceDelegate) in dataSourceChangedDelegates.enumerate() {
            if let dataSourceDelegate = dataSourceDelegate as? T where dataSourceDelegate == delegate {
                dataSourceChangedDelegates.removeAtIndex(index)
                break
            }
        }
    }

    
    
}

// MARK: User Info
// use when your app needs all the data
// FIFO queue
//@available(iOS 9.0, *)
extension WatchSessionManager {
    
    // Sender
    func transferUserInfo(userInfo: [String : AnyObject]) -> WCSessionUserInfoTransfer? {
        return validSession?.transferUserInfo(userInfo)
    }
    
    // Receiver
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject])
    {
        // handle receiving user info
        
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            let wutils:WatchUtils = WatchUtils()
            for (action, value) in userInfo {
                
                //print(action, " ",param)
                let ti:AnyObject = wutils.getLastTir()
                
                
                switch action {
                case "insertNewTir":
                    wutils.insertNewTir()
                    break
                    
                case "createEmptyVolee":
                    
                    
                    if let tir:Tir = ti as? Tir {
                        wutils.createEmptyVolee(tir)
                    }
                    
                    
                    
                    
                    break
                case "deleteScore":
                    if let tir:Tir = ti as? Tir {
                        if let vol:Volee = tir.volees.objectAtIndex(tir.volees.count-1) as? Volee {
                            
                            vol.deleteLast()
                        }
                    }
                    
                    break
                case "addScore":
                    if let tir:Tir = ti as? Tir {
                        if let vol:Volee = tir.volees.objectAtIndex(tir.volees.count-1) as? Volee {
                            
                            vol.addScore(value as! Int , impact:CGPointMake(0,0),zone:CGPointMake(0,0))
                        }
                    }
                    
                    break
                default: break
                    
                    
                }
                DataManager.saveManagedContext()
                
            }
            
            
            
            self?.dataSourceChangedDelegates.forEach {
                $0.dataSourceDidUpdate(userInfo)
                
            }
        }
    }

}
