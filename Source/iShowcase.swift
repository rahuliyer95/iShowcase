//
//  iShowcase.swift
//  iShowcase
//
//  Created by Rahul Iyer on 12/10/15.
//  Copyright © 2015 rahuliyer. All rights reserved.
//

import UIKit
import Foundation

@objc public protocol iShowcaseDelegate : NSObjectProtocol {
    optional func iShowcaseShown(showcase: iShowcase)
    optional func iShowcaseDismissed(showcase: iShowcase)
}

@objc public class iShowcase: UIView {
    
    /**
    Type of the highlight for the showcase
    
    - CIRCLE:    Creates a circular highlight around the view
    - RECTANGLE: Creates a rectangular highligh around the view
    */
    public enum TYPE: Int {
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
    
    private var showcaseImageView: UIImageView = UIImageView()
    private var titleLabel: UILabel = UILabel()
    private var detailsLabel: UILabel = UILabel()
    private let containerView: UIView = (UIApplication.sharedApplication().delegate!.window!)!
    private var showcaseRect: CGRect?
    private var region: REGION?
    
    /// Font to be used with title. Default is System font of size 24
    public var titleFont: UIFont = UIFont.systemFontOfSize(24)
    /// Font to be used with details. Default is System font of size 16
    public var detailsFont: UIFont = UIFont.systemFontOfSize(16)
    /// Color of the title text. Default is White Color
    public var titleColor: UIColor = UIColor.whiteColor()
    /// Color of the details text. Default is White Color
    public var detailsColor: UIColor = UIColor.whiteColor()
    /// Color of the showcase highlight. Default is #1397C5
    public var highlightColor: UIColor = iShowcase.colorHexFromString("#1397C5")
    /// Type of the showcase to be created. Default is Rectangle
    public var iType: TYPE = .RECTANGLE
    /// Text alignment for title. Default is Center
    public var titleTextAlignment: NSTextAlignment = NSTextAlignment.Center
    /// Text alignment for details. Default is Center
    public var detailsTextAlignment: NSTextAlignment = NSTextAlignment.Center
    /// Radius of the circle with iShowcase type Circle. Default radius is 25
    public var radius: Float = 25
    /// Single Shot ID for iShowcase
    public var singleShotId: Int64 = -1
    /// Delegate for handling iShowcase callbacks
    public var delegate: iShowcaseDelegate?
    
    public init() {
        super.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
    Initialize an instance of iShowcase
    
    - parameter titleFont:       Custom font for the title
    - parameter detailsFont:     Custom font for the description
    - parameter titleColor:      Custom color for the title
    - parameter detailsColor:    Custom color for the description
    - parameter backgroundColor: Color of the background
    - parameter highlightColor:  Color for the iShowcase highlight
    - parameter iType:           Type of the iShowcase highlight
    
    - returns: Instance of iShowcase
    */
    public convenience init(withTitleFont titleFont: UIFont?,
        withDetailsFont detailsFont: UIFont?,
        withTitleColor titleColor: UIColor?,
        withDetailsColor detailsColor: UIColor?,
        withBackgroundColor backgroundColor: UIColor?,
        withHighlightColor highlightColor: UIColor?,
        withIType iType: TYPE?) {
            self.init()
            
            if let titleFont = titleFont {
                self.titleFont = titleFont
            }
            
            if let detailsFont = detailsFont {
                self.detailsFont = detailsFont
            }
            
            if let titleColor = titleColor {
                self.titleColor = titleColor
            }
            
            if let detailsColor = detailsColor {
                self.detailsColor = detailsColor
            }
            
            if let backgroundColor = backgroundColor {
                self.backgroundColor = backgroundColor
            } else {
                self.backgroundColor = UIColor.blackColor()
            }
            
            if let highlightColor = highlightColor {
                self.highlightColor = highlightColor
            }
            
            if let iType = iType {
                self.iType = iType
            }
    }
    
    /**
    Setup the showcase for a view
    
    - parameter view:    The view to be highlighted
    - parameter title:   Title for the showcase
    - parameter details: Description of the showcase
    */
    public func setupShowcase(forView view: UIView, withTitle title: String, detailsMessage details: String) {
        self.setupShowcase(
            forTarget: view,
            withTitle: title,
            detailsMessage: details)
    }
    
    /**
    Setup showcase for the item at 1st position (0th index) of the table
    
    - parameter tableView: Table whose item is to be highlighted
    - parameter title:     Title for the showcase
    - parameter details:   Description of the showcase
    */
    public func setupShowcase(forTableView tableView: UITableView, withTitle title: String, detailsMessage details: String) {
        self.setupShowcase(
            forTableView: tableView,
            withIndexOfItem: 0,
            setionOfItem: 0,
            withTitle: title,
            detailsMessage: details)
    }
    
    /**
    Setup showcase for the item at the given index in the given section of the table
    
    - parameter tableView: Table whose item is to be highlighted
    - parameter row:       Index of the item to be highlighted
    - parameter section:   Section of the item to be highlighted
    - parameter title:     Title for the showcase
    - parameter details:   Description of the showcase
    */
    public func setupShowcase(forTableView tableView: UITableView, withIndexOfItem row: Int, setionOfItem section: Int, withTitle title: String, detailsMessage details: String) {
        self.setupShowcase(
            forLocation: tableView.convertRect(
                tableView.rectForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section)),
                toView: self.containerView),
            withTitle: title,
            detailsMessage: details)
    }
    
