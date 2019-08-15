//
//  OIPhoneRegisterViewController.m
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/7.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import "OIPhoneRegisterViewController.h"
#import "OIRiskEvaluationViewController.h"

@interface OIPhoneRegisterViewController ()

@property (weak, nonatomic) IBOutlet UIButton *vertifyCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextfield;
@property (weak, nonatomic) IBOutlet UITextField *vertifyCodeTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmTexfied;
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,copy)NSString *vertifyCode;
@property(nonatomic,copy)NSString *phoneNumeber;

@end

@implementation OIPhoneRegisterViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 60;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 方便外界获取注册界面
///返回注册界面的控制器
+(instancetype)phoneRegisterViewController{
    OIPhoneRegisterViewController *registerVC =  [[UIStoryboard storyboardWithName:@"OILoginAndRegister" bundle:nil] instantiateViewControllerWithIdentifier:@"OIPhoneRegisterViewController"];
    return registerVC;
}

#pragma mark - 点击事件
- (IBAction)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

///点击获取验证码按钮
- (IBAction)getVertifyCode:(id)sender {
    NSString * phoneNumber = self.phoneNumberTextfield.text;
    if(phoneNumber==nil || [phoneNumber isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"手机号码不能为空"];
        return;
    }
    if(![self isValidPhoneNumer:phoneNumber]){
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }else{
        [self countTheTime];
        [NetworkTool getVertifyCodeByMobile:[NSMutableDictionary dictionaryWithObject:phoneNumber forKey:@"phone"] success:^(id data) {
            NSString * vertifyCode = data[@"code"];
            if(vertifyCode){
                self.vertifyCode = vertifyCode;
                self.phoneNumeber = phoneNumber;
            }
        } error:^(NSError *error) {
            NSString * errorInfo = error.userInfo[NSLocalizedDescriptionKey];
            [SVProgressHUD showErrorWithStatus:errorInfo];
        }];
    }
}

///确认注册按钮点击
- (IBAction)registerBtnClick {
    NSString * vertifyCode = self.vertifyCodeTextfield.text;
    NSString * phoneNumber = self.phoneNumberTextfield.text;
    if(phoneNumber==nil || [phoneNumber isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"手机号码不能为空"];
        return;
    }
    if(vertifyCode==nil || [vertifyCode isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"验证号不能为空"];
        return;
    }
    if(self.passwordTextField.text==nil || [self.passwordTextField.text isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return;
    }
    if(self.passwordConfirmTexfied.text==nil || [self.passwordConfirmTexfied.text isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"请确认密码"];
        return;
    }
    if(self.passwordTextField.text.length<8){
        [SVProgressHUD showErrorWithStatus:@"密码必须大于8个字符"];
        return;
    }
    if(![self.passwordTextField.text isEqualToString:self.passwordConfirmTexfied.text]){
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致"];
        return;
    }
    
    if([phoneNumber isEqualToString:self.phoneNumeber]&&[vertifyCode isEqualToString:self.vertifyCode]){
        NSMutableDictionary * phoneAndPassword = [NSMutableDictionary dictionary];
        [phoneAndPassword setObject:self.phoneNumeber forKey:@"phone"];
        [phoneAndPassword setObject:self.phoneNumeber forKey:@"phoneHome"];
        [phoneAndPassword setObject:self.passwordTextField.text forKey:@"password"];
        [SVProgressHUD showWithStatus:@"正在加载"];
        [NetworkTool addUserInfoWith:phoneAndPassword success:^(id data) {
            [SVProgressHUD showSuccessWithStatus:@"恭喜你注册成功"];
            OIRiskEvaluationViewController * riskEvaVC = [OIRiskEvaluationViewController new];
            [self presentViewController:riskEvaVC animated:NO completion:nil];
        
        } error:^(NSError *error) {
            
        }];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码和验证码"];
    }
}

#pragma mark - Private
///开启倒计时功能
- (void)countTheTime{
    NSTimer * timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        self.count = self.count-1;
        [self.vertifyCodeBtn setTitle:[NSString stringWithFormat:@"%zd秒后重新发送",self.count] forState:UIControlStateNormal];
        self.vertifyCodeBtn.userInteractionEnabled = NO;
        
        if(self.count <= 0){
            [self.vertifyCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
            self.count = 10;
            self.vertifyCodeBtn.userInteractionEnabled = YES;
            //取消定时器
            [timer invalidate];
            timer = nil;
        }
    }];
    NSRunLoop * runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
}

///验证手机号码是否合法
-(BOOL)isValidPhoneNumer:(NSString *)mobileNum{
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}

@end
