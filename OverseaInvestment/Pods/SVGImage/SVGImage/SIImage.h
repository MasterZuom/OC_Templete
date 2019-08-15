//
//  SIImage.h
//  SVGImage
//
//  Created by sodas on 4/22/14.
//
/*
 Copyright 2014 sodas tsai
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SIImage : NSObject

+ (instancetype)imageNamed:(NSString *)imageName;

+ (instancetype)imageWithContentsOfFile:(NSString *)path;
+ (instancetype)imageWithContentsOfURL:(NSURL *)url;
+ (instancetype)imageWithXMLData:(NSData *)data;
+ (instancetype)imageWithXMLString:(NSString *)string;

- (instancetype)initWithContentsOfFile:(NSString *)path;
- (instancetype)initWithContentsOfURL:(NSURL *)url;
- (instancetype)initWithXMLData:(NSData *)data;
- (instancetype)initWithXMLString:(NSString *)string;

@property (nonatomic, assign, readonly) CGSize originalSize;

@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign, readonly) CGSize size;

@property (nonatomic, strong, readonly) UIImage *UIImage;

@end
