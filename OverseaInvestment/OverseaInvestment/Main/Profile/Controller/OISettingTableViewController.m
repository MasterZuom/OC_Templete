//
//  OISettingTableViewController.m
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/18.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import "OISettingTableViewController.h"

@interface OISettingTableViewController ()

@end

@implementation OISettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row == 2){
        ///用户登出
        [[OIAccountManager sharedManager] logout];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
