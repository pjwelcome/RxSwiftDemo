//
//  InterfaceController.swift
//  RxSwiftWatch Extension
//
//  Created by pjapple on 2019/04/23.
//  Copyright © 2019 DVT. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var table: WKInterfaceTable!
    private var session = WCSession.default
    
    private var items = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.updateTable()
            }
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        items.append("Hello World")
        items.append("Hello World2")
    }
    
    func updateTable() {
        table.setNumberOfRows(items.count, withRowType: "row")
        for (i, item) in items.enumerated() {
            if let row = table.rowController(at: i) as? Row {
                row.label.setText(item)
            }
        }
    }
    
    @IBAction func sendMessage() {
        if isReachable() {
            session.sendMessage(["request" : "version"], replyHandler: { (response) in
                self.items.append("Reply: \(response)")
            }, errorHandler: { (error) in
                print("Error sending message: %@", error)
            })
        } else {
            print("iPhone is not reachable!!")
        }
    }
    
    private func isSuported() -> Bool {
        return WCSession.isSupported()
    }
    
    private func isReachable() -> Bool {
        return session.isReachable
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if isSuported() {
            session.delegate = self
            session.activate()
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}

class Row : NSObject {
    @IBOutlet weak var label: WKInterfaceLabel!
}

extension InterfaceController: WCSessionDelegate {
    
    // 4: Required stub for delegating session
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // 1: We launch a sound and a vibration
        WKInterfaceDevice.current().play(.notification)
        // 2: Get message and append to list
        let msg = message["msg"]!
        self.items.append("\(msg)")
    }
    
}
