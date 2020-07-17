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

    let serverProcess = Process()
    let commandLineArguments = ["Started server"]
    let executableURL = URL(fileURLWithPath: "/usr/bin/say")
    
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
        serverProcess.executableURL = executableURL
        serverProcess.arguments = commandLineArguments
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        if serverProcess.isRunning {
            serverProcess.terminate()
        }
    }
    
    @objc func startServer(_ sender: Any?) {
        try! serverProcess.run()
        startServerMenuItem.isEnabled = false
    }
}

