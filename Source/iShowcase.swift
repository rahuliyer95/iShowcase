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
    @objc optional func iShowcaseShown(_ showcase: iShowcase)
    /**
     Called when the showcase is removed from the view

     - showcase: The instance of the showcase removed
     */
    @objc optional func iShowcaseDismissed(_ showcase: iShowcase)
}

@objc open class iShowcase: UIView {

    // MARK: Properties

    /**
     Type of the highlight for the showcase

     - CIRCLE:    Creates a circular highlight around the view
     - RECTANGLE: Creates a rectangular highligh around the view
     */
    @objc public enum TYPE: Int {
        case circle = 0
        case rectangle = 1
    }

    fileprivate enum REGION: Int {
        case top = 0
        case left = 1
        case bottom = 2
        case right = 3

        static func regionFromInt(_ region: Int) -> REGION {
            switch region {
            case 0:
                return .top
            case 1:
                return .left
            case 2:
                return .bottom
            case 3:
                return .right
            default:
                return .top
            }
        }
    }

    fileprivate var containerView: UIView!
    fileprivate var showcaseRect: CGRect!
    fileprivate var region: REGION!
    fileprivate var targetView: UIView?
    fileprivate var showcaseImageView: UIImageView!

    /// Label to show the title of the showcase
    open var titleLabel: UILabel!
    /// Label to show the description of the showcase
    open var detailsLabel: UILabel!
    /// Color of the background for the showcase. Default is black
    open var coverColor: UIColor!
    /// Alpha of the background of the showcase. Default is 0.75
    open var coverAlpha: CGFloat!
    /// Color of the showcase highlight. Default is #1397C5
    open var highlightColor: UIColor!
    /// Type of the showcase to be created. Default is Rectangle
    open var type: TYPE!
    /// Radius of the circle with iShowcase type Circle. Default radius is 25
    open var radius: Float!
    /// Single Shot ID for iShowcase
    open var singleShotId: Int64!
    /// Delegate for handling iShowcase callbacks
    open var delegate: iShowcaseDelegate?

    // MARK: Initialize