    /**
    Setup showcase for the Bar Button in the Navigation Bar
    
    - parameter barButtonItem: Bar button to be highlighted
    - parameter title:         Title for the showcase
    - parameter details:       Description of the showcase
    */
    public func setupShowcase(forBarButtonItem barButtonItem: UIBarButtonItem, withTitle title: String, detailsMessage details: String) {
        self.setupShowcase(
            forTarget: barButtonItem.valueForKey("view")!,
            withTitle: title,
            detailsMessage: details)
    }
    
    /**
    Setup showcase to highlight any object that can be converted to rect on the screen
    
    - parameter target:  The object to be highlighted
    - parameter title:   Title for the showcase
    - parameter details: Description of the showcase
    */
    public func setupShowcase(forTarget target: AnyObject, withTitle title: String, detailsMessage details: String) {
        self.setupShowcase(
            forLocation: target.convertRect(target.bounds, toView: self.containerView),
            withTitle: title,
            detailsMessage: details)
    }
    
    /**
    Setup showcase to highlight a particular location on the screen
    
    - parameter location: Location to be highlighted
    - parameter title:    Title for the showcase
    - parameter details:  Description of the showcase
    */
    public func setupShowcase(forLocation location: CGRect, withTitle title: String, detailsMessage details: String) {
        self.showcaseRect = location
        self.setupBackground()
        self.calculateRegion()
        self.setupText(withTitle: title, detailsText: details)
        
        self.addSubview(showcaseImageView)
        self.addSubview(titleLabel)
        self.addSubview(detailsLabel)
        self.addGestureRecognizer(self.getGesture())
    }
    
