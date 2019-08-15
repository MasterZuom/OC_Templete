//
//  OIUserAccount.h
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/7.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OIUserAccount : NSObject<NSCoding>
///用户token
@property (nonatomic, copy) NSString *access_token;
//用户姓名
@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *step;
//加载DW网页需要用的userID
@property (nonatomic, copy) NSString *userID;
//加载DW网页需要用的session_key
@property (nonatomic, copy) NSString *session_key;

@end
