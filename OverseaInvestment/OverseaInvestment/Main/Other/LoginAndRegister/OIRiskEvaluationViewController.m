//
//  OIRiskEvaluationViewController.m
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/18.
//  Copyright © 2016年 B2C. All rights reserved.
//  此页面是风险评估用，设计要求是从网页上加载网页的数据。

#import "OIRiskEvaluationViewController.h"
#import <WebKit/WebKit.h>

@interface OIRiskEvaluationViewController ()

@property(nonatomic,strong)UIWebView * webView;

@end

@implementation OIRiskEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)loadView{
    self.webView = [[UIWebView alloc]init];
    self.webView.frame = [UIScreen mainScreen].bounds;
    self.view = self.webView;
    NSURL * url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
