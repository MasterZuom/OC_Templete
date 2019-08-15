//
//  CFCountryFlags.m
//  CFCountryFlags
//
//  Created by Marcin Łępicki on 25.09.2014.
//  Copyright (c) 2014 Marcin Lepicki. All rights reserved.
//

#import "CFCountryFlags.h"

@implementation CFCountryFlags

+ (SIImage *) flagImageForCode:(NSString *)countryCode {
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *svgPath = [bundle pathForResource:[countryCode lowercaseString] ofType:@"svg" inDirectory:@"CFCountryFlags.bundle"];
    
    return [SIImage imageWithContentsOfFile:svgPath];
}


@end
