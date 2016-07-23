//
//  iShowcase.swift
//  iShowcase
//
//  Created by Rahul Iyer on 12/10/15.
//  Copyright © 2015 rahuliyer. All rights reserved.
//

import UIKit
import Foundation

@objc public protocol iShowcaseDelegate: NSObjectProtocol {
    /**
     Called when the showcase is displayed

     - showcase: The instance of the showcase displayed
     */
    optional func iShowcaseShown(showcase: iShowcase)
    /**
     Called when the showcase is removed from the view

     - showcase: The instance of the showcase removed
     */
    optional func iShowcaseDismissed(showcase: iShowcase)
}

@objc public class iShowcase: UIView {

    /**
     Type of the highlight for the showcase

     - CIRCLE:    Creates a circular highlight around the view
     - RECTANGLE: Creates a rectangular highligh around the view
     */
    @objc public enum TYPE: Int {
        case CIRCLE = 0
        case RECTANGLE = 1
    }

    private enum REGION: Int {
        case TOP = 0
        case LEFT = 1
        case BOTTOM = 2
        case RIGHT = 3

        static func regionFromInt(region: Int) -> REGION {
            switch (region) {
            case 0:
                return .TOP
            case 1:
                return .LEFT
            case 2:
                return .BOTTOM
            case 3:
                return .RIGHT
            default:
                return .TOP
            }
        }
    }

    private var containerView: UIView!
    private var showcaseRect: CGRect!
    private var region: REGION!
    private var targetView: UIView?
    private var showcaseImageView: UIImageView!

    /// Label to show the title of the showcase
    public var titleLabel: UILabel!
    /// Label to show the description of the showcase
    public var detailsLabel: UILabel!
    /// Color of the background for the showcase. Default is black
    public var coverColor: UIColor!
    /// Alpha of the background of the showcase. Default is 0.75
    public var coverAlpha: CGFloat!
    /// Color of the showcase highlight. Default is #1397C5
    public var highlightColor: UIColor!
    /// Type of the showcase to be created. Default is Rectangle
    public var type: TYPE!
    /// Radius of the circle with iShowcase type Circle. Default radius is 25
    public var radius: Float!
    /// Single Shot ID for iShowcase
    public var singleShotId: Int64!
    /// Delegate for handling iShowcase callbacks
    public var delegate: iShowcaseDelegate?

    public init() {
        super.init(frame: CGRect(
            x: 0,
            y: 0,
            width: UIScreen.mainScreen().bounds.width,
            height: UIScreen.mainScreen().bounds.height))
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if showcaseImageView != nil {
            recycleViews()
        }
        if let view = targetView {
            showcaseRect = view.convertRect(view.bounds, toView: containerView)
        }
        draw()
        addSubview(showcaseImageView)
        addSubview(titleLabel)
        addSubview(detailsLabel)
        addGestureRecognizer(getGestureRecgonizer())
    }

    /**
     Setup the showcase for a view

     - parameter view:    The view to be highlighted
     */
    public func setupShowcaseForView(view: UIView) {
        targetView = view
        setupShowcaseForLocation(view.convertRect(view.bounds, toView: containerView))
    }

    /**
     Setup showcase for the item at 1st position (0th index) of the table

     - parameter tableView: Table whose item is to be highlighted
     */
    public func setupShowcaseForTableView(tableView: UITableView) {
        setupShowcaseForTableView(tableView, withIndexOfItem: 0, andSectionOfItem: 0)
    }

    /**
     Setup showcase for the item at the given indexpath

     - parameter tableView: Table whose item is to be highlighted
     - parameter indexPath: IndexPath of the item to be highlighted
     */
    public func setupShowcaseForTableView(tableView: UITableView, withIndexPath indexPath: NSIndexPath) {
        setupShowcaseForTableView(tableView, withIndexOfItem: indexPath.row, andSectionOfItem: indexPath.section)
    }

