//
//  OIInvestTypeViewController.m
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/8.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import "OIInvestTypeViewController.h"
#import "OIAgeAndIncomeViewController.h"

@interface OIInvestTypeViewController ()
@property(nonatomic,assign)NSString * accessToken;
@end

@implementation OIInvestTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //判断是否登录
    if([OIAccountManager isUserLogon]){
        //如果登录了，在账户类里面能直接获取accessToken
        self.accessToken = [OIAccountManager sharedManager].userAccount.access_token;
    }else{
        //如果没有登录，则去偏好设置里面去找accessToken(注册的时候需要用)
        self.accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:KAccessTokenOfPrefrence];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击事件
///长期保障
- (IBAction)retirementBtnClick:(id)sender {
    NSMutableDictionary * accountType = [NSMutableDictionary dictionaryWithObject:@"retirement" forKey:@"account_type"];
    [SVProgressHUD showWithStatus:@"正在加载中..."];
    
    //当accessToken不存在的时候就需要发送post请求
    if(self.accessToken==nil || [self.accessToken isEqualToString:@""]){
        //上传参数：用户类型(此时，服务器会返回一个 accessToken)
        [NetworkTool registerFirst:accountType success:^(id data) {
            //从服务器获取accessToken
            NSDictionary * account = data[@"account"];
            NSString * accessToken = account[@"access_token"];
            [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:KAccessTokenOfPrefrence];
            [self nextController];
    
        } error:^(NSError *error) {
        }];
    }else{ //如果此时accessToken已经存在，则调用PUT方法(修改用户参数)
        [NetworkTool addUserInfoWith:accountType success:^(id data) {
            [self nextController];
        } error:^(NSError *error) {
        }];
    }
}

- (IBAction)closeClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private
///跳转控制器
-(void)nextController{
    OIAgeAndIncomeViewController *ageAndIncomeVC =  [[UIStoryboard storyboardWithName:@"OILoginAndRegister" bundle:nil] instantiateViewControllerWithIdentifier:@"OIAgeAndIncomeViewController"];
    [self presentViewController:ageAndIncomeVC animated:NO completion:nil];
    [SVProgressHUD dismiss];
}

@end
