//
//  OIAgeAndIncomeViewController.m
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/8.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import "OIAgeAndIncomeViewController.h"
#import "OIDataReportViewController.h"

@interface OIAgeAndIncomeViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *investTextField;
@property (weak, nonatomic) IBOutlet UILabel *ageWarmingLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeWarmingLabel;

@end

@implementation OIAgeAndIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 点击事件
///修改投资目的按钮点击
- (IBAction)changeInvestTypeClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

///下一步按钮点击
- (IBAction)nextStepClick:(id)sender {
    
    if([self isAgeAndIncomeTextCorrect]){
        NSMutableDictionary * ageAndInvest = [NSMutableDictionary dictionary];
        [ageAndInvest setObject:self.ageTextField.text forKey:@"age"];
        [ageAndInvest setObject:self.investTextField.text forKey:@"initial_amount"];
//        double age = [self.ageTextField.text doubleValue];
//        double invest = [self.investTextField.text doubleValue];
        //通过公式计算预期年收益
//        double targetIcome = invest * pre_retirement_income * pow(1+base_rate, (retirement_age - age));
        [SVProgressHUD showWithStatus:@"正在加载中..."];
        //上传参数：年龄与收入
        [NetworkTool addUserInfoWith:ageAndInvest success:^(id data) {
            //成功后进入下一个界面
            OIDataReportViewController *dataReportVC =  [[UIStoryboard storyboardWithName:@"OILoginAndRegister" bundle:nil] instantiateViewControllerWithIdentifier:@"OIDataReportViewController"];
           dataReportVC.initialAmount = self.investTextField.text;
            [self presentViewController:dataReportVC animated:NO completion:nil];
            [SVProgressHUD dismiss];
        } error:^(NSError *error) {
        }];
    }
}

///textField的代理
- (IBAction)ageTextFieldDIdChanged:(id)sender {
    self.ageWarmingLabel.hidden = YES;
}
- (IBAction)investTextFieldDidChanged:(id)sender {
    self.incomeWarmingLabel.hidden = YES;
}

#pragma mark - private
///设置UI
-(void)setupUI{
    self.ageWarmingLabel.hidden = YES;
    self.incomeWarmingLabel.hidden = YES;
}

///检测年龄和收入填写是否有问题
-(BOOL)isAgeAndIncomeTextCorrect{
    if([self.ageTextField.text isEqualToString:@""]){
        self.ageWarmingLabel.hidden = NO;
        self.ageWarmingLabel.text = @"年龄不能为空";
        return NO;
    }
    int age = [self.ageTextField.text intValue];
    if(age<18 || age>50){
        self.ageWarmingLabel.hidden = NO;
        self.ageWarmingLabel.text = @"年龄必须在18到50岁";
        return NO;;
    }
    
    if([self.investTextField.text isEqualToString:@""]){
        self.incomeWarmingLabel.hidden = NO;
        self.incomeWarmingLabel.text = @"收入不能为空";
        return NO;;
    }
    double income = [self.investTextField.text doubleValue];
    if(income<500 || income>9999999){
        self.incomeWarmingLabel.hidden = NO;
        self.incomeWarmingLabel.text = @"投资金额必须要在500到1000万之间";
        return NO;;
    }
    return YES;
}
@end
