//
//  OINetWorkTool.m
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/3.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import "OINetWorkTool.h"

typedef NS_ENUM(NSInteger, OINetworkMethod) {
    OINetworkMethodGET = 0,
    OINetworkMethodPOST,
    OINetworkMethodPUT,
};

#define baseUrl @"https://b2c-pre.dealglobe.com"

@implementation OINetWorkTool

///网络单例
+ (instancetype)sharedNetworkTool {
    static OINetWorkTool *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [[NSURL alloc] initWithString:baseUrl];
        instance = [[OINetWorkTool alloc] initWithBaseURL:baseURL];
        
        //------------------设置请求Request-----------------
        //设置timeoutInterval时间长度
        [instance.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        instance.requestSerializer.timeoutInterval = 30;
        [instance.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        //设置请求头
        [instance.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        //--------------------设置响应Response----------------
        //申明返回的结果是json类型
        instance.responseSerializer = [AFJSONResponseSerializer serializer];
        //如果报接受类型不一致请替换一致text/html或别的
        instance.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    });
    return instance;
}

#pragma mark - 自定义的网络请求方法
///获取验证码
- (void)getVertifyCodeByMobile:(NSMutableDictionary *)parameters success:(SuccessHandler)successHandler error:(ErrorHandler)errorHandler{
    [self requestMethod:OINetworkMethodPOST urlString:@"/api/v1/accounts/send_mobile_code" params:parameters success:successHandler error:errorHandler needToken:YES];
}

///首次传参数到服务器（注册流程）
-(void)registerFirst:(NSMutableDictionary *)parameters success:(SuccessHandler)successHandler error:(ErrorHandler)errorHandler{
    [self requestMethod:OINetworkMethodPOST urlString:@"/api/v1/accounts" params:parameters success:successHandler error:errorHandler needToken:NO];
}

///添加(修改)用户信息(注册流程)
-(void)addUserInfoWith:(NSMutableDictionary *)parameters success:(SuccessHandler)successHandler error:(ErrorHandler)errorHandler{
     [self requestMethod:OINetworkMethodPUT urlString:@"/api/v1/accounts" params:parameters success:successHandler error:errorHandler needToken:YES];
}

///获取当下美元与人民币汇率
-(void)getTheUSDtoRMBExchangeRate:(NSMutableDictionary *)parameters success:(SuccessHandler)successHandler error:(ErrorHandler)errorHandler{
    [self requestMethod:OINetworkMethodGET urlString:@"/api/v1/finances/exchange_rate" params:parameters success:successHandler error:errorHandler needToken:YES];
}

///获取国家列表
-(void)getAllCountries:(NSMutableDictionary *)parameters success:(SuccessHandler)successHandler error:(ErrorHandler)errorHandler{
    [self requestMethod:OINetworkMethodGET urlString:@"/api/v1/finances/countries" params:parameters success:successHandler error:errorHandler needToken:YES];
}

///登录
-(void)login:(NSMutableDictionary *)parameters success:(SuccessHandler)successHandler error:(ErrorHandler)errorHandler{
    [self requestMethod:OINetworkMethodPOST urlString:@"/api/v1/accounts/login" params:parameters success:successHandler error:errorHandler needToken:NO];
}

///获取用户投资预期收益的数据
-(void)getUserInvestmentExpectationProfitsData:(NSMutableDictionary *)parameters success:(SuccessHandler)successHandler error:(ErrorHandler)errorHandler{
    [self requestMethod:OINetworkMethodGET urlString:@"/api/v1/accounts/assets_income" params:parameters success:successHandler error:errorHandler needToken:YES];
}

///获取用户资产配比
-(void)getUserPropertyMatchingData:(NSMutableDictionary *)parameters success:(SuccessHandler)successHandler error:(ErrorHandler)errorHandler{
    [self requestMethod:OINetworkMethodGET urlString:@"/api/v1/accounts/assets_dist" params:parameters success:successHandler error:errorHandler needToken:YES];
}

///上传单张图片
-(void)uploadIDCardImage:(UIImage *)image fileName:(NSString*)fileName name:(NSString *)name otherInfo:(NSMutableDictionary *)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success error:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    NSString * url = [baseUrl stringByAppendingString:@"/api/v1/accounts"];
    [self PUT:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //对图片进行0.5倍的压缩
        NSData *imageData =UIImageJPEGRepresentation(image,0.5);
        //对图片的大小进行裁剪(需要的时候开启)
//        NSData *imageData2 = UIImageJPEGRepresentation([image scaleImageToSize:CGSizeMake(150, 150)], 0.5);
        [formData appendPartWithFileData:imageData
                                    name:name
                                fileName:fileName
                                mimeType:@"image/jpeg"];
    } progress:nil success:success failure:failure];
}

