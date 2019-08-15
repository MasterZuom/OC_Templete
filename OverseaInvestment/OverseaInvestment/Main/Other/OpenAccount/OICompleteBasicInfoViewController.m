//
//  OICompleteBasicInfoViewController.m
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/11.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import "OICompleteBasicInfoViewController.h"
#import "OIIDCardInfoViewController.h"

@interface OICompleteBasicInfoViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextfield;
@property (weak, nonatomic) IBOutlet UITextField *industryTextField;

@property(nonatomic,strong)UIPickerView * countryPicker;
@property(nonatomic,strong)UIPickerView * industryPicker;
///cities[index][0]表示国家中文名称  cities[index][1]表示国家区号
@property(nonatomic,strong)NSArray * cities;
///industries[index][0]表示行业中文名称  industries[index][1]表示行业英文名称
@property(nonatomic,strong)NSArray * industries;
//公司所属类型代号(上传给服务器的参数)
@property(nonatomic,copy)NSString * industryType;
//公司所属国家代号(上传给服务器的国家三个字母的国家代号，如：美国 USA）
@property(nonatomic,copy)NSString * countryID;

@end

@implementation OICompleteBasicInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - 点击事件
- (IBAction)nextStepClick:(id)sender {
//    if(self.nameTextField.text==nil || [self.nameTextField.text isEqualToString:@""]){
//        [SVProgressHUD showErrorWithStatus:@"姓名不能为空"];
//        return;
//    }
//    if(self.emailTextField.text==nil || [self.emailTextField.text isEqualToString:@""]){
//        [SVProgressHUD showErrorWithStatus:@"邮箱不能为空"];
//        return;
//    }
//    if(self.companyTextField.text==nil || [self.companyTextField.text isEqualToString:@""]){
//        [SVProgressHUD showErrorWithStatus:@"公司名称不能为空"];
//        return;
//    }
//    if(self.industryTextField.text==nil || [self.industryTextField.text isEqualToString:@""]){
//        [SVProgressHUD showErrorWithStatus:@"请选择公司所属的行业类型"];
//        return;
//    }
//    if(![self isValidateEmail:self.emailTextField.text]){
//        [SVProgressHUD showErrorWithStatus:@"请输入正确的邮箱格式"];
//        return;
//    }
    //更新用户账户信息
//    NSMutableDictionary * userInfo = [NSMutableDictionary dictionary];
//    [userInfo setObject:self.nameTextField.text forKey:@"name"];
//    [userInfo setObject:self.emailTextField.text forKey:@"email"];
//    [userInfo setObject:self.companyTextField.text forKey:@"employerCompany"];
//    [userInfo setObject:self.industryType forKey:@"employerBusiness"];
//    [userInfo setObject:self.countryID forKey:@"employerCountryID"];
    
    OIIDCardInfoViewController * idCardInfoVC = [[UIStoryboard storyboardWithName:@"OIOpenAccount" bundle:nil]instantiateViewControllerWithIdentifier:@"OIIDCardInfoViewController"];
    [self.navigationController pushViewController:idCardInfoVC animated:YES];
    return;
    
//    [SVProgressHUD showWithStatus:@"正在加载..."];
//    [NetworkTool addUserInfoWith:userInfo success:^(id data) {
//        OIIDCardInfoViewController * idCardInfoVC = [[UIStoryboard storyboardWithName:@"OIOpenAccount" bundle:nil]instantiateViewControllerWithIdentifier:@"OIIDCardInfoViewController"];
//        [self.navigationController pushViewController:idCardInfoVC animated:YES];
//        [SVProgressHUD dismiss];
//        
//    } error:^(NSError *error) {
//        
//    }];
}

#pragma mark - Private
-(void)setupUI{
    self.countryTextfield.inputView=self.countryPicker;
    self.industryTextField.inputView = self.industryPicker;
    //国家代号默认是中国
    self.countryID = @"CHN";
}

///验证邮箱的正则表达式
-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - pickerView delegate and dataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(pickerView == self.countryPicker){
        return self.cities.count;
    }else{
        return self.industries.count;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(pickerView == self.countryPicker){
        return self.cities[row][0];
    }else{
        return self.industries[row][0];
    }
}

///pickerView滑动停止下来调用的代理方法
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView == self.countryPicker){
        self.countryTextfield.text = self.cities[row][0];
        self.countryID = self.cities[row][1];
    }else{
        self.industryTextField.text = self.industries[row][0];
        self.industryType = self.industries[row][1];
    }
}

#pragma mark - 懒加载
-(NSArray *)cities{
    if(_cities==nil){
        NSArray * cities =[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"cities.plist" ofType:nil]];
        _cities=cities;
    }
    return _cities;
}

-(NSArray *)industries{
    if(_industries==nil){
        NSArray * industries =[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"industries.plist" ofType:nil]];
        _industries=industries;
    }
    return _industries;
}

-(UIPickerView *)countryPicker{
    if(_countryPicker==nil){
        _countryPicker=[UIPickerView new];
        _countryPicker.delegate = self;
        _countryPicker.dataSource = self;
    }
    return _countryPicker;
}

-(UIPickerView *)industryPicker{
    if(_industryPicker==nil){
        _industryPicker=[UIPickerView new];
        _industryPicker.delegate = self;
        _industryPicker.dataSource = self;
    }
    return _industryPicker;
}
@end
