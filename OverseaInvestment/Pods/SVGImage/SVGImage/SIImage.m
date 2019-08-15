//
//  SIImage.m
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

#import "SIImage.h"
#import <JavaScriptCore/JavaScriptCore.h>

#pragma mark - Web View Utils

@interface SIImageWebView : UIWebView

@end

@implementation SIImageWebView

- (void)dealloc {
    // Ref: http://www.codercowboy.com/code-uiwebview-memory-leak-prevention/
    [self stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML='';"];
    [self loadHTMLString:@"" baseURL:nil];
    [self stopLoading];
    self.delegate = nil;
    self.dataDetectorTypes = UIDataDetectorTypeNone;
    [self removeFromSuperview];
}

@end

#pragma mark - SVG Info Object

@interface SISVGInfo : NSObject

@property(nonatomic, assign, readonly) CGSize imageSize;

- (instancetype)initWithXMLData:(NSData *)data;

@end

#pragma mark - Extension

@interface SIImage ()

@property(nonatomic, strong) NSData *contentData;

@property(nonatomic, assign, readwrite) CGSize originalSize;
@property(nonatomic, strong, readwrite) UIImage *UIImage;

@end

#pragma mark - Main Implementation

static void *SIImageKVOContext = &SIImageKVOContext;

@implementation SIImage

+ (instancetype)imageWithContentsOfFile:(NSString *)path {
    return [[self alloc] initWithContentsOfFile:path];
}

+ (instancetype)imageWithContentsOfURL:(NSURL *)url {
    return [[self alloc] initWithContentsOfURL:url];
}

+ (instancetype)imageWithXMLData:(NSData *)data {
    return [[self alloc] initWithXMLData:data];
}

+ (instancetype)imageWithXMLString:(NSString *)string {
    return [[self alloc] initWithXMLString:string];
}

+ (instancetype)imageNamed:(NSString *)imageName {
    SIImage *result = [[self objectCache] objectForKey:imageName];
    if (!result) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:[imageName stringByDeletingPathExtension]
                                             withExtension:[imageName pathExtension] ?: @"svg"];
        result = [[self alloc] initWithURL:url];
        NSUInteger cost = result.originalSize.width * result.originalSize.height / 1000.;
        [[self objectCache] setObject:result forKey:imageName cost:cost];
    }

    return result;
}

#pragma mark - Object Lifecycle

- (instancetype)initWithContentsOfFile:(NSString *)path {
    return [self initWithXMLData:[NSData dataWithContentsOfFile:path]];
}

- (instancetype)initWithContentsOfURL:(NSURL *)url {
    return [self initWithXMLData:[NSData dataWithContentsOfURL:url]];
}

- (instancetype)initWithXMLString:(NSString *)string {
    return [self initWithXMLData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

- (instancetype)initWithXMLData:(NSData *)data {
    if (self = [super init]) {
        _contentData = data;

        _scale = 1.;
        _originalSize = CGSizeMake(-1., -1.);

        [self addObserver:self forKeyPath:@"scale" options:0 context:SIImageKVOContext];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMemoryWarning:)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"scale" context:SIImageKVOContext];
}

#pragma mark - Notification

- (void)didReceiveMemoryWarning:(NSNotification *)notification {
    _UIImage = nil;
}

#pragma mark - Bundle Image Cache

+ (NSCache *)objectCache {
    static NSCache *objectCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objectCache = [[NSCache alloc] init];
        objectCache.countLimit = 10;
        objectCache.totalCostLimit = 1820; // 320*568*10 / 1000
    });
    return objectCache;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (context == SIImageKVOContext && object == self && [keyPath isEqualToString:@"scale"]) {
        // Clean cached object
        _UIImage = nil;
    }
}

#pragma mark - Core Method

- (NSString *)htmlStringWithSize:(CGSize)size {
    static NSString *htmlStringTemplate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        htmlStringTemplate =
        @"<!DOCTYPE html><html>"
        @"<head><meta name=\"viewport\" content=\"width=%.3lf, user-scalable=no\"></head>"
        @"<body style=\"padding:0;margin:0;background:transparent;\">"
        @"<img src=\"data:image/svg+xml;charset=utf-8;base64,%@\" onload=\"loaded()\" width=\"%.3lf\" height=\"%.3lf\">"
        @"</body></html>";
    });

    return [NSString stringWithFormat:htmlStringTemplate,
            size.width,
            [self.contentData base64EncodedStringWithOptions:0],
            size.width, size.height];
}

