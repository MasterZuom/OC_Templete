//
//  OILayerClauseViewController.m
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/11.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import "OILayerClauseViewController.h"
#import "OICompleteBasicInfoViewController.h"

@interface OILayerClauseViewController ()

@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;

@end

@implementation OILayerClauseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击事件
- (IBAction)selectedBtnClick:(id)sender {
    self.selectedBtn.selected = !self.selectedBtn.selected;
    if(self.selectedBtn.selected){
        self.nextStepBtn.backgroundColor = [UIColor colorWithHexString:@"00BFFF"];
        self.nextStepBtn.enabled = YES;
    }else{
        self.nextStepBtn.backgroundColor = [UIColor colorWithHexString:@"DCDCDC"];
        self.nextStepBtn.enabled = NO;
    }
}

///下一步
- (IBAction)nextStepClick:(id)sender {
    self.hidesBottomBarWhenPushed=YES;
    OICompleteBasicInfoViewController * clauseController = [[UIStoryboard storyboardWithName:@"OIOpenAccount" bundle:nil]instantiateViewControllerWithIdentifier:@"OICompleteBasicInfoViewController"];
    [self.navigationController pushViewController:clauseController animated:YES];
}

#pragma mark - private
-(void)setupUI{
    self.nextStepBtn.backgroundColor = [UIColor lightGrayColor];
    self.nextStepBtn.enabled = NO;
}
@end
