//
//  OIAdjustAnnualIncomeController.m
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/8.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import "OIAdjustAnnualIncomeController.h"
#import "OIFirstPayForRetirementController.h"

@interface OIAdjustAnnualIncomeController ()

@property (weak, nonatomic) IBOutlet UILabel *incomeTargetLabel;
@property (weak, nonatomic) IBOutlet UISlider *incomeAdjustSlider;
@property (weak, nonatomic) IBOutlet UILabel *minIncomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxIncomeLabel;

@property(nonatomic,assign)NSInteger incomeTargetForinteger;
@property(nonatomic,assign)NSInteger incomeTargetMinValue;
@property(nonatomic,assign)NSInteger incomeTargetMaxValue;

@end

@implementation OIAdjustAnnualIncomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击与slider滑动事件
///滑动slider时调用
- (IBAction)sliderValueChanged:(id)sender {
    self.incomeTargetForinteger = self.incomeAdjustSlider.value * (self.incomeTargetMaxValue - self.incomeTargetMinValue) + self.incomeTargetMinValue;
    self.incomeTargetLabel.text = [NSString stringWithFormat:@"￥%ld万",self.incomeTargetForinteger];
    self.incomeTargetValue = self.incomeTargetForinteger*10000;
}

///返回按钮点击
- (IBAction)backBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

///下一步按钮点击事件
- (IBAction)nextStepClick {
    NSMutableDictionary * targetamount = [NSMutableDictionary dictionary];
    [targetamount setObject:@(self.incomeTargetValue) forKey:@"target_amount"];
    [SVProgressHUD showWithStatus:@"正在加载中..."];
    //上传参数：期待收益
    [NetworkTool addUserInfoWith:targetamount success:^(id data) {
        OIFirstPayForRetirementController *firstPayVC =  [[UIStoryboard storyboardWithName:@"OILoginAndRegister" bundle:nil] instantiateViewControllerWithIdentifier:@"OIFirstPayForRetirementController"];
        [self presentViewController:firstPayVC animated:NO completion:nil];
        [SVProgressHUD dismiss];
    } error:^(NSError *error) {
    }];
}

- (IBAction)howToGetTheMoneyBtnClick {
}

#pragma mark - private
-(void)setupUI{
    //此值只用来显示，与服务器交互仍然用算出的值
    self.incomeTargetForinteger = (NSInteger)roundf(self.incomeTargetValue/10000);
    self.incomeTargetMinValue = (NSInteger)roundf(self.incomeTargetValue * 0.8/10000);
    self.incomeTargetMaxValue = (NSInteger)roundf(self.incomeTargetValue * 1.2/10000);
    
    self.incomeTargetLabel.text = [NSString stringWithFormat:@"￥%ld万",self.incomeTargetForinteger];
    self.minIncomeLabel.text = [NSString stringWithFormat:@"￥%ld万",self.incomeTargetMinValue];
    self.maxIncomeLabel.text = [NSString stringWithFormat:@"￥%ld万",self.incomeTargetMaxValue];
    self.incomeAdjustSlider.value = (float)(self.incomeTargetForinteger - self.incomeTargetMinValue)/(self.incomeTargetMaxValue - self.incomeTargetMinValue);
}

@end
