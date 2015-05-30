//
//  InterfaceController.swift
//  SafeMatch WatchKit Extension
//
//  Created by Bernardo Santana on 5/30/15.
//  Copyright (c) 2015 BUM. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var tableView:WKInterfaceTable!
    let users = ["Milos","Bernardo","Uros","Jessyca","Anna","Violet"]

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        populateTable()
    }
    
    func populateTable() {
        
        
        tableView.setNumberOfRows(users.count, withRowType: "UsersTableRowController")
        
        for (index,value) in enumerate(users) {
            let row = tableView.rowControllerAtIndex(index) as! UsersTableRowController
            row.titleLabel.setText(value)
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        
        return users[rowIndex]
    }
    
    
    override func handleActionWithIdentifier(identifier: String?, forRemoteNotification remoteNotification: [NSObject : AnyObject]) {
        
        // Receives action from notification
        println("asdah")
    }
    
}
