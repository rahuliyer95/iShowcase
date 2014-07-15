//
//  iShowcase.h
//  iShowcase
//
//  Created by Rahul Iyer
//  This software is released under the MIT License.
//
//  Copyright (c) 2014 Rahul Iyer
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//  Except as contained in this notice, the name(s) of the above copyright holders shall not be used in advertising or otherwise to promote the sale, use or other dealings in this Software without prior written authorization.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol iShowcaseDelegate <NSObject>

- (void) iShowcaseShown;
- (void) iShowcaseDismissed;

@end

@interface iShowcase : UIView

@property (nonatomic, assign) id delegate;

- (id) initWithTitleFont: (UIFont*) titleFont detailsFont: (UIFont*) detailsFont;
- (id) initWithTitleColor: (UIColor*) titleColor detailsColor: (UIColor*) detailsColor;
- (id) initWithTitleFont:(UIFont*) titleFont detailsFont:(UIFont*) detailsFont titleColor:(UIColor*) titleColor detailsColor:(UIColor*) detailsColor;
- (void) setBackgroundColor:(UIColor *)backgroundColor;
- (void) setHighlightColor:(UIColor*) highlightColor;
- (void) setTitleFont: (UIFont*) font;
- (void) setDetailsFont: (UIFont*) font;
- (void) setTitleColor: (UIColor*) color;
- (void) setDetailsColor: (UIColor*) color;
- (void) setContainerView: (id) container;
- (void) setIType: (int) type;
- (void) setRadius: (CGFloat) radius;
- (void) setupShowcaseForTarget: (id) target title: (NSString*) title details: (NSString*) details;
- (void) setupShowcaseForLocation: (CGRect) location title: (NSString*) title details: (NSString*) details;
- (void) show;
- (void) showInContainer: (id) container;
+ (UIColor*) colorFromHexString : (NSString*) hexCode;

@end

extern const int TYPE_CIRCLE;
extern const int TYPE_RECTANGLE;
