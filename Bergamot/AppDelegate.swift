//
//  AppDelegate.swift
//  Bergamot
//
//  Created by Kelly Davis on 17.07.20.
//  Copyright © 2020 Mozilla. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let inboundServerProcess = Process()
    let outboundServerProcess = Process()
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let startServerMenuItem = NSMenuItem(title: "Start Server", action: #selector(AppDelegate.startServer(_:)), keyEquivalent: "R")

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
          button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
          button.action = #selector(startServer(_:))
        }
        constructMenu()
        constructProcess()
    }
    
    func constructMenu() {
        let menu = NSMenu()
        menu.autoenablesItems = false
        
        menu.addItem(startServerMenuItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Bergamot", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        statusItem.menu = menu
    }
    
    func constructProcess() {
        let serverURL = Bundle.main.url(forResource: "server/rest-server", withExtension: nil)
        let inbooundConfigFile = Bundle.main.path(forResource: "config", ofType: "yml", inDirectory: "inboundModel")
        let outbooundConfigFile = Bundle.main.path(forResource: "config", ofType: "yml", inDirectory: "outboundModel")

        inboundServerProcess.executableURL = serverURL
        inboundServerProcess.arguments = ["-c", inbooundConfigFile!, "-p", "8787", "--log-level", "debug", "-w", "5000"]

        outboundServerProcess.executableURL = serverURL
        outboundServerProcess.arguments = ["-c", outbooundConfigFile!, "-p", "8788", "--log-level", "debug", "-w", "5000"]
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        if inboundServerProcess.isRunning {
            inboundServerProcess.terminate()
        }
        if outboundServerProcess.isRunning {
            outboundServerProcess.terminate()
        }
    }
    
    @objc func startServer(_ sender: Any?) {
        try! inboundServerProcess.run()
        try! outboundServerProcess.run()
        startServerMenuItem.isEnabled = false
    }
}

