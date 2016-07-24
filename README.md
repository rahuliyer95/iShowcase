# iShowcase

Highlight individual parts of your application using iShowcase

[![CI Status](http://img.shields.io/travis/rahuliyer95/iShowcase.svg?style=flat)](https://travis-ci.org/rahuliyer95/iShowcase)
[![Version](https://img.shields.io/cocoapods/v/iShowcase.svg?style=flat)](http://cocoadocs.org/docsets/iShowcase)
[![License](https://img.shields.io/cocoapods/l/iShowcase.svg?style=flat)](http://cocoadocs.org/docsets/iShowcase)
[![Platform](https://img.shields.io/cocoapods/p/iShowcase.svg?style=flat)](http://cocoadocs.org/docsets/iShowcase)
[![Issues](https://img.shields.io/github/issues/rahuliyer95/iShowcase.svg?style=flat)](http://www.github.com/rahuliyer95/iShowcase/issues?state=open)

![1](assets/1.png)

## Requirements
* iOS 7.0 or higher
* ARC

## Installation

iShowcase is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "iShowcase", "~> 2.0"

or

### Swift
  * Add `iShowcase.swift` file to your project

## [Documentation](http://rahuliyer95.github.io/iShowcase/)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

#### Creating Instance

``` swift
// Create Object of iShowcase
let showcase = iShowcase()
```

#### Delegate

``` swift
showcase.delegate = self;
```

#### Delegate Methods

``` objective-c
iShowcaseShown // Called When Showcase is displayed
iShowcaseDismissed // Called When Showcase is removed
```

#### Displaying iShowcase

``` swift
showcase.setupShowcaseForView(view: UIView)
showcase.titleLabel.text = "Default"
showcase.detailsLabel.text = "This is default iShowcase!"
showcase.show()

// For custom location

setupShowcaseForLocation(location: CGRect)

// Methods for other UI Elements

setupShowcaseForTableView(tableView: UITableView)
setupShowcaseForTableView(tableView: UITableView, withIndexPath: NSIndexPath)
setupShowcaseForTableView(tableView: UITableView, withIndexOfItem: Int, andSectionOfItem: Int)
setupShowcaseForBarButtonItem(barButtonItem: UIBarButtonItem)
```

#### Customizations

``` swift
public enum TYPE: Int {
    case CIRCLE = 0
    case RECTANGLE = 1
}

titleLabel: UILabel
detailsLabel: UILabel
coverColor: UIColor
coverAlpha: CGFloat
highlightColor: UIColor
type: TYPE
radius: Float
singleShotId: Int64
```

## Screenshots

![2](assets/2.png)
![3](assets/3.png)
![4](assets/4.png)
![5](assets/5.png)

## Credits

Inspired from [ShowcaseView](https://github.com/amlcurran/Showcaseview) by [Alex Curran](https://github.com/amlcurran/)

## Author

rahuliyer95, rahuliyer573@gmail.com

## License

iShowcase is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
