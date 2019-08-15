//
//  OIAccountManager.m
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/7.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import "OIAccountManager.h"

//用来存储用户账户信息的地址
#define AccountFilePath [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"userAccount.plist"]

@implementation OIAccountManager

+ (instancetype)sharedManager {
    static OIAccountManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

///初始化账户信息（初始化后，就已经将用户信息保存到沙盒中）
- (void)initUserAccount:(NSDictionary *)dict {
     OIUserAccount * userAccount = [OIUserAccount mj_objectWithKeyValues:dict];
    // setter方法中保存账户信息
    self.userAccount = userAccount;
}

///判断用户是否登录
+ (BOOL)isUserLogon {
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL bAccount = [fileMgr fileExistsAtPath:AccountFilePath];
    OIAccountManager * manager = [self sharedManager];
    return (bAccount && manager.userAccount!=nil);
}

///登出
- (void)logout {
    // 先删除账户归档文件
    [self removeArchive];
    
    // 清除内存
    _userAccount = nil;
    
    // 保证主线程，异步(发送通知，用户已经退出)
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kAccountManagerDidUserLogoutNotification object:nil];
    });
}

///刷新用户信息
- (void)refreshUserAccount:(NSDictionary *)dict {
    self.userAccount = [OIUserAccount mj_objectWithKeyValues:dict];
    [self saveAccountAndSendLoginSuccessNotifocation:NO];
}

#pragma mark - private
///保存用户信息，并发送登录成功的通知
- (void)saveAccountAndSendLoginSuccessNotifocation:(BOOL)send {
    
    // 保存新的之前先删除旧文件
    [self removeArchive];
    if (_userAccount) {
        [NSKeyedArchiver archiveRootObject:self.userAccount toFile:AccountFilePath];
        NSLog(@"%@", AccountFilePath);
    }
    
    if (send) {
        // 保证主线程，异步
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kAccountManagerDidUserLoginNotification object:nil];
        });
    }
}

///移除归档文件
- (void)removeArchive {
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL bAccount = [fileMgr fileExistsAtPath:AccountFilePath];
    if (bAccount) {
        NSError *err;
        [fileMgr removeItemAtPath:AccountFilePath error:&err];
    }
}

#pragma mark - getter and setter
///getter方法
-(OIUserAccount *)userAccount{
    if(_userAccount == nil){
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL bAccount = [fileMgr fileExistsAtPath:AccountFilePath];
        if (bAccount) {
            _userAccount = [NSKeyedUnarchiver unarchiveObjectWithFile:AccountFilePath];
        }
    }
    return _userAccount;
}

-(void)setUserAccount:(OIUserAccount *)userAccount{
    _userAccount = userAccount;
    [self saveAccountAndSendLoginSuccessNotifocation:YES];
}
@end
