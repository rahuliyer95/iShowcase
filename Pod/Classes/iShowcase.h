//
//  iShowcase.h
//  iShowcase
//
//  Created by Rahul Iyer
//  This software is released under the MIT License.
//
//  Copyright (c) 2015 Rahul Iyer
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//
//  Except as contained in this notice, the name(s) of the above copyright
//  holders shall not be used in advertising or otherwise to promote the sale,
//  use or other dealings in this Software without prior written authorization.

#import <UIKit/UIKit.h>

@interface iShowcase : UIView

/*!
 *  @brief  iShowcaseDelegate for callback actions
 */
@property(nonatomic, assign) id delegate;
/*!
 *  Initialize an instance of iShowcase
 *
 *  @param titleFont   Custom font for the title
 *  @param detailsFont Custom font for the description
 *
 *  @return Instance of iShowcase
 */
- (id)initWithTitleFont:(UIFont *)titleFont detailsFont:(UIFont *)detailsFont;
/*!
 *  Initialize an instance of iShowcase
 *
 *  @param titleColor   Custom color for the title
 *  @param detailsColor Custom color for the description
 *
 *  @return Instance of iShowcase
 */
- (id)initWithTitleColor:(UIColor *)titleColor
            detailsColor:(UIColor *)detailsColor;
/*!
 *  Initialize an instance of iShowcase
 *
 *  @param titleFont    Custom font for the title
 *  @param detailsFont  Custom font for the description
 *  @param titleColor   Custom color for the title
 *  @param detailsColor Custom color for the description
 *
 *  @return Instance of iShowcase
 */
- (id)initWithTitleFont:(UIFont *)titleFont
            detailsFont:(UIFont *)detailsFont
             titleColor:(UIColor *)titleColor
           detailsColor:(UIColor *)detailsColor;
/*!
 *  Set the background color
 *
 *  @param backgroundColor Color of the background
 *  @code  Default: [UIColor blackColor]
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor;
/*!
 *  Set the color of the highlight drawn around the region to be showcased
 *
 *  @param highlightColor Color of the highlight drawn around the region to be
 *showcased
 *  @code  Default: #1397C5
 */
- (void)setHighlightColor:(UIColor *)highlightColor;
/*!
 *  Set the font of the title
 *
 *  @param font Font of the title
 *  @code  Default: [UIFont boldSystemFontOfSize:24.0f]
 */
- (void)setTitleFont:(UIFont *)font;
/*!
 *  @brief  Set the font for the description
 *
 *  @param font Font for the description
 *  @code  Default: [UIFont systemFontOfSize:16.0f]
 */
- (void)setDetailsFont:(UIFont *)font;
/*!
 *  @brief  Set the color for the title
 *
 *  @param color Color of the title
 *  @code  Default: [UIColor whiteColor]
 */
- (void)setTitleColor:(UIColor *)color;
/*!
 *  @brief  Set the color for the description
 *
 *  @param color Color for the description
 *  @code  Default: [UIColor whiteColor]
 */
- (void)setDetailsColor:(UIColor *)color;
/*!
 *  @brief  The iSHowcase instance for the give single shot will be shown only
 *once.
 *
 *  @param singleShotId Custom id for the paricular instance of the showcase
 */
- (void)setSingleShotId:(long)singleShotId;
/*!
 *  @brief  Set the type of showcase highlight
 *
 *  @param type TYPE_RECTANGLE (default) highlights the desired view in a
 *rectangular frame
 *              TYPE_CIRCLE highlights the desired view in a circular frame
 */
- (void)setIType:(int)type;
/*!
 *  @brief  Set the radius for the circular highlight on the view
 *
 *  @param radius Value (default 25.0f) of the radius for circular frame
 */
- (void)setRadius:(CGFloat)radius;
/*!
 *  @brief  Setup the showcase for a view
 *
 *  @param view    The view to be highlighted
 *  @param title   Title for the showcase
 *  @param details Description of the showcase
 */
- (void)setupShowcaseForView:(UIView *)view
                   withTitle:(NSString *)title
                     details:(NSString *)details;
/*!
 *  @brief  Setup showcase for the item at 1st position (0th index) of the table
 *
 *  @param tableView Table whose item is to be highlighted
 *  @param title     Title for the showcase
 *  @param details   Description of the showcase
 */
- (void)setupShowcaseForTableView:(UITableView *)tableView
                        withTitle:(NSString *)title
                          details:(NSString *)details;
/*!
 *  @brief  Setup showcase for the item at the given index in the given section
 *of the table
 *
 *  @param tableView Table whose item is to be highlighted
 *  @param index     Index of the item to be highlighted
 *  @param section   Section of the item to be highlighted
 *  @param title     Title for the showcase
 *  @param details   Description of the showcase
 */
- (void)setupShowcaseForTableView:(UITableView *)tableView
                  withIndexOfItem:(NSUInteger)index
                    sectionOfItem:(NSUInteger)section
                            title:(NSString *)title
                          details:(NSString *)details;
/*!
 *  @brief  Setup showcase for the Bar Button in the Navigation Bar
 *
 *  @param barButtonItem Bar button to be highlighted
 *  @param title         Title for the showcase
 *  @param details       Description of the showcase
 */
- (void)setupShowcaseForBarButtonItem:(UIBarButtonItem *)barButtonItem
                            withTitle:(NSString *)title
                              details:(NSString *)details;
/*!
 *  @brief  Setup showcase to highlight a particular location on the screen
 *
 *  @param location Location to be highlighted
 *  @param title    Title for the showcase
 *  @param details  Description of the showcase
 */
- (void)setupShowcaseForLocation:(CGRect)location
                       withTitle:(NSString *)title
                         details:(NSString *)details;
/*!
 *  @brief  Display the iShowcase
 */
- (void)show;
/*!
 *  @brief  Get the color value from a color hex string
 *
 *  @param hexCode Hex value of the color
 *
 *  @return UIColor object for the hex value of the color
 */
+ (UIColor *)colorFromHexString:(NSString *)hexCode;

@end

/*!
 *  @brief  iShowcaseDelegate protocol for callback actions
 */
@protocol iShowcaseDelegate <NSObject>
@optional

- (void)iShowcaseShown:(iShowcase *)showcase;
- (void)iShowcaseDismissed:(iShowcase *)showcase;

@end

/*!
 *  @brief  Circular frame for highlight
 */
extern const int TYPE_CIRCLE;
/*!
 *  @brief  Rectangular frame for highlight
 */
extern const int TYPE_RECTANGLE;
