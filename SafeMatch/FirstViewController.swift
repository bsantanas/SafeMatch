//
//  FirstViewController.swift
//  SafeMatch
//
//  Created by Bernardo Santana on 5/30/15.
//  Copyright (c) 2015 BUM. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class FirstViewController: UIViewController {
    
    var appDelegate:AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveDataWithNotification:", name: "MCDidReceiveDataNotification", object: nil)
        
        let wormhole = MMWormhole(applicationGroupIdentifier: "group.com.bum.safematch", optionalDirectory: "wormhole")
        wormhole.passMessageObject("titleString", identifier: "messageIdentifier")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendMyState() {
        
        let dataToSend = "Hi, I'm clean. Fuck me.".dataUsingEncoding(NSUTF8StringEncoding)
        if let allPeers = appDelegate?.mcManager?.session?.connectedPeers {
            let error : NSError?
            appDelegate!.mcManager!.session!.sendData(dataToSend, toPeers: allPeers, withMode: MCSessionSendDataMode.Reliable, error: nil)
        }
        
        
        let notifyAlarm = UILocalNotification()
        let alertTime = NSDate(timeIntervalSinceNow: 5)
        notifyAlarm.fireDate = alertTime
        notifyAlarm.timeZone = NSTimeZone.defaultTimeZone()
        notifyAlarm.alertBody = "Staff meeting in 30 minutes"
        UIApplication.sharedApplication().scheduleLocalNotification(notifyAlarm)
        
        //UIApplication.sharedApplication().presentLocalNotificationNow(notifyAlarm)
        
    }
    
    func didReceiveDataWithNotification(notification:NSNotification) {
        
        if let dict = notification.userInfo as? [String:AnyObject] {
            if let peerID = dict["peerID"] as? MCPeerID,
            let receivedData = dict["data"] as? NSData {
                let peerDisplayName = peerID.displayName
                let receivedText = NSString(data: receivedData, encoding: NSUTF8StringEncoding)
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.makeAlertWithText(receivedText!)})
 
            }
        }
    }
    
    func makeAlertWithText(text:NSString) {
        let alert = UIAlertController(title: "Hey", message: text as String, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle Cancel Logic here")
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }


}

