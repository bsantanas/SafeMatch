//
//  WaitingViewController.swift
//  SafeMatch
//
//  Created by Bernardo Santana on 5/30/15.
//  Copyright (c) 2015 BUM. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class WaitingViewController: UIViewController {
    
    var appDelegate:AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate

    }
    
    override func viewWillAppear(animated: Bool) {
        let dataToSend = "Hi! I'm clean 😀".dataUsingEncoding(NSUTF8StringEncoding)
        if let allPeers = appDelegate?.mcManager?.session?.connectedPeers {
            let error : NSError?
            appDelegate!.mcManager!.session!.sendData(dataToSend, toPeers: allPeers, withMode: MCSessionSendDataMode.Reliable, error: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
