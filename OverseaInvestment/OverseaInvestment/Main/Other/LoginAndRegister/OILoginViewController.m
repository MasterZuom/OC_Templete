//
//  OILoginViewController.m
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/7.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import "OILoginViewController.h"
#import "OIPhoneRegisterViewController.h"
#import "OIInvestTypeViewController.h"

@interface OILoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;

@end

@implementation OILoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 方便外界获取登录界面
///返回登录界面的控制器
+(instancetype)loginController{
   OILoginViewController *loginVC =  [[UIStoryboard storyboardWithName:@"OILoginAndRegister" bundle:nil] instantiateViewControllerWithIdentifier:@"OILoginViewController"];
    return loginVC;
}

#pragma mark - 点击事件
///关闭控制器
- (IBAction)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginClick:(id)sender {
    if(self.accountTextfield.text == nil || [self.accountTextfield.text isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"请输入登录账号"];
        return;
    }
    if(self.passwordTextfield.text == nil || [self.passwordTextfield.text isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"请输入登录账号"];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在登录"];
    NSMutableDictionary * accountAndPassword = [NSMutableDictionary dictionary];
    [accountAndPassword setObject:self.accountTextfield.text forKey:@"phone"];
    [accountAndPassword setObject:self.passwordTextfield.text forKey:@"password"];
    [NetworkTool login:accountAndPassword success:^(id data) {
        //保存用户信息
        [[OIAccountManager sharedManager] initUserAccount:data[@"account"]];
        [self dismissViewControllerAnimated:YES completion:nil];
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
    } error:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedDescriptionKey]];
    }];
}
@end
