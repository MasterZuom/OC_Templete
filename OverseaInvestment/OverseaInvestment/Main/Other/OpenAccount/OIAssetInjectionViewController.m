//
//  OIAssetInjectionViewController.m
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/16.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import "OIAssetInjectionViewController.h"
#import <WebKit/WebKit.h>

@interface OIAssetInjectionViewController ()

@property(nonatomic,strong)WKWebView * wkwebView;

@end

@implementation OIAssetInjectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadView{
    self.wkwebView = [WKWebView new];
    self.wkwebView.frame = [UIScreen mainScreen].bounds;
    self.view = self.wkwebView;
    [self completeDWURL];
    NSURL *url = [[NSURL alloc]initWithString:self.DWUrl];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.wkwebView loadRequest:request];
}

#pragma mark - private
-(void)setupUI{
    [self.navigationItem setHidesBackButton:YES animated:NO];
    UIBarButtonItem * backBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToLastweb)];
    [self.navigationItem setLeftBarButtonItem:backBtn];
    UIBarButtonItem * refreshBtn = [[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refreshBtnClick)];
    [self.navigationItem setRightBarButtonItem:refreshBtn];
}

///返回上一页按钮
-(void)backToLastweb{
    //如果可以返回（网页内部返回
    if([self.wkwebView canGoBack]){
        [self.wkwebView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

///刷新
-(void)refreshBtnClick{
    [self.wkwebView reload];
}

///根据账户信息，拼接出来完整的DWURL
-(void)completeDWURL{
    ///此三个参数 暂时为测试参数（后期需要登录后从个人账户的信息中获取）
    NSString * userID = @"04faab72-3eaf-4a87-9f0e-27564d1d3aa5";
    NSString * sessionKey = @"04faab72-3eaf-4a87-9f0e-27564d1d3aa5.2016-11-16T02:31:18.021Z";
    NSString * lang = @"zh_CN";
    
    self.DWUrl = [NSString stringWithFormat:@"%@&userID=%@&sessionKey=%@&lang=%@",self.DWUrl,userID,sessionKey,lang];
}

@end