    /**
    Display the iShowcase
    */
    public func show() {
        if self.singleShotId != -1 && NSUserDefaults.standardUserDefaults().boolForKey(String(format: "iShowcase-%ld", self.singleShotId)) {
            self.recycleViews()
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
            }) { (Bool) -> Void in
                if let delegate = self.delegate {
                    if delegate.respondsToSelector("iShowcaseShown:") {
                        delegate.iShowcaseShown!(self)
                    }
                }
        }
    }
    
    private func setupBackground() {
        UIGraphicsBeginImageContextWithOptions(UIScreen.mainScreen().bounds.size, false, UIScreen.mainScreen().scale)
        var context: CGContextRef? = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, self.backgroundColor?.CGColor)
        CGContextFillRect(context, containerView.bounds)
        
        if self.iType == .RECTANGLE {
            
            if let showcaseRect = showcaseRect {
                
                // Outer highlight
                let highlightRect = CGRectMake(showcaseRect.origin.x - 15, showcaseRect.origin.y - 15, showcaseRect.size.width + 30, showcaseRect.size.height + 30)
                
                CGContextSetShadowWithColor(context, CGSizeZero, 30, self.highlightColor.CGColor)
                CGContextSetFillColorWithColor(context, self.backgroundColor?.CGColor)
                CGContextSetStrokeColorWithColor(context, self.highlightColor.CGColor)
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
                
                let center = CGPointMake(showcaseRect.origin.x + showcaseRect.size.width / 2.0, showcaseRect.origin.y + showcaseRect.size.height / 2.0)
                
                // Draw highlight
                CGContextSetLineWidth(context, 2.54)
                CGContextSetShadowWithColor(context, CGSizeZero, 30, self.highlightColor.CGColor)
                CGContextSetFillColorWithColor(context, self.backgroundColor?.CGColor)
                CGContextSetStrokeColorWithColor(context, self.highlightColor.CGColor)
                CGContextAddArc(context, center.x, center.y, CGFloat(self.radius * 2), 0, CGFloat(2 * M_PI), 0)
                CGContextDrawPath(context, .FillStroke)
                CGContextAddArc(context, center.x, center.y, CGFloat(self.radius), 0, CGFloat(2 * M_PI), 0)
                CGContextDrawPath(context, .FillStroke)
                
                // Clear circle
                CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
                CGContextSetBlendMode(context, .Clear)
                CGContextAddArc(context, center.x, center.y, CGFloat(self.radius - 0.54), 0, CGFloat(2 * M_PI), 0)
                CGContextDrawPath(context, .Fill)
                CGContextSetBlendMode(context, .Normal)
            }
            
        }
        showcaseImageView = UIImageView(image: UIGraphicsGetImageFromCurrentImageContext())
        UIGraphicsEndImageContext()
        showcaseImageView.alpha = 0.75
    }
    
    private func calculateRegion() {
        if let showcaseRect = showcaseRect {
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
            
            var largestIndex: Int = 0
            for (var i: Int = 0; i < areas.count; ++i) {
                if areas[i] > areas[largestIndex] {
                    largestIndex = i
                }
            }
            
            self.region = REGION.regionFromInt(largestIndex)
            
        }
    }
    
    private func setupText(withTitle title: String, detailsText details: String) {
        var titleSize = NSString(string: title).sizeWithAttributes([NSFontAttributeName : self.titleFont])
        titleSize.width = UIScreen.mainScreen().bounds.size.width
        
        var detailsSize = NSString(string: details).sizeWithAttributes([NSFontAttributeName : self.detailsFont])
        detailsSize.width = UIScreen.mainScreen().bounds.size.width
        
        let textPosition = self.getBestPositionOfTitle(withTitleSize: titleSize, withDetailsSize: detailsSize)
        
        if let region = self.region {
            
            if region == .LEFT || region == .RIGHT {
                if let showcaseRect = self.showcaseRect {
                    titleSize.width -= showcaseRect.size.width
                    detailsSize.width -= showcaseRect.size.width
                }
            }
            if self.region != .BOTTOM {
                self.titleLabel = UILabel(frame: textPosition[0])
                self.detailsLabel = UILabel(frame: textPosition[1])
            } else { // Bottom Region
                self.detailsLabel = UILabel(frame: textPosition[0])
                self.titleLabel = UILabel(frame: textPosition[1])
            }
        }
        
        titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.text = title
        titleLabel.textAlignment = self.titleTextAlignment
        titleLabel.textColor = self.titleColor
        titleLabel.font = self.titleFont
        
        detailsLabel.lineBreakMode =  NSLineBreakMode.ByWordWrapping
        detailsLabel.numberOfLines = 0
        detailsLabel.text = details
        detailsLabel.textAlignment = self.detailsTextAlignment
        detailsLabel.textColor = self.detailsColor
        detailsLabel.font = self.detailsFont
        
        titleLabel.sizeToFit()
        detailsLabel.sizeToFit()
        
        titleLabel.frame = CGRectMake(
            containerView.bounds.size.width / 2.0 - titleLabel.frame.size.width / 2.0,
            titleLabel.frame.origin.y,
            titleLabel.frame.size.width,
            titleLabel.frame.size.height)
        
        detailsLabel.frame = CGRectMake(
            containerView.bounds.size.width / 2.0 - detailsLabel.frame.size.width / 2.0,
            detailsLabel.frame.origin.y,
            detailsLabel.frame.size.width,
            detailsLabel.frame.size.height)
        
    }
    
    private func getBestPositionOfTitle(withTitleSize titleSize: CGSize, withDetailsSize detailsSize: CGSize) -> [CGRect] {
        var rect0: CGRect = CGRect(), rect1: CGRect = CGRect()
        
        if let region = self.region {
            
            switch region {
                
            case .TOP:
                rect0 = CGRectMake(
                    containerView.bounds.size.width / 2.0 - titleSize.width / 2.0,
                    titleSize.height + 64,
                    titleSize.width,
                    titleSize.height)
                rect1 = CGRectMake(
                    containerView.bounds.size.width / 2.0 - detailsSize.width / 2.0,
                    rect0.origin.y + rect0.size.height + detailsSize.height / 2.0,
                    detailsSize.width,
                    detailsSize.height)
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
        
        return [rect0, rect1]
    }
    
    private func getGesture() -> UIGestureRecognizer {
        let singleTap = UITapGestureRecognizer(target: self, action: "showcaseTapped")
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        return singleTap
    }
    
    internal func showcaseTapped() {
        UIView.animateWithDuration(
            0.5,
            animations: { () -> Void in
                self.alpha = 0
            }) { (Bool) -> Void in
                self.onAnimationComplete()
        }
    }
    
    private func onAnimationComplete() {
        self.recycleViews()
        if let delegate = delegate {
            if delegate.respondsToSelector("iShowcaseDismissed:") {
                delegate.iShowcaseDismissed!(self)
            }
        }
    }
    
    private func recycleViews() {
        if self.singleShotId != -1 {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: String(format: "iShowcase-%ld", self.singleShotId))
            self.singleShotId = -1
        }
        
        for view in self.containerView.subviews {
            view.userInteractionEnabled = true
        }
        
        showcaseImageView.removeFromSuperview()
        titleLabel.removeFromSuperview()
        detailsLabel.removeFromSuperview()
        self.removeFromSuperview()
    }
    
    public static func colorHexFromString(colorString: String) -> UIColor {
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