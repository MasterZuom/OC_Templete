# CFCountryFlags

Helper for displaying country flags, rendered from SVG files with help of SVGImage pod.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

This pod is using SVGImage https://bitbucket.org/sodastsai/svgimage and derives all it's requirements

## Installation

CFCountryFlags is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "CFCountryFlags"

You can also try to point your cocoapods directly to this repository 
    pod 'CFCountryFlags', :git => 'https://github.com/codingfingers/CFCountryFlags.git'

## Usage

Add following import to your class:
    #import <SVGImage/SIImage.h>
    #import <CFCountryFlags/CFCountryFlags.h>

Create SIImage class with flag: 
    SIImage *svgImage = [CFCountryFlags flagImageForCode:@"PL"];

Use UIImage property to get rendered class:     
    [self.flagView setImage:[svgImage UIImage]];

## Author

Marcin Lepicki, marcin@codingfingers.com
http://codingfingers.com - Mobile Software House. We develop iOS and Android native apps. 

## License

CFCountryFlags is available under the MIT license. See the LICENSE file for more info.

