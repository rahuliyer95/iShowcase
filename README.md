# iShowcase

Highlight individual parts of your application using iShowcase

## Screenshots

<img style="float : left" src="screenshot/1.png" width="320" height="568">
<img style="float : right" src="screenshot/2.png" width="320" height="568">
<img style="float : left" src="screenshot/3.png" width="320" height="568">
<img style="float : right" src="screenshot/4.png" width="320" height="568">

## Requirements
* Xcode 5 or higher
* Apple LLVM compiler
* iOS 6.0 or higher
* ARC

## Installation

iShowcase is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "iShowcase"

or

* Add the `iShowcase.h` and `iShowcase.m` files to your project
* Add `#include "iShowcase.h"` to your ViewController

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

#### Creating Instance

``` objective-c
// Create Object of iShowcase
iShowcase *showcase = [[iShowcase alloc] init];

// Other init Methods
initWithTitleFont: (UIFont*) titleFont detailsFont: (UIFont*) detailsFont;
initWithTitleColor: (UIColor*) titleColor detailsColor: (UIColor*) detailsColor;
```
#### Delegate

``` objective-c
showcase.delegate = self;
```
#### Delegate Methods

``` objective-c
iShowcaseShown // Called When Showcase is displayed
iShowcaseDismissed // Called When Showcase is removed
```

#### Displaying iShowcase
``` objective-c
[showcase setupShowcaseForTarget:(view_to_target) title:(NSString *) details:<#(NSString *)];
[showcase show];

// For Custom Location
[showcase setupShowcaseForLocation:(CGRect location) title:(NSString *) details:(NSString *)];
[showcase show];
```

#### Customizations

``` objective-c

// Constants
const int TYPE_CIRCLE = 0;
const int TYPE_RECTANGLE = 1;

setBackgroundColor: (UIColor *) backgroundColor;
setTitleFont: (UIFont*) font;
setDetailsFont: (UIFont*) font;
setTitleColor: (UIColor*) color;
setDetailsColor: (UIColor*) color;
setHighlightColor:(UIColor*) highlightColor;
setIType: (int) type;
setRadius: (CGFloat) radius;
```

## Credits

Inspired from [ShowcaseView](https://github.com/amlcurran/Showcaseview) by [Alex Curran](https://github.com/amlcurran/)

## Author

rahuliyer95, rahuliyer573@gmail.com

## License

iShowcase is available under the MIT license. See the LICENSE file for more info.

