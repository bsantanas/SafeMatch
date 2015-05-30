//
//  MCManager.swift
//  SafeMatch
//
//  Created by Bernardo Santana on 5/30/15.
//  Copyright (c) 2015 BUM. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MCManager: NSObject, MCSessionDelegate {
    var peerID:MCPeerID?
    var session:MCSession?
    var browser:MCBrowserViewController?
    var advertiser:MCAdvertiserAssistant?
   
    
    
    func setupPeerAndSessionWith(displayName:String) {
        peerID = MCPeerID(displayName: displayName)
        
        session = MCSession(peer: peerID)
        session!.delegate = self
    }
    
    func setupMCBrowser() {
        browser = MCBrowserViewController(serviceType: "sm-notif", session: session)
    }
    
    func advertiseSelf(shouldAdvertise:Bool) {
        if (shouldAdvertise) {
            advertiser = MCAdvertiserAssistant(serviceType: "sm-notif", discoveryInfo: nil, session: session)
            advertiser?.start()
        }
        else{
            advertiser?.stop()
            advertiser = nil;
        }
    }
    
    // MARK: - Session Delegate
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        
        let dict = ["peerID":peerID, "state":state.rawValue]
        
        NSNotificationCenter.defaultCenter().postNotificationName("MCDidChangeStateNotification", object: nil, userInfo: dict)
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        
        let dict = ["data": data, "peerID": peerID]
        NSNotificationCenter.defaultCenter().postNotificationName("MCDidReceiveDataNotification", object: nil, userInfo: dict)
        
    }
    
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        
    }
    
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        
    }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        
    }
}
