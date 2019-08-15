//
//  FirstViewController.m
//  OverseaInvestment
//
//  Created by Zhiyong Yang on 03/11/2016.
//  Copyright © 2016 B2C. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [NetworkTool getTheUSDtoRMBExchangeRate:nil success:^(id data) {
        NSString * exchangeRate = data[@"exchange_rate"];
        NSLog(@"当前汇率是：%@",exchangeRate);
    } error:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

@end
