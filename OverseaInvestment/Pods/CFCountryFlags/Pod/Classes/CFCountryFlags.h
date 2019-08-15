//
//  CFCountryFlags.h
//  CFCountryFlags
//
//  Created by Marcin Łępicki on 25.09.2014.
//  Copyright (c) 2014 Marcin Lepicki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SVGImage/SIImage.h>

@interface CFCountryFlags : NSObject

+ (SIImage *) flagImageForCode:(NSString *)countryCode;

@end