///上传身份证正反面（上传多张图片 images:照片数组 fileNames:照片名数组 names:服务器接受的照片字段数组）
-(void)uploadIDCardImages:(NSArray *)images fileNames:(NSArray*)fileNames names:(NSArray *)names otherInfo:(NSMutableDictionary *)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success error:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    NSString * url = [baseUrl stringByAppendingString:@"/api/v1/accounts"];
    [self PUT:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for(int i=0;i<images.count;i++){
            //对图片进行0.5倍的压缩
            NSData *imageData =UIImageJPEGRepresentation(images[i],0.5);
            //对图片的大小进行裁剪(需要的时候开启)
            //        NSData *imageData2 = UIImageJPEGRepresentation([image scaleImageToSize:CGSizeMake(150, 150)], 0.5);
            [formData appendPartWithFileData:imageData
                                        name:names[i]
                                    fileName:fileNames[i]
                                    mimeType:@"image/jpeg"];
        }
    } progress:nil success:success failure:failure];
}

#pragma mark - 最底层的网络请求方法
- (void)requestMethod:(OINetworkMethod)method urlString:(NSString *)urlString params:(NSMutableDictionary *)params success:(SuccessHandler)successHandler error:(ErrorHandler)errorHandler needToken:(BOOL)needToken {
    
    // HTTP请求成功的Block
    void (^success)(NSURLSessionDataTask *task, id responseObject) = ^ (NSURLSessionDataTask *task, id responseObject){
        // responseObject 为字典或者为空，否则返回数据异常
        if ([responseObject isKindOfClass:[NSDictionary class]] && (responseObject != nil)) {
            NSLog(@"%@",responseObject);
            
            if([responseObject[@"status"] isEqualToString:@"ok"]){
                if(successHandler){
                    successHandler(responseObject);
                }
            }else{
                //出现了业务逻辑的错误(NSLocalizedDescriptionKey键 用来描述错误的原因)
                //errors是个数组，错误提示放在[0]上
                NSString * errorInfo = responseObject[@"errors"][0];
                NSError * error = [NSError errorWithDomain:OIErrorDomainName code:0 userInfo:@{NSLocalizedDescriptionKey:errorInfo}];
                
                if(errorHandler){
                    [SVProgressHUD showErrorWithStatus:@"数据请求错误"];
                    errorHandler(error);
                }
            }
        }else{
            NSLog(@"网络单例请求到空数据");
            if (errorHandler) {
                NSError * error = [NSError errorWithDomain:OIErrorDomainName code:-1 userInfo:@{NSLocalizedDescriptionKey:@"网络单例请求到空数据"}];
                errorHandler(error);
            }
        }
    };
    
    // 网络错误的Block
    void(^error)(NSURLSessionDataTask *task, NSError *error) = ^(NSURLSessionDataTask *task, NSError *error) {
        //获取HTTP的错误码
        NSHTTPURLResponse *faileResponse = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = [faileResponse statusCode];
        NSLog(@"网络单例未能请求到数据，请求返回错误code：%zd",statusCode);
        [SVProgressHUD showInfoWithStatus:@"连接错误"];

        if (errorHandler) {
            errorHandler(error);
        }
    };
    
    // 处理nil参数
    if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }
    
    //需不需要Token
    if(needToken){
        //判断是否登录
        if([OIAccountManager isUserLogon]){
            //如果登录了，在账户类里面能直接获取accessToken
            NSString * accessToken = [OIAccountManager sharedManager].userAccount.access_token;
            if(accessToken){
                [self.requestSerializer setValue:accessToken forHTTPHeaderField:@"Access-Token"];
            }
        }else{
            //如果没有登录，则去偏好设置里面去找accessToken(注册的时候需要用)
            NSString * accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:KAccessTokenOfPrefrence];
            if(accessToken){
                [self.requestSerializer setValue:accessToken forHTTPHeaderField:@"Access-Token"];
            }
        }
    }
    
    //确定请求的方法POST PUT 和 GET
    switch (method) {
        case OINetworkMethodGET:
            [self GET:urlString parameters:params progress:nil success:success failure:error];
            break;
        case OINetworkMethodPOST:
            [self POST:urlString parameters:params progress:nil success:success failure:error];
            break;
        case OINetworkMethodPUT:
            [self PUT:urlString parameters:params success:success failure:error];
        default:
            break;
    }
}

///PUT方法上传用户图片
- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(id)parameters
    constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                     progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"PUT" URLString:URLString parameters:parameters constructingBodyWithBlock:block error:&serializationError];
    
    //判断是否登录
    if([OIAccountManager isUserLogon]){
        //如果登录了，在账户类里面能直接获取accessToken
        NSString * accessToken = [OIAccountManager sharedManager].userAccount.access_token;
        if(accessToken){
            [request setValue:accessToken forHTTPHeaderField:@"Access-Token"];
        }
    }else{
        //如果没有登录，则去偏好设置里面去找accessToken(注册的时候需要用)
        NSString * accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:KAccessTokenOfPrefrence];
        if(accessToken){
            [request setValue:accessToken forHTTPHeaderField:@"Access-Token"];
        }
    }
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        return nil;
    }
    __block NSURLSessionDataTask *task = [self uploadTaskWithStreamedRequest:request progress:uploadProgress completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(task, error);
            }
        } else {
            if (success) {
                success(task, responseObject);
            }
        }
    }];
    [task resume];
    return task;
}

@end
