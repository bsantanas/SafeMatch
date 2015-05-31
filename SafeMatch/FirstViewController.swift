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
        
        
        
        let wormhole = MMWormhole(applicationGroupIdentifier: "group.com.bum.safematch", optionalDirectory: "wormhole")
        wormhole.passMessageObject("titleString", identifier: "messageIdentifier")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendMyState() {
        
        let dataToSend = "Hi! I'm clean 😀".dataUsingEncoding(NSUTF8StringEncoding)
        if let allPeers = appDelegate?.mcManager?.session?.connectedPeers {
            let error : NSError?
            appDelegate!.mcManager!.session!.sendData(dataToSend, toPeers: allPeers, withMode: MCSessionSendDataMode.Reliable, error: nil)
        }
        
        
        
        
    }
    
    

}

