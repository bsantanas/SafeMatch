//
//  ConnectionsViewController.swift
//  SafeMatch
//
//  Created by Bernardo Santana on 5/30/15.
//  Copyright (c) 2015 BUM. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConnectionsViewController: UIViewController, MCBrowserViewControllerDelegate, UITableViewDataSource {

    @IBOutlet weak var txtName:UITextField!
    @IBOutlet weak var switchVisible:UISwitch!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var buttonDisconnect:UIButton!
    var appDelegate:AppDelegate?
    var arrConnectedDevices = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        appDelegate?.mcManager?.setupPeerAndSessionWith(UIDevice.currentDevice().name)
        appDelegate?.mcManager?.advertiseSelf(switchVisible.on)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "peerDidChangeStateNotification:", name: "MCDidChangeStateNotification", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func browseForDevices(sender:AnyObject) {
        appDelegate?.mcManager?.setupMCBrowser()
        appDelegate?.mcManager?.browser?.delegate = self
        presentViewController(appDelegate!.mcManager!.browser!, animated: true, completion: nil)
    }
    
    @IBAction func toggleVisibility (sender:AnyObject) {
        appDelegate?.mcManager?.advertiseSelf(switchVisible.on)
    }
    
    @IBAction func disconnect(sender:AnyObject) {
        appDelegate?.mcManager?.session?.disconnect()
        txtName.enabled = true
        arrConnectedDevices.removeAll(keepCapacity: false)
        tableView.reloadData()
    }
    
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!) {
        appDelegate?.mcManager?.browser?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!) {
        appDelegate?.mcManager?.browser?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func peerDidChangeStateNotification(notification:NSNotification) {
        if let dict = notification.userInfo as? [String:AnyObject] {
            if let peerID = dict["peerID"] as? MCPeerID,
                let rawState = dict["state"] as? Int {
                    let state = MCSessionState(rawValue: rawState)
                    let peerDisplayName = peerID.displayName
                    if state != .Connecting {
                        if state == .Connected {
                            arrConnectedDevices.append(peerDisplayName)
                        } else if state == .NotConnected {
                            if arrConnectedDevices.count > 0 {
                                if let indexOfPeer = find(arrConnectedDevices,peerDisplayName) {
                                    arrConnectedDevices.removeAtIndex(indexOfPeer)
                                }
                            }
                        }
                        tableView.reloadData()
                        let peersExist = (appDelegate?.mcManager?.session?.connectedPeers.count == 0)
                        buttonDisconnect.enabled = !peersExist
                        txtName.enabled = peersExist
                    }
            }
        }
    }
    
    // MARK: - Table View
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrConnectedDevices.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PeerCell") as! UITableViewCell
        cell.textLabel?.text = arrConnectedDevices[indexPath.row]

        return cell
    }
    
    

}