- (UIWebView *)_uiWebViewWithImageDrawnInSize:(CGSize)size originalImageSize:(out CGSize *)outImageSize {
    NSAssert([NSThread isMainThread], @"This method should be called only on main thread");

    BOOL __block imageLoaded = NO;

    // Create UIWebView
    UIWebView *webView = [[SIImageWebView alloc] initWithFrame:(CGRect) {.origin = CGPointZero, .size = size}];
    webView.opaque = NO;
    webView.backgroundColor = [UIColor clearColor];

    // Add JS Method
    JSContext *jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSAssert([jsContext isKindOfClass:[JSContext class]], @"Cannot get JSContext from UIWebView");
    jsContext[@"loaded"] = ^{
        // Get natural size
        if (outImageSize) {
            JSValue *imageElement = [[JSContext currentContext] globalObject][@"document"][@"images"][0];
            CGFloat width = [imageElement[@"naturalWidth"] toDouble];
            CGFloat height = [imageElement[@"naturalHeight"] toDouble];
            *outImageSize = CGSizeMake(width, height);
        }
        // Done
        imageLoaded = YES;
    };

    // Load HTML
    NSString *srcString = [NSString stringWithFormat:@"data:image/svg+xml;charset=utf-8;base64,%@",
                           [self.contentData base64EncodedStringWithOptions:0]];
    NSString *htmlString =
    [NSString stringWithFormat:@"<!DOCTYPE html><html>"
                               @"<head><meta name=\"viewport\" content=\"width=%.3lf, user-scalable=no\"></head>"
                               @"<body style=\"padding:0;margin:0;background:transparent;\">"
                               @"<img src=\"%@\" onload=\"loaded()\" width=\"%.3lf\" height=\"%.3lf\"></body></html>",
                               size.width, srcString, size.width, size.height];
    [webView loadHTMLString:htmlString baseURL:nil];

    // Wait
    while (!imageLoaded) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:.01]];
    }

    return webView;
}

#pragma mark - Interface

- (BOOL)hasOriginalSize {
    return !(_originalSize.width < 0 || _originalSize.height < 0);
}

- (CGSize)originalSize {
    if (![self hasOriginalSize]) {
        // Get from SVG Info (XML)
        SISVGInfo *svgInfo = [[SISVGInfo alloc] initWithXMLData:self.contentData];
        CGSize imageSize = svgInfo.imageSize;

        if (imageSize.width < 0 || imageSize.height < 0) {
            // Failed to get size from XML ... render it to get
            [self _uiWebViewWithImageDrawnInSize:CGSizeZero originalImageSize:&imageSize];
        }

        _originalSize = imageSize;
    }
    return _originalSize;
}

- (UIImage *)UIImage {
    if (!_UIImage) {
        // Calc size
        CGFloat scale = self.scale;
        CGSize finalSize = CGSizeMake(self.originalSize.width * scale, self.originalSize.height * scale);

        // Get Web View
        UIWebView *webView = [self _uiWebViewWithImageDrawnInSize:finalSize originalImageSize:nil];

        // Draw
        UIGraphicsBeginImageContextWithOptions(finalSize, NO, 0.);
        [webView.layer renderInContext:UIGraphicsGetCurrentContext()];
        _UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _UIImage;
}

@end

#pragma mark - SVG Info Object Implementation

@interface SISVGInfo () <NSXMLParserDelegate>

@property(nonatomic, strong) NSData *contentData;
@property(nonatomic, assign, readwrite) CGSize imageSize;

@end

@implementation SISVGInfo

- (instancetype)initWithXMLData:(NSData *)data {
    if (self = [super init]) {
        _contentData = data;
        _imageSize = CGSizeMake(-1., -1.);
        [self parse];
    }
    return self;
}

- (void)parse {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.contentData];
    parser.delegate = self;
    [parser parse];
}

#pragma mark NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser
    didStartElement:(NSString *)elementName
       namespaceURI:(NSString *)namespaceURI
      qualifiedName:(NSString *)qName
         attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"svg"]) {
        // Get size from width/height attribute
        NSString *widthString = attributeDict[@"width"];
        NSString *heightString = attributeDict[@"height"];
        if (widthString && heightString) {
            CGFloat width = [widthString doubleValue];
            CGFloat height = [heightString doubleValue];
            if (width >= 0 && height >= 0)
                self.imageSize = CGSizeMake(width, height);
        }

        // End parsing
        [parser abortParsing];
    }
}

@end
