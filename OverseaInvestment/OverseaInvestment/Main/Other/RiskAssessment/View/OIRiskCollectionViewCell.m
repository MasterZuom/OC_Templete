//
//  OIRiskCollectionViewCell.m
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/30.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import "OIRiskCollectionViewCell.h"

@implementation OIRiskCollectionViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.tableViewContoller = [OIQuestionTableViewController new];
    self.tableViewContoller.tableView.frame = self.contentView.bounds;
    [self addSubview:self.tableViewContoller.tableView];
}

@end