    /**
     Setup showcase for the item at the given index in the given section of the table

     - parameter tableView: Table whose item is to be highlighted
     - parameter row:       Index of the item to be highlighted
     - parameter section:   Section of the item to be highlighted
     */
    public func setupShowcaseForTableView(tableView: UITableView, withIndexOfItem row: Int, andSectionOfItem section: Int) {
        let indexPath = NSIndexPath(forRow: row, inSection: section)
        targetView = tableView.cellForRowAtIndexPath(indexPath)
        setupShowcaseForLocation(tableView.convertRect(
            tableView.rectForRowAtIndexPath(indexPath),
            toView: containerView))
    }

    /**
     Setup showcase for the Bar Button in the Navigation Bar

     - parameter barButtonItem: Bar button to be highlighted
     */
    public func setupShowcaseForBarButtonItem(barButtonItem: UIBarButtonItem) {
        setupShowcaseForView(barButtonItem.valueForKey("view") as! UIView)
    }

    /**
     Setup showcase to highlight a particular location on the screen

     - parameter location: Location to be highlighted
     */
    public func setupShowcaseForLocation(location: CGRect) {
        showcaseRect = location
    }

    /**
     Display the iShowcase
     */
    public func show() {
        if singleShotId != -1
        && NSUserDefaults.standardUserDefaults().boolForKey(String(format: "iShowcase-%ld", singleShotId)) {
            return
        }

        self.alpha = 1
        for view in containerView.subviews {
            view.userInteractionEnabled = false
        }

        UIView.transitionWithView(
            containerView,
            duration: 0.5,
            options: UIViewAnimationOptions.TransitionCrossDissolve,
            animations: { () -> Void in
                self.containerView.addSubview(self)
        }) { (_) -> Void in
                if let delegate = self.delegate {
                    if delegate.respondsToSelector(#selector(iShowcaseDelegate.iShowcaseShown)) {
                        delegate.iShowcaseShown!(self)
                    }
                }
        }
    }

    private func setup() {
        self.backgroundColor = UIColor.clearColor()
        containerView = UIApplication.sharedApplication().delegate!.window!
        coverColor = UIColor.blackColor()
        highlightColor = UIColor.colorFromHexString("#1397C5")
        coverAlpha = 0.75
        type = .RECTANGLE
        radius = 25
        singleShotId = -1

        // Setup title label defaults
        titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFontOfSize(24)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        titleLabel.numberOfLines = 0

        // Setup details label defaults
        detailsLabel = UILabel()
        detailsLabel.font = UIFont.systemFontOfSize(16)
        detailsLabel.textColor = UIColor.whiteColor()
        detailsLabel.textAlignment = .Center
        detailsLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        detailsLabel.numberOfLines = 0
    }

    private func draw() {
        setupBackground()
        calculateRegion()
        setupText()
    }

    private func setupBackground() {
        UIGraphicsBeginImageContextWithOptions(UIScreen.mainScreen().bounds.size, false, UIScreen.mainScreen().scale)
        var context: CGContextRef? = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, coverColor.CGColor)
        CGContextFillRect(context, containerView.bounds)

