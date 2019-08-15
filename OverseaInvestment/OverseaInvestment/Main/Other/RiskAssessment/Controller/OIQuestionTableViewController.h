//
//  OIQuestionTableViewController.h
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/30.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import <UIKit/UIKit.h>

//代理
@protocol OIQuestionTableViewControllerDelegate <NSObject>
@optional
-(void)tableViewCellDidClick:(NSIndexPath *)indexpath;
@end

@interface OIQuestionTableViewController : UITableViewController

@property(nonatomic,weak)id<OIQuestionTableViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *question;
@property (strong,nonatomic) NSArray * anses;
@property(assign,nonatomic)NSInteger selectedNo;

@end
