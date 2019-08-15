//
//  OIOtherAccountInfoTableViewController.m
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/15.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import "OIOtherAccountInfoTableViewController.h"
#import "OIMaterialBeenSubmittedController.h"

@interface OIOtherAccountInfoTableViewController ()

@property (weak, nonatomic) IBOutlet UIButton *ques1ans1Btn;
@property (weak, nonatomic) IBOutlet UIButton *ques1ans2Btn;
@property (weak, nonatomic) IBOutlet UIButton *ques1ans3Btn;
@property (weak, nonatomic) IBOutlet UIButton *ques1ans4Btn;
@property (weak, nonatomic) IBOutlet UIButton *ques2ans1Btn;
@property (weak, nonatomic) IBOutlet UIButton *ques2ans2Btn;
@property (weak, nonatomic) IBOutlet UIButton *ques2ans3Btn;
@property (weak, nonatomic) IBOutlet UIButton *ques2ans4Btn;
//按钮数组
@property(nonatomic,strong)NSArray * ques1anses;
@property(nonatomic,strong)NSArray * ques2anses;
@property (weak, nonatomic) IBOutlet UISwitch *isDirectorSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *isPoliticallyExposedSwitch;
@property (weak, nonatomic) IBOutlet UIButton *iagreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;

@end

@implementation OIOtherAccountInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 点击事件
///问题1答案点击事件
- (IBAction)ques1AnsersClick:(UIButton *)sender {
    [self cancellAllBtns:self.ques1anses];
    sender.selected = YES;
}
///问题2答案点击事件
- (IBAction)ques2AnsersClick:(UIButton *)sender {
    [self cancellAllBtns:self.ques2anses];
    sender.selected = YES;
}

- (IBAction)directorSwitch:(id)sender {
    self.isDirectorSwitch.on = !self.isDirectorSwitch.isOn;
}

- (IBAction)politicallyExposedSwitch:(id)sender {
    self.isPoliticallyExposedSwitch.on = !self.isPoliticallyExposedSwitch.isOn;
}

- (IBAction)iAgreeBtnClick:(id)sender {
    self.iagreeBtn.selected = !self.iagreeBtn.selected;
    if(self.iagreeBtn.selected){
        self.nextStepBtn.backgroundColor = [UIColor colorWithHexString:@"00BFFF"];
        self.nextStepBtn.enabled = YES;
    }else{
        self.nextStepBtn.backgroundColor = [UIColor colorWithHexString:@"DCDCDC"];
        self.nextStepBtn.enabled = NO;
    }
}

- (IBAction)nextStepClick:(id)sender {
    
    OIMaterialBeenSubmittedController * materialSubmitVC =[[UIStoryboard storyboardWithName:@"OIOpenAccount" bundle:nil]instantiateViewControllerWithIdentifier:@"OIMaterialBeenSubmittedController"];
    [self.navigationController pushViewController:materialSubmitVC animated:YES];
    return;
    
    [SVProgressHUD showWithStatus:@"正在加载"];
    int ques1AnsNo = [self whichAnsBeSelected:self.ques1anses];
    int ques2AnsNo = [self whichAnsBeSelected:self.ques2anses];
    if(ques1AnsNo==-1 || ques2AnsNo==-1){
        [SVProgressHUD showErrorWithStatus:@"请完成您的账户信息填写"];
        return;
    }
    NSString *networthLiquid = [self ansStringForNetworthLiquid:ques1AnsNo];
    NSString * networthTotal = [self ansStringForNetworthTotal:ques2AnsNo];
    NSMutableDictionary * accountInfo = [NSMutableDictionary dictionary];
    [accountInfo setObject:networthLiquid forKey:@"networthLiquid"];
    [accountInfo setObject:networthTotal forKey:@"networthTotal"];
    [accountInfo setObject:self.isDirectorSwitch.isOn ? @"true":@"false" forKey:@"director"];
    [accountInfo setObject:self.isPoliticallyExposedSwitch.isOn ? @"true":@"false" forKey:@"politicallyExposed"];
    [NetworkTool addUserInfoWith:accountInfo success:^(id data) {
        [SVProgressHUD dismiss];
        OIMaterialBeenSubmittedController * materialSubmitVC =[[UIStoryboard storyboardWithName:@"OIOpenAccount" bundle:nil]instantiateViewControllerWithIdentifier:@"OIMaterialBeenSubmittedController"];
        [self.navigationController pushViewController:materialSubmitVC animated:YES];
    } error:^(NSError *error) {
        
    }];
}

#pragma mark - private
-(void)setupUI{
    self.ques1anses = @[self.ques1ans1Btn,self.ques1ans2Btn,self.ques1ans3Btn,self.ques1ans4Btn];
    self.ques2anses = @[self.ques2ans1Btn,self.ques2ans2Btn,self.ques2ans3Btn,self.ques2ans4Btn];
    self.isDirectorSwitch.on = NO;
    self.isPoliticallyExposedSwitch.on = NO;
    self.nextStepBtn.backgroundColor = [UIColor lightGrayColor];
    self.nextStepBtn.enabled = NO;
}

///每一次点击遍历数组，取消选中的按钮
-(void)cancellAllBtns:(NSArray *)btns{
    for (UIButton * btn in btns) {
        btn.selected = NO;
    }
}

///找到数组中选中的按钮的序数(答案)
-(int)whichAnsBeSelected:(NSArray*)btns{
    for(int i=0;i<btns.count;i++){
        UIButton * btn = btns[i];
        if(btn.selected){
            return i;
        }
    }
    //没有选择任何答案
    return -1;
}

///返回要上传到服务器的答案(流动资产净值)
-(NSString *)ansStringForNetworthLiquid:(int)No{
    switch (No) {
        case 0:
            return @"$0 - $4,999";
            break;
        case 1:
            return @"$5,000 - $99,999";
            break;
        case 2:
            return @"$100,000 - $199,999";
            break;
        case 3:
            return @"$200,000+";
            break;
        default:
            break;
    }
    return nil;
}

//////返回要上传到服务器的答案(资产净总净值)
-(NSString *)ansStringForNetworthTotal:(int)No{
    switch (No) {
        case 0:
            return @"$0 - $24,999";
            break;
        case 1:
            return @"$25,000 - $99,999";
            break;
        case 2:
            return @"$100,000 - $199,999";
            break;
        case 3:
            return @"$200,000+";
            break;
        default:
            break;
    }
    return nil;
}

@end
