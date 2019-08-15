//
//  OIMaterialBeenSubmittedController.m
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/16.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import "OIMaterialBeenSubmittedController.h"

@interface OIMaterialBeenSubmittedController ()

@end

@implementation OIMaterialBeenSubmittedController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击事件
///返回按钮
- (IBAction)backClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)contactUsClick:(id)sender {
}

#pragma mark - private
-(void)setupUI{
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

@end
