//
//  OIChooseTheInjectionWayController.m
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/16.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import "OIChooseTheInjectionWayController.h"
#import "OIAssetInjectionViewController.h"

@interface OIChooseTheInjectionWayController ()
@property (weak, nonatomic) IBOutlet UIView *chinaunionpayView;
@property (weak, nonatomic) IBOutlet UIView *creditCardView;
@property (weak, nonatomic) IBOutlet UIView *alipayView;
@property (weak, nonatomic) IBOutlet UIView *phonePayView;

@end

@implementation OIChooseTheInjectionWayController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击事件
///跳转至银联支付
-(void)chinaunionpayViewClick{
    [self gotoTheDWWebView:@"http://apps.drivewealth.io/funding/DWWEB/deposit/chinaunionpay/zh_CN?partner=DWWEB"];
}
///跳转至信用卡支付
-(void)creditCardViewClick{
    [self gotoTheDWWebView:@"http://apps.drivewealth.io/funding/DWWEB/deposit/creditcard/zh_CN?partner=DWWEB"];
}
///跳转至网银支付
-(void)alipayViewClick{
    [self gotoTheDWWebView:@"http://apps.drivewealth.io/funding/DWWEB/deposit/dinpay/zh_CN?partner=DWWEB"];
}
///跳转至电汇支付
-(void)phonePayViewClick{
    [self gotoTheDWWebView:@"http://apps.drivewealth.io/funding/DWWEB/deposit/wiretransfer/zh_CN?partner=DWWEB"];
}

#pragma mark - private
-(void)setupUI{
    UITapGestureRecognizer * visaViewGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chinaunionpayViewClick)];
    [self.chinaunionpayView addGestureRecognizer:visaViewGesture];
    UITapGestureRecognizer * creditCardViewGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(creditCardViewClick)];
    [self.creditCardView addGestureRecognizer:creditCardViewGesture];
    UITapGestureRecognizer * alipayViewGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alipayViewClick)];
    [self.alipayView addGestureRecognizer:alipayViewGesture];
    UITapGestureRecognizer * phonePayViewGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(phonePayViewClick)];
    [self.phonePayView addGestureRecognizer:phonePayViewGesture];
}

///跳转至DW的开户页面
-(void)gotoTheDWWebView:(NSString *)url{
    OIAssetInjectionViewController * injectionVC = [OIAssetInjectionViewController new];
    injectionVC.DWUrl = url;
   self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:injectionVC animated:YES];
}

@end
