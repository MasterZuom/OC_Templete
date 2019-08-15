//
//  OIIDCardInfoViewController.m
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/14.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import "OIIDCardInfoViewController.h"
#import "OIOtherAccountInfoTableViewController.h"
@interface OIIDCardInfoViewController ()<FSMediaPickerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *idCardTextField;
@property (weak, nonatomic) IBOutlet UITextField *idcardAddressTextField;
@property (weak, nonatomic) IBOutlet UIImageView *idcardFrontImageView;
@property (weak, nonatomic) IBOutlet UIImageView *idcardBottomImageView;
@property(nonatomic,strong)FSMediaPicker * frontImagePicker;
@property(nonatomic,strong)FSMediaPicker * bottomImagePicker;
//用于上传到服务器的图片
@property(nonatomic,strong)UIImage *originalFrontImage;
@property(nonatomic,strong)UIImage *originalBottomImage;

@end

@implementation OIIDCardInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 点击事件
///点击身份证正面事件
-(void)idcardFrontClick{
    self.frontImagePicker = [[FSMediaPicker alloc]initWithDelegate:self];
    self.frontImagePicker.mediaType = FSMediaTypePhoto;
    self.frontImagePicker.editMode = FSEditModeNone;
    [self.frontImagePicker showFromView:self.view];
}

///点击身份证背面事件
-(void)idcardBottomClick{
    self.bottomImagePicker = [[FSMediaPicker alloc]initWithDelegate:self];
    self.bottomImagePicker.mediaType = FSMediaTypePhoto;
    self.bottomImagePicker.editMode = FSEditModeNone;
    [self.bottomImagePicker showFromView:self.view];
}

///下一步按钮点击
- (IBAction)nextStepClick {
//    if(self.idCardTextField.text==nil || [self.idCardTextField.text isEqualToString:@""]){
//        [SVProgressHUD showErrorWithStatus:@"身份证号码不能为空"];
//        return;
//    }
//    if(self.idcardAddressTextField.text==nil || [self.idcardAddressTextField.text isEqualToString:@""]){
//        [SVProgressHUD showErrorWithStatus:@"身份证地址不能为空"];
//        return;
//    }
//    if(self.idcardFrontImageView.image == nil){
//        [SVProgressHUD showErrorWithStatus:@"身份证正面照不能为空"];
//        return;
//    }
//    if(self.idcardBottomImageView.image == nil){
//        [SVProgressHUD showErrorWithStatus:@"身份证背面照不能为空"];
//        return;
//    }
//    if(![self validateIdentityCard:self.idCardTextField.text]){
//        [SVProgressHUD showErrorWithStatus:@"请输入合法的身份证号码"];
//        return;
//    }
    
    OIOtherAccountInfoTableViewController * otherAccountInfoVC =[[UIStoryboard storyboardWithName:@"OIOpenAccount" bundle:nil]instantiateViewControllerWithIdentifier:@"OIOtherAccountInfoTableViewController"];
    [self.navigationController pushViewController:otherAccountInfoVC animated:YES];

//    [SVProgressHUD showWithStatus:@"正在上传照片，请稍后..."];
//    NSMutableDictionary * idAndidAddress = [NSMutableDictionary dictionary];
//    [idAndidAddress setObject:self.idCardTextField.text forKey:@"idNo"];
//    [idAndidAddress setObject:self.idcardAddressTextField.text forKey:@"addressLine1"];
//    NSArray * photos = @[self.idcardFrontImageView.image,self.idcardBottomImageView.image];
//    NSArray * fileNames = @[@"userIDCardFrontPhoto.jpg",@"userIDCardBottomPhoto.jpg"];
//    NSArray * names = @[@"id_photo1",@"id_photo2"];
//    [NetworkTool uploadIDCardImages:photos fileNames:fileNames names:names otherInfo:idAndidAddress success:^(NSURLSessionDataTask *task, id responseObject) {
//        [SVProgressHUD dismiss];
//        NSLog(@"%@",responseObject);
//        OIOtherAccountInfoTableViewController * otherAccountInfoVC =[[UIStoryboard storyboardWithName:@"OIOpenAccount" bundle:nil]instantiateViewControllerWithIdentifier:@"OIOtherAccountInfoTableViewController"];
//        [self.navigationController pushViewController:otherAccountInfoVC animated:YES];
//    } error:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"失败了哥！");
//    }];
}

#pragma mark - private
-(void)setupUI{
    UITapGestureRecognizer * idcardFrontClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(idcardFrontClick)];
    [self.idcardFrontImageView addGestureRecognizer:idcardFrontClick];
    UITapGestureRecognizer * idcardBottomClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(idcardBottomClick)];
    [self.idcardBottomImageView addGestureRecognizer:idcardBottomClick];
}

///检验身份证是否合法的正则表达式
- (BOOL)validateIdentityCard: (NSString *) idCard{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}

#pragma mark - delegate
- (void)mediaPicker:(FSMediaPicker *)mediaPicker didFinishWithMediaInfo:(NSDictionary *)mediaInfo{
    if(mediaPicker == self.frontImagePicker){
        self.idcardFrontImageView.image = mediaInfo[@"UIImagePickerControllerOriginalImage"];
    }else if(mediaPicker == self.bottomImagePicker){
        self.idcardBottomImageView.image = mediaInfo[@"UIImagePickerControllerOriginalImage"];
    }
}
@end
