//
//  OIQuestionTableViewController.m
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/30.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import "OIQuestionTableViewController.h"

@interface OIQuestionTableViewController ()

@end

@implementation OIQuestionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView=[[UIView alloc]init];
}

#pragma mark - datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.anses.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row == 0){
        cell.textLabel.text = self.question;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    }else{
        cell.textLabel.text = self.anses[indexPath.row-1];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        if(self.selectedNo == indexPath.row){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 100;
    }
    return 40;
}

#pragma mark - delegate
//选择答案
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.item > 0){
        //遍历cell先取消其他的钩钩
        for(int i=0;i<self.anses.count;i++){
            NSIndexPath * allIndexpath = [NSIndexPath indexPathForRow:i+1 inSection:0];
            UITableViewCell * cell = [tableView cellForRowAtIndexPath:allIndexpath];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        if([self.delegate respondsToSelector:@selector(tableViewCellDidClick:)]){
            [self.delegate tableViewCellDidClick:indexPath];
        }
    }
}

@end
