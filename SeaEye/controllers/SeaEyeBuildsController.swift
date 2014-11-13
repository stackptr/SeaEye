//
//  SeaEyeBuildsController.swift
//  SeaEye
//
//  Created by Eoin Nolan on 26/10/2014.
//  Copyright (c) 2014 Nolaneo. All rights reserved.
//

import Cocoa

class SeaEyeBuildsController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    var model : CircleCIModel!
    
    @IBOutlet weak var fallbackView: NSTextField!
    @IBOutlet weak var buildsTable: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        self.setupFallBackViews()
        self.reloadBuilds()
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("reloadBuilds"),
            name: "SeaEyeUpdatedBuilds",
            object: nil
        )
    }
    
    override func viewWillDisappear() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func reloadBuilds() {
        println("Reload builds!")
        setupFallBackViews()
        buildsTable.reloadData()
    }
    
    private func setupFallBackViews() {
        fallbackView.hidden = false
        buildsTable.hidden = true
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if  (userDefaults.stringForKey("SeaEyeAPIKey") == nil) {
            return fallbackView.stringValue = "You have not set an API key"
        }
        if userDefaults.boolForKey("SeaEyeError") {
            return fallbackView.stringValue = "Could not connect with your settings. Check'em!"
        }
        if (userDefaults.stringForKey("SeaEyeOrganization") == nil) {
            return fallbackView.stringValue = "You have not set an organization name"
        }
        if (userDefaults.valueForKey("SeaEyeProjects") == nil) {
            return fallbackView.stringValue = "You have not added any projects"
        }
        if (model.allBuilds == nil) {
            return fallbackView.stringValue = "Loading Recent Builds"
        }
        if (model.allBuilds.count == 0) {
            return fallbackView.stringValue = "No Recent Builds Found"
        }
        fallbackView.hidden = true
        buildsTable.hidden = false
    }
    
    //NSTableViewDataSource
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if model.allBuilds != nil {
            return model.allBuilds.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        return model.allBuilds[row]
    }
    
    //NSTableViewDelegate
//    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
//        
//    }

    func selectionShouldChangeInTableView(tableView: NSTableView) -> Bool {
        return false
    }
    
    
}