        if type == .RECTANGLE {
            if let showcaseRect = showcaseRect {

                // Outer highlight
                let highlightRect = CGRect(
                    x: showcaseRect.origin.x - 15,
                    y: showcaseRect.origin.y - 15,
                    width: showcaseRect.size.width + 30,
                    height: showcaseRect.size.height + 30)

                CGContextSetShadowWithColor(context, CGSizeZero, 30, highlightColor.CGColor)
                CGContextSetFillColorWithColor(context, coverColor.CGColor)
                CGContextSetStrokeColorWithColor(context, highlightColor.CGColor)
                CGContextAddPath(context, UIBezierPath(rect: highlightRect).CGPath)
                CGContextDrawPath(context, .FillStroke)

                // Inner highlight
                CGContextSetLineWidth(context, 3)
                CGContextAddPath(context, UIBezierPath(rect: showcaseRect).CGPath)
                CGContextDrawPath(context, .FillStroke)

                let showcase = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                // Clear region
                UIGraphicsBeginImageContext(showcase.size)
                showcase.drawAtPoint(CGPointZero)
                context = UIGraphicsGetCurrentContext()
                CGContextClearRect(context, showcaseRect)
            }
        } else {
            if let showcaseRect = showcaseRect {
                let center = CGPoint(
                    x: showcaseRect.origin.x + showcaseRect.size.width / 2.0,
                    y: showcaseRect.origin.y + showcaseRect.size.height / 2.0)

                // Draw highlight
                CGContextSetLineWidth(context, 2.54)
                CGContextSetShadowWithColor(context, CGSizeZero, 30, highlightColor.CGColor)
                CGContextSetFillColorWithColor(context, coverColor.CGColor)
                CGContextSetStrokeColorWithColor(context, highlightColor.CGColor)
                CGContextAddArc(context, center.x, center.y, CGFloat(radius * 2), 0, CGFloat(2 * M_PI), 0)
                CGContextDrawPath(context, .FillStroke)
                CGContextAddArc(context, center.x, center.y, CGFloat(radius), 0, CGFloat(2 * M_PI), 0)
                CGContextDrawPath(context, .FillStroke)

                // Clear circle
                CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
                CGContextSetBlendMode(context, .Clear)
                CGContextAddArc(context, center.x, center.y, CGFloat(radius - 0.54), 0, CGFloat(2 * M_PI), 0)
                CGContextDrawPath(context, .Fill)
                CGContextSetBlendMode(context, .Normal)
            }
        }
        showcaseImageView = UIImageView(image: UIGraphicsGetImageFromCurrentImageContext())
        showcaseImageView.alpha = coverAlpha
        UIGraphicsEndImageContext()
    }

    private func calculateRegion() {
        let left = showcaseRect.origin.x,
            right = showcaseRect.origin.x + showcaseRect.size.width,
            top = showcaseRect.origin.y,
            bottom = showcaseRect.origin.y + showcaseRect.size.height

        let areas = [
            top * UIScreen.mainScreen().bounds.size.width, // Top region
            left * UIScreen.mainScreen().bounds.size.height, // Left region
            (UIScreen.mainScreen().bounds.size.height - bottom) * UIScreen.mainScreen().bounds.size.width, // Bottom region
            (UIScreen.mainScreen().bounds.size.width - right) - UIScreen.mainScreen().bounds.size.height // Right region
        ]

        var largestIndex = 0
        for (var i: Int = 0; i < areas.count; ++i) {
            if areas[i] > areas[largestIndex] {
                largestIndex = i
            }
        }
        region = REGION.regionFromInt(largestIndex)
    }

    private func setupText() {
        var titleSize: CGSize!
        if let text = titleLabel.text {
            titleSize = NSString(string: text).sizeWithAttributes([
                NSFontAttributeName: titleLabel.font
            ])
        } else if let attributedText = titleLabel.attributedText {
            titleSize = attributedText.size()
        }

        var detailsSize: CGSize!
        if let text = detailsLabel.text {
            detailsSize = NSString(string: text).sizeWithAttributes([
                NSFontAttributeName: detailsLabel.font
            ])
        } else if let attributedText = detailsLabel.attributedText {
            detailsSize = attributedText.size()
        }

        let textPosition = getBestPositionOfTitle(withTitleSize: titleSize, withDetailsSize: detailsSize)

        if region == .BOTTOM {
            detailsLabel.frame = textPosition.0
            titleLabel.frame = textPosition.1
        } else {
            titleLabel.frame = textPosition.0
            detailsLabel.frame = textPosition.1
        }

        titleLabel.sizeToFit()
        detailsLabel.sizeToFit()

        titleLabel.frame = CGRect(
            x: containerView.bounds.size.width / 2.0 - titleLabel.frame.size.width / 2.0,
            y: titleLabel.frame.origin.y,
            width: titleLabel.frame.size.width - (region == .LEFT || region == .RIGHT
                    ? showcaseRect.size.width
                    : 0),
            height: titleLabel.frame.size.height)

        detailsLabel.frame = CGRect(
            x: containerView.bounds.size.width / 2.0 - detailsLabel.frame.size.width / 2.0,
            y: detailsLabel.frame.origin.y,
            width: detailsLabel.frame.size.width - (region == .LEFT || region == .RIGHT
                    ? showcaseRect.size.width
                    : 0),
            height: detailsLabel.frame.size.height)

    }

    private func getBestPositionOfTitle(withTitleSize titleSize: CGSize, withDetailsSize detailsSize: CGSize) -> (CGRect, CGRect) {
        var rect0 = CGRect(), rect1 = CGRect()
        if let region = self.region {
            switch region {
            case .TOP:
                rect0 = CGRect(
                    x: containerView.bounds.size.width / 2.0 - titleSize.width / 2.0,
                    y: titleSize.height + 64,
                    width: titleSize.width,
                    height: titleSize.height)
                rect1 = CGRect(
                    x: containerView.bounds.size.width / 2.0 - detailsSize.width / 2.0,
                    y: rect0.origin.y + rect0.size.height + detailsSize.height / 2.0,
                    width: detailsSize.width,
                    height: detailsSize.height)
                break
            case .LEFT:
                rect0 = CGRectMake(
                    0,
                    containerView.bounds.size.height / 2.0,
                    titleSize.width,
                    titleSize.height)
                rect1 = CGRectMake(
                    0,
                    rect0.origin.y + rect0.size.height + detailsSize.height / 2.0,
                    detailsSize.width,
                    detailsSize.height)
                break
            case .BOTTOM:
                rect0 = CGRectMake(
                    containerView.bounds.size.width / 2.0 - detailsSize.width / 2.0,
                    containerView.bounds.size.height - detailsSize.height * 2.0,
                    detailsSize.width,
                    detailsSize.height)
                rect1 = CGRectMake(
                    containerView.bounds.size.width / 2.0 - titleSize.width / 2.0,
                    rect0.origin.y - rect0.size.height - titleSize.height / 2.0,
                    titleSize.width,
                    titleSize.height)
                break
            case .RIGHT:
                rect0 = CGRectMake(
                    containerView.bounds.size.width - titleSize.width,
                    containerView.bounds.size.height / 2.0,
                    titleSize.width,
                    titleSize.height)
                rect1 = CGRectMake(
                    containerView.bounds.size.width - detailsSize.width,
                    rect0.origin.y + rect0.size.height + detailsSize.height / 2.0,
                    detailsSize.width,
                    detailsSize.height)
                break
            }
        }

        return (rect0, rect1)
    }

    private func getGestureRecgonizer() -> UIGestureRecognizer {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(showcaseTapped))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        return singleTap
    }

    internal func showcaseTapped() {
        UIView.animateWithDuration(
            0.5,
            animations: { () -> Void in
                self.alpha = 0
        }) { (_) -> Void in
                self.onAnimationComplete()
        }
    }

    private func onAnimationComplete() {
        if singleShotId != -1 {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: String(format: "iShowcase-%ld", singleShotId))
            singleShotId = -1
        }
        for view in self.containerView.subviews {
            view.userInteractionEnabled = true
        }
        recycleViews()
        self.removeFromSuperview()
        if let delegate = delegate {
            if delegate.respondsToSelector(#selector(iShowcaseDelegate.iShowcaseDismissed)) {
                delegate.iShowcaseDismissed!(self)
            }
        }
    }

    private func recycleViews() {
        showcaseImageView.removeFromSuperview()
        titleLabel.removeFromSuperview()
        detailsLabel.removeFromSuperview()
    }

}

public extension UIColor {
    public static func colorFromHexString(colorString: String) -> UIColor {
        let hex = colorString.stringByTrimmingCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
        var int = UInt32()
        NSScanner(string: hex).scanHexInt(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return UIColor.clearColor()
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}