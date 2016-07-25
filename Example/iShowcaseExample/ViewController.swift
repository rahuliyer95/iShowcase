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
    var showcase: iShowcase!
    var custom: Bool = false
    var multiple: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupShowcase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        UIView.animateWithDuration(duration) {
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                if let showcase = self.showcase {
                    showcase.setNeedsLayout() // Explicit calling needed for iPad
                }
            }
        }
    }

    @IBAction func barButtonClick(sender: UIBarButtonItem) {
        showcase.titleLabel.text = "Bar Button Example"
        showcase.detailsLabel.text = "This example highlights the Bar Button Item"
        showcase.setupShowcaseForBarButtonItem(sender)
        showcase.show()
    }

    @IBAction func defaultShowcaseClick(sender: UIButton) {
        showcase.titleLabel.text = "Default"
        showcase.detailsLabel.text = "This is default iShowcase"
        showcase.setupShowcaseForView(sender)
        showcase.show()
    }

    @IBAction func multipleShowcaseClick(sender: UIButton) {
        multiple = true
        defaultShowcaseClick(sender)
    }

    @IBAction func tableViewShowcaseClick(sender: UIButton) {
        showcase.titleLabel.text = "UITableView"
        showcase.detailsLabel.text = "This is default position example"
        showcase.setupShowcaseForTableView(tableView)
        showcase.show()
    }

    @IBAction func customShowcaseClick(sender: UIButton) {
        if backgroundColor.text?.characters.count > 0 {
            showcase.coverColor = UIColor.colorFromHexString(backgroundColor.text!)
        }

        if titleColor.text?.characters.count > 0 {
            showcase.titleLabel.textColor = UIColor.colorFromHexString(titleColor.text!)
        }

        if detailsColor.text?.characters.count > 0 {
            showcase.detailsLabel.textColor = UIColor.colorFromHexString(detailsColor.text!)
        }

        if highlightColor.text?.characters.count > 0 {
            showcase.highlightColor = UIColor.colorFromHexString(highlightColor.text!)
        }

        custom = true
        showcase.type = .CIRCLE
        showcase.titleLabel.text = "Custom"
        showcase.detailsLabel.text = "This is custom iShowcase"
        showcase.setupShowcaseForView(sender)

        // Uncomment this to show the showcase only once after 1st run
        // showcase.singleShotId = 47
        showcase.show()

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

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        showcase.titleLabel.text = "UITableView"
        showcase.detailsLabel.text = "This is custom position example"
        showcase.setupShowcaseForTableView(tableView, withIndexPath: indexPath)
        showcase.show()
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    private func setupShowcase() {
        showcase = iShowcase()
        showcase.delegate = self
    }

    func iShowcaseDismissed(showcase: iShowcase) {
        if multiple {
            showcase.titleLabel.text = "Multiple"
            showcase.detailsLabel.text = "This is multiple iShowcase"
            showcase.setupShowcaseForView(titleColor)
            showcase.show()
            multiple = false
        }

        if custom {
            setupShowcase()
            custom = false
        }
    }

}

