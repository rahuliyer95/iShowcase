<<<<<<< HEAD
# iShowcase

Highlight individual parts of your application using iShowcase

## Screenshots

<img style="float : left" src="screenshot/1.png" width="320" height="568">
<img style="float : right" src="screenshot/2.png" width="320" height="568">
<img src="screenshot/3.png" width="320" height="568">

## Requirements
* Xcode 5 or higher
* Apple LLVM compiler
* iOS 6.0 or higher
* ARC

 
* Add the `iShowcase.h` and `iShowcase.m` files to your project
* Add `#include "iShowcase.h"` to your ViewController

## Usage

#### Creating Instance

``` objective-c
// Create Object of iShowcase
iShowcase *showcase = [[iShowcase alloc] init];
[showcase setContainerView: self.view];

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
[showcase setupShowcaseForLocation:(CGRect location) title:(NSString *)#details:(NSString *)];
[showcase show];
```

#### Customizations

``` objective-c
setBackgroundColor: (UIColor *) backgroundColor;
setTitleFont: (UIFont*) font;
setDetailsFont: (UIFont*) font;
setTitleColor: (UIColor*) color;
setDetailsColor: (UIColor*) color;
```

## Credits

Inspired from [ShowcaseView](https://github.com/amlcurran/Showcaseview) by [Alex Curran](https://github.com/amlcurran/)

## License

iShowcase is available under MIT license

```
Copyright (c) 2014 Rahul Iyer

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Except as contained in this notice, the name(s) of the above copyright holders shall not be used in advertising or otherwise to promote the sale, use or other dealings in this Software without prior written authorization.
```
=======
iShowcase
=========
>>>>>>> f95e900d8f47e814d8511339caeab5a8f1e8c613
