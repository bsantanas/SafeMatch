//
//  ApprovalInterfaceController.swift
//  SafeMatch
//
//  Created by Bernardo Santana on 5/30/15.
//  Copyright (c) 2015 BUM. All rights reserved.
//

import WatchKit
import Foundation


class ApprovalInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var userLabel:WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        userLabel.setText(context as? String)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
