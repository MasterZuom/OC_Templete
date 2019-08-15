//
//  OIAssetInjectionViewController.h
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/16.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OIAssetInjectionViewController : UIViewController

///webView需要加载的DW的url(此url还需要拼接上 &userID=  &sessionKey= &lang=)
@property(nonatomic,copy)NSString *DWUrl;

@end
