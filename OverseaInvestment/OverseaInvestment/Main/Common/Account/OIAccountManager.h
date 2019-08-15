//
//  OIAccountManager.h
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/7.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OIUserAccount.h"

///登录成功的通知
#define kAccountManagerDidUserLoginNotification @"kAccountManagerDidUserLoginNotification"
//登录失败的通知
#define kAccountManagerDidUserLogoutNotification @"kAccountManagerDidUserLogoutNotification"

@interface OIAccountManager : NSObject{
    //因为@property默认给该属性生成getter和setter方法，当getter和setter方法同时被重写时，则系统就不会自动生成getter和setter方法了，也不会自动帮你生成_userAccount变量，所以不会识别。所以在此应该加上成员变量。
    OIUserAccount *_userAccount;
}

@property(nonatomic,strong)OIUserAccount * userAccount;

+ (instancetype)sharedManager;

///判断用户是否登录
+ (BOOL)isUserLogon;
///初始化用户（通过JSON数据，同时将用户信息保存至沙盒）
- (void)initUserAccount:(NSDictionary *)dict;
///刷新用户数据（同时将用户信息保存至沙盒）
- (void)refreshUserAccount:(NSDictionary *)dict;
///用户登出（同时删除用户数据）
- (void)logout;

@end
