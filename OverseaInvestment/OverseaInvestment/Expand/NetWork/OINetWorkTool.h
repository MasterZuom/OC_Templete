//
//  OINetWorkTool.h
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/3.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#define NetworkTool [OINetWorkTool sharedNetworkTool]

//成功与失败的block
typedef void(^SuccessHandler)(id data);
typedef void(^ErrorHandler)(NSError *error);

@interface OINetWorkTool : AFHTTPSessionManager

///网络工具类的单例
+ (instancetype)sharedNetworkTool;

///自定义的网络请求
- (void)getVertifyCodeByMobile:(NSMutableDictionary *)parameters success:(SuccessHandler)successHandler error:(ErrorHandler)errorHandler;

///首次传参数到服务器（注册）
-(void)registerFirst:(NSMutableDictionary *)parameters success:(SuccessHandler)successHandler error:(ErrorHandler)errorHandler;

///添加用户信息(注册)
-(void)addUserInfoWith:(NSMutableDictionary *)parameters success:(SuccessHandler)successHandler error:(ErrorHandler)errorHandler;

///获取当下美元与人民币汇率
-(void)getTheUSDtoRMBExchangeRate:(NSMutableDictionary *)parameters success:(SuccessHandler)successHandler error:(ErrorHandler)errorHandler;

///获取国家列表
-(void)getAllCountries:(NSMutableDictionary *)parameters success:(SuccessHandler)successHandler error:(ErrorHandler)errorHandler;

///登录
-(void)login:(NSMutableDictionary *)parameters success:(SuccessHandler)successHandler error:(ErrorHandler)errorHandler;

///获取用户投资预期收益的数据
-(void)getUserInvestmentExpectationProfitsData:(NSMutableDictionary *)parameters success:(SuccessHandler)successHandler error:(ErrorHandler)errorHandler;

///获取用户资产配比
-(void)getUserPropertyMatchingData:(NSMutableDictionary *)parameters success:(SuccessHandler)successHandler error:(ErrorHandler)errorHandler;

///上传单张图片
-(void)uploadIDCardImage:(UIImage *)image fileName:(NSString*)fileName name:(NSString *)name otherInfo:(NSMutableDictionary *)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success error:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

///上传身份证正反面（上传多张图片 images:照片数组 fileNames:照片名数组 names:服务器接受的照片字段数组 parameters:其他的信息）
-(void)uploadIDCardImages:(NSArray *)images fileNames:(NSArray*)fileNames names:(NSArray *)names otherInfo:(NSMutableDictionary *)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success error:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
@end
