//
//  ViewController.swift
//  iShowcaseExample
//
//  Created by Rahul Iyer on 14/10/15.
//  Copyright © 2015 rahuliyer. All rights reserved.
//

import UIKit
import iShowcase

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, iShowcaseDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundColor: UITextField!
    @IBOutlet weak var titleColor: UITextField!
    @IBOutlet weak var detailsColor: UITextField!
    @IBOutlet weak var highlightColor: UITextField!
    
    let tableData = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
    var showcase: iShowcase?
    var custom: Bool = false
    var multiple: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupShowcase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func barButtonClick(sender: UIBarButtonItem) {
        if let showcase = self.showcase {
            showcase.setupShowcase(forBarButtonItem: sender, withTitle: "Bar Button Example", detailsMessage: "This example highlights the Bar Button Item")
            showcase.show()
        }
    }

    @IBAction func defaultShowcaseClick(sender: UIButton) {
        if let showcase = self.showcase {
            showcase.setupShowcase(forView: sender, withTitle: "Default", detailsMessage: "This is default iShowcase")
            showcase.show()
        }
    }
    
    @IBAction func multipleShowcaseClick(sender: UIButton) {
        self.multiple = true
        self.defaultShowcaseClick(sender)
    }
    
    @IBAction func tableViewShowcaseClick(sender: UIButton) {
        if let showcase = self.showcase {
            showcase.setupShowcase(forTableView: tableView, withIndexOfItem: 1, setionOfItem: 0, withTitle: "UITableView", detailsMessage: "This is custom position example")
            showcase.show()
        }
    }
    
    @IBAction func customShowcaseClick(sender: UIButton) {
        let customShowcase = iShowcase()
        if backgroundColor.text?.characters.count > 0 {
            customShowcase.backgroundColor = iShowcase.colorHexFromString(backgroundColor.text!)
        }
        
        if titleColor.text?.characters.count > 0 {
            customShowcase.titleColor = iShowcase.colorHexFromString(titleColor.text!)
        }
        
        if detailsColor.text?.characters.count > 0 {
            customShowcase.detailsColor = iShowcase.colorHexFromString(detailsColor.text!)
        }
        
        if highlightColor.text?.characters.count > 0 {
            customShowcase.highlightColor = iShowcase.colorHexFromString(highlightColor.text!)
        }
        
        self.custom = true
        customShowcase.iType = .CIRCLE
        customShowcase.setupShowcase(forView: sender, withTitle: "Custom", detailsMessage: "This is custom iShowcase")
        
        // Will be shown only once
        // Comment this to show the showcase after 1st run
        customShowcase.singleShotId = 47
        customShowcase.show()

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        }
        
        if let cell = cell {
            cell.textLabel!.text = tableData[indexPath.row]
        }
        
        return cell!
    }
    
    private func setupShowcase() {
        showcase = iShowcase()
        showcase!.delegate = self
    }
    
    func iShowcaseDismissed(showcase: iShowcase) {
        if multiple {
            showcase.setupShowcase(forView: titleColor, withTitle: "Multiple", detailsMessage: "This is multiple iShowcase")
            showcase.show()
            multiple = false
        }
        
        if custom {
            custom = false
        }
    }
    
}

