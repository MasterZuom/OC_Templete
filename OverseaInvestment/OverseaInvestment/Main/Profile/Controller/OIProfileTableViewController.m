//
//  OIProfileTableViewController.m
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/7.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import "OIProfileTableViewController.h"
#import "OILayerClauseViewController.h"
#import "OISettingTableViewController.h"
#import "OIChooseTheInjectionWayController.h"
#import "OIMyHistoryBenifitViewController.h"

@interface OIProfileTableViewController ()



@end

@implementation OIProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
///判断是否登录，如果没有登录，则跳转到登录界面
-(BOOL)isLoginAndTODO{
    return YES;
    OILoginViewController * loginController = [OILoginViewController loginController];
    if([OIAccountManager isUserLogon]){
        return YES;
    }else{
        [self presentViewController:loginController animated:YES completion:nil];
        return NO;
    }
}


#pragma mark - tableViewDelegate
///返回行高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

///点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row == 0){
        //点击用户图像
        if([self isLoginAndTODO]){
            
        }
    }else if(indexPath.section == 0 && indexPath.row == 1){
        //点击开户流程
        if([self isLoginAndTODO]){
            self.hidesBottomBarWhenPushed=YES;
            OILayerClauseViewController * clauseController = [[UIStoryboard storyboardWithName:@"OIOpenAccount" bundle:nil]instantiateViewControllerWithIdentifier:@"OILayerClauseViewController"];
            [self.navigationController pushViewController:clauseController animated:YES];
            self.hidesBottomBarWhenPushed =NO;
        }
    }else if(indexPath.section == 0 && indexPath.row == 2){
        //点击去注资
        if([self isLoginAndTODO]){
            self.hidesBottomBarWhenPushed=YES;
            OIChooseTheInjectionWayController * chooseWayVC =[[UIStoryboard storyboardWithName:@"OIOpenAccount" bundle:nil]instantiateViewControllerWithIdentifier:@"OIChooseTheInjectionWayController"];
            [self.navigationController pushViewController:chooseWayVC animated:YES];
            self.hidesBottomBarWhenPushed =NO;
        }
    }else if(indexPath.section == 1 && indexPath.row ==0){
        //点击查看收益历史（测试用）
        if([self isLoginAndTODO]){
            self.hidesBottomBarWhenPushed=YES;
            OIMyHistoryBenifitViewController * historyBeniftVC = [[UIStoryboard storyboardWithName:@"OIProfile" bundle:nil] instantiateViewControllerWithIdentifier:@"OIMyHistoryBenifitViewController"];
            [self.navigationController pushViewController:historyBeniftVC animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
    }else if(indexPath.section ==1  && indexPath.row == 1){
        //点击风险评估（本地的）
        if([self isLoginAndTODO]){
            self.hidesBottomBarWhenPushed=YES;
            OIRiskCollectionController * riskAssessVC = [[UIStoryboard storyboardWithName:@"OIRiskAssessment" bundle:nil]instantiateViewControllerWithIdentifier:@"OIRiskCollectionController"];
            [self.navigationController pushViewController:riskAssessVC animated:YES];
            self.hidesBottomBarWhenPushed =NO;
        }
        
    }else if(indexPath.section == 1 && indexPath.row == 2){
        //点击设置
        if([self isLoginAndTODO]){
            self.hidesBottomBarWhenPushed=YES;
            OISettingTableViewController * settingVC = [[UIStoryboard storyboardWithName:@"OIProfile" bundle:nil]instantiateViewControllerWithIdentifier:@"OISettingTableViewController"];
            [self.navigationController pushViewController:settingVC animated:YES];
            self.hidesBottomBarWhenPushed =NO;
        }
    }else if(indexPath.section == 2 && indexPath.row == 0){
        //点击删除存在本地缓存中的token(测试用)
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:KAccessTokenOfPrefrence];
    }
}

@end
