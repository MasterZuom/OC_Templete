//
//  OIFirstPayForRetirementController.m
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/8.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import "OIFirstPayForRetirementController.h"
#import "OIDataReportViewController.h"

@interface OIFirstPayForRetirementController ()
@property (weak, nonatomic) IBOutlet UILabel *retirementAmount;
@property (weak, nonatomic) IBOutlet UITextField *firstPayTextfield;
@end

@implementation OIFirstPayForRetirementController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstPayTextfield.text = @"20000";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 点击事件
- (IBAction)backBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneBtnClick {
    //上传参数：首次投入金额inital_amount
    NSMutableDictionary * initialAmount = [NSMutableDictionary new];
    [initialAmount setObject:self.firstPayTextfield.text forKey:@"initial_amount"];
    [SVProgressHUD showWithStatus:@"正在加载中..."];
    
    [NetworkTool addUserInfoWith:initialAmount success:^(id data) {
        OIDataReportViewController *dataReportVC =  [[UIStoryboard storyboardWithName:@"OILoginAndRegister" bundle:nil] instantiateViewControllerWithIdentifier:@"OIDataReportViewController"];
        dataReportVC.initialAmount = self.firstPayTextfield.text;
        [self presentViewController:dataReportVC animated:NO completion:nil];
        [SVProgressHUD dismiss];
    } error:^(NSError *error) {
    }];
}

@end