    /**
     Initialize an instance of iShowcae
     */
    public init() {
        super.init(frame: CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height))
        setup()
    }

    /**
     This method is not supported
     */
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public

    /**
     Position the views on the screen for display
     */
    open override func layoutSubviews() {
        super.layoutSubviews()
        if showcaseImageView != nil {
            recycleViews()
        }
        if let view = targetView {
            showcaseRect = view.convert(view.bounds, to: containerView)
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
    open func setupShowcaseForView(_ view: UIView) {
        targetView = view
        setupShowcaseForLocation(view.convert(view.bounds, to: containerView))
    }

    /**
     Setup showcase for the item at 1st position (0th index) of the table

     - parameter tableView: Table whose item is to be highlighted
     */
    open func setupShowcaseForTableView(_ tableView: UITableView) {
        setupShowcaseForTableView(tableView, withIndexOfItem: 0, andSectionOfItem: 0)
    }

    /**
     Setup showcase for the item at the given indexpath

     - parameter tableView: Table whose item is to be highlighted
     - parameter indexPath: IndexPath of the item to be highlighted
     */
    open func setupShowcaseForTableView(_ tableView: UITableView,
        withIndexPath indexPath: IndexPath) {
            setupShowcaseForTableView(tableView,
                withIndexOfItem: (indexPath as NSIndexPath).row,
                andSectionOfItem: (indexPath as NSIndexPath).section)
    }

    /**
     Setup showcase for the item at the given index in the given section of the table

     - parameter tableView: Table whose item is to be highlighted
     - parameter row:       Index of the item to be highlighted
     - parameter section:   Section of the item to be highlighted
     */
    open func setupShowcaseForTableView(_ tableView: UITableView,
        withIndexOfItem row: Int, andSectionOfItem section: Int) {
            let indexPath = IndexPath(row: row, section: section)
            targetView = tableView.cellForRow(at: indexPath)
            setupShowcaseForLocation(tableView.convert(
                tableView.rectForRow(at: indexPath),
                to: containerView))
    }

    /**
     Setup showcase for the Bar Button in the Navigation Bar

     - parameter barButtonItem: Bar button to be highlighted
     */
    open func setupShowcaseForBarButtonItem(_ barButtonItem: UIBarButtonItem) {
        setupShowcaseForView(barButtonItem.value(forKey: "view") as! UIView)
    }

    /**
     Setup showcase to highlight a particular location on the screen

     - parameter location: Location to be highlighted
     */
    open func setupShowcaseForLocation(_ location: CGRect) {
        showcaseRect = location
    }

    /**
     Display the iShowcase
     */
    open func show() {
        if singleShotId != -1
        && UserDefaults.standard.bool(forKey: String(
            format: "iShowcase-%ld", singleShotId)) {
                return
        }

        self.alpha = 1
        for view in containerView.subviews {
            view.isUserInteractionEnabled = false
        }

        UIView.transition(
            with: containerView,
            duration: 0.5,
            options: UIViewAnimationOptions.transitionCrossDissolve,
            animations: { () -> Void in
                self.containerView.addSubview(self)
        }) { (_) -> Void in
                if let delegate = self.delegate {
                    if delegate.responds(to: #selector(iShowcaseDelegate.iShowcaseShown)) {
                        delegate.iShowcaseShown!(self)
                    }
                }
        }
    }

    // MARK: Private

    fileprivate func setup() {
        self.backgroundColor = UIColor.clear
        containerView = UIApplication.shared.delegate!.window!
        coverColor = UIColor.black
        highlightColor = UIColor.colorFromHexString("#1397C5")
        coverAlpha = 0.75
        type = .rectangle
        radius = 25
        singleShotId = -1

        // Setup title label defaults
        titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel.numberOfLines = 0

        // Setup details label defaults
        detailsLabel = UILabel()
        detailsLabel.font = UIFont.systemFont(ofSize: 16)
        detailsLabel.textColor = UIColor.white
        detailsLabel.textAlignment = .center
        detailsLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        detailsLabel.numberOfLines = 0
    }

    fileprivate func draw() {
        setupBackground()
        calculateRegion()
        setupText()
    }

    fileprivate func setupBackground() {
        UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size,
            false, UIScreen.main.scale)
        var context: CGContext? = UIGraphicsGetCurrentContext()
        context?.setFillColor(coverColor.cgColor)
        context?.fill(containerView.bounds)

        if type == .rectangle {
            if let showcaseRect = showcaseRect {

                // Outer highlight
                let highlightRect = CGRect(
                    x: showcaseRect.origin.x - 15,
                    y: showcaseRect.origin.y - 15,
                    width: showcaseRect.size.width + 30,
                    height: showcaseRect.size.height + 30)

                context?.setShadow(offset: CGSize.zero, blur: 30, color: highlightColor.cgColor)
                context?.setFillColor(coverColor.cgColor)
                context?.setStrokeColor(highlightColor.cgColor)
                context?.addPath(UIBezierPath(rect: highlightRect).cgPath)
                context?.drawPath(using: .fillStroke)

                // Inner highlight
                context?.setLineWidth(3)
                context?.addPath(UIBezierPath(rect: showcaseRect).cgPath)
                context?.drawPath(using: .fillStroke)

                let showcase = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                // Clear region
                UIGraphicsBeginImageContext((showcase?.size)!)
                showcase?.draw(at: CGPoint.zero)
                context = UIGraphicsGetCurrentContext()
                context?.clear(showcaseRect)
            }
        } else {
            if let showcaseRect = showcaseRect {
                let center = CGPoint(
                    x: showcaseRect.origin.x + showcaseRect.size.width / 2.0,
                    y: showcaseRect.origin.y + showcaseRect.size.height / 2.0)

                // Draw highlight
                context?.setLineWidth(2.54)
                context?.setShadow(offset: CGSize.zero, blur: 30, color: highlightColor.cgColor)
                context?.setFillColor(coverColor.cgColor)
                context?.setStrokeColor(highlightColor.cgColor)
                context?.addArc(center: center, radius: CGFloat(radius * 2), startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: false)
                context?.drawPath(using: .fillStroke)
                context?.addArc(center: center, radius: CGFloat(radius), startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: false)
                context?.drawPath(using: .fillStroke)

                // Clear circle
                context?.setFillColor(UIColor.clear.cgColor)
                context?.setBlendMode(.clear)
                context?.addArc(center: center, radius: CGFloat(radius - 0.54), startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: false)
                context?.drawPath(using: .fill)
                context?.setBlendMode(.normal)
            }
        }
        showcaseImageView = UIImageView(image: UIGraphicsGetImageFromCurrentImageContext())
        showcaseImageView.alpha = coverAlpha
        UIGraphicsEndImageContext()
    }

    fileprivate func calculateRegion() {
        let left = showcaseRect.origin.x,
            right = showcaseRect.origin.x + showcaseRect.size.width,
            top = showcaseRect.origin.y,
            bottom = showcaseRect.origin.y + showcaseRect.size.height

        let areas = [
            top * UIScreen.main.bounds.size.width, // Top region
            left * UIScreen.main.bounds.size.height, // Left region
            (UIScreen.main.bounds.size.height - bottom)
                * UIScreen.main.bounds.size.width, // Bottom region
            (UIScreen.main.bounds.size.width - right)
                - UIScreen.main.bounds.size.height // Right region
        ]

        var largestIndex = 0
        for i in 0..<areas.count {
            if areas[i] > areas[largestIndex] {
                largestIndex = i
            }
        }
        region = REGION.regionFromInt(largestIndex)
    }

    fileprivate func setupText() {
        titleLabel.frame = containerView.frame
        detailsLabel.frame = containerView.frame
        
        titleLabel.sizeToFit()
        detailsLabel.sizeToFit()
        
        let textPosition = getBestPositionOfTitle(
            withTitleSize: titleLabel.bounds.size,
            withDetailsSize: detailsLabel.bounds.size)

        if region == .bottom {
            detailsLabel.frame = textPosition.0
            titleLabel.frame = textPosition.1
        } else {
            titleLabel.frame = textPosition.0
            detailsLabel.frame = textPosition.1
        }

        titleLabel.frame = CGRect(
            x: containerView.bounds.size.width / 2.0 - titleLabel.frame.size.width / 2.0,
            y: titleLabel.frame.origin.y,
            width: titleLabel.frame.size.width - (region == .left || region == .right
                    ? showcaseRect.size.width
                    : 0),
            height: titleLabel.frame.size.height)
        titleLabel.sizeToFit()
        
        detailsLabel.frame = CGRect(
            x: containerView.bounds.size.width / 2.0 - detailsLabel.frame.size.width / 2.0,
            y: detailsLabel.frame.origin.y + titleLabel.frame.size.height / 2,
            width: detailsLabel.frame.size.width - (region == .left || region == .right
                    ? showcaseRect.size.width
                    : 0),
            height: detailsLabel.frame.size.height)
        detailsLabel.sizeToFit()
    }

    fileprivate func getBestPositionOfTitle(withTitleSize titleSize: CGSize,
        withDetailsSize detailsSize: CGSize) -> (CGRect, CGRect) {
            var rect0 = CGRect(), rect1 = CGRect()
            if let region = self.region {
                switch region {
                case .top:
                    rect0 = CGRect(
                        x: containerView.bounds.size.width / 2.0 - titleSize.width / 2.0,
                        y: titleSize.height + 20,
                        width: titleSize.width,
                        height: titleSize.height)
                    rect1 = CGRect(
                        x: containerView.bounds.size.width / 2.0 - detailsSize.width / 2.0,
                        y: rect0.origin.y + rect0.size.height + detailsSize.height / 2.0,
                        width: detailsSize.width,
                        height: detailsSize.height)
                    break
                case .left:
                    rect0 = CGRect(
                        x: 0,
                        y: containerView.bounds.size.height / 2.0,
                        width: titleSize.width,
                        height: titleSize.height)
                    rect1 = CGRect(
                        x: 0,
                        y: rect0.origin.y + rect0.size.height + detailsSize.height / 2.0,
                        width: detailsSize.width,
                        height: detailsSize.height)
                    break
                case .bottom:
                    rect0 = CGRect(
                        x: containerView.bounds.size.width / 2.0 - detailsSize.width / 2.0,
                        y: containerView.bounds.size.height - detailsSize.height * 2.0,
                        width: detailsSize.width,
                        height: detailsSize.height)
                    rect1 = CGRect(
                        x: containerView.bounds.size.width / 2.0 - titleSize.width / 2.0,
                        y: rect0.origin.y - rect0.size.height - titleSize.height / 2.0,
                        width: titleSize.width,
                        height: titleSize.height)
                    break
                case .right:
                    rect0 = CGRect(
                        x: containerView.bounds.size.width - titleSize.width,
                        y: containerView.bounds.size.height / 2.0,
                        width: titleSize.width,
                        height: titleSize.height)
                    rect1 = CGRect(
                        x: containerView.bounds.size.width - detailsSize.width,
                        y: rect0.origin.y + rect0.size.height + detailsSize.height / 2.0,
                        width: detailsSize.width,
                        height: detailsSize.height)
                    break
                }
            }

            return (rect0, rect1)
    }

    fileprivate func getGestureRecgonizer() -> UIGestureRecognizer {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(showcaseTapped))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        return singleTap
    }

    @objc internal func showcaseTapped() {
        UIView.animate(
            withDuration: 0.5,
            animations: { () -> Void in
                self.alpha = 0
        }, completion: { (_) -> Void in
                self.onAnimationComplete()
        }) 
    }

    fileprivate func onAnimationComplete() {
        if singleShotId != -1 {
            UserDefaults.standard.set(true, forKey: String(
                format: "iShowcase-%ld", singleShotId))
            singleShotId = -1
        }
        for view in self.containerView.subviews {
            view.isUserInteractionEnabled = true
        }
        recycleViews()
        self.removeFromSuperview()
        if let delegate = delegate {
            if delegate.responds(to: #selector(iShowcaseDelegate.iShowcaseDismissed)) {
                delegate.iShowcaseDismissed!(self)
            }
        }
    }

    fileprivate func recycleViews() {
        showcaseImageView.removeFromSuperview()
        titleLabel.removeFromSuperview()
        detailsLabel.removeFromSuperview()
    }

}

// MARK: UIColor extension

public extension UIColor {

    /**
     Parse a hex string for its `ARGB` components and return a `UIColor` instance

     - parameter colorString: A string representing the color hex to be parsed
     - returns: A UIColor instance containing the parsed color
     */
    public static func colorFromHexString(_ colorString: String) -> UIColor {
        let hex = colorString.trimmingCharacters(
            in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return UIColor.clear
        }
        return UIColor(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255)
    }
}
