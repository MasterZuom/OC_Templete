//
//  OIRiskCollectionController.m
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/30.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import "OIRiskCollectionController.h"
#import "OIQuestionTableViewController.h"
#import "OIRiskCollectionViewCell.h"

@interface OIRiskCollectionController ()<UICollectionViewDelegate,UICollectionViewDataSource,OIQuestionTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowlayout;
@property (weak, nonatomic) IBOutlet UIButton *lastBtn;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControll;

@property(nonatomic,assign)NSInteger nowIndex;
@property(nonatomic,strong)NSArray * questiones;
@property(nonatomic,strong)NSArray * ansers;
@property(nonatomic,strong)NSMutableArray * choosesOfUser;

@end

@implementation OIRiskCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.pagingEnabled = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.pageControll.numberOfPages = self.questiones.count;
    
    self.lastBtn.backgroundColor = [UIColor lightGrayColor];
    self.lastBtn.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.flowlayout.itemSize = self.collectionView.bounds.size;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.flowlayout.itemSize = self.collectionView.bounds.size;
}

#pragma mark - dataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 7;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    OIRiskCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"riskCollectionCell" forIndexPath:indexPath];
    
    cell.tableViewContoller.delegate = self;
    cell.tableViewContoller.question = self.questiones[indexPath.row];
    cell.tableViewContoller.anses = self.ansers[indexPath.row];
    //必须重新刷新
    [cell.tableViewContoller.tableView reloadData];
    return cell;
}

#pragma mark - delegate
//自定义的代理(tableView点击事件的代理方法)
-(void)tableViewCellDidClick:(NSIndexPath *)indexpath{
    if(self.nowIndex <6){
        NSIndexPath * nextIndexpath = [NSIndexPath indexPathForItem:self.nowIndex+1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:nextIndexpath atScrollPosition:0 animated:YES];
    }
    self.choosesOfUser[self.nowIndex] = @(indexpath.row);
    
    NSLog(@"%@",self.choosesOfUser);
}

//collectionCell 滚动的动画停止的时候调用
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/scrollView.bounds.size.width;
    NSLog(@"1---------%ld",index);
    self.nowIndex = index;
    
    OIRiskCollectionViewCell * mycell = (OIRiskCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    mycell.tableViewContoller.selectedNo = [self.choosesOfUser[self.nowIndex] integerValue];
    [mycell.tableViewContoller.tableView reloadData];
    self.pageControll.currentPage = index;
    
    if(index == 0){
        self.lastBtn.backgroundColor = [UIColor lightGrayColor];
        self.lastBtn.enabled = NO;
    }else{
        self.lastBtn.backgroundColor = [UIColor colorWithHexString:@"00BFFF"];
        self.lastBtn.enabled = YES;
    }
}

#pragma mark - 这两个方法是手动滑动collectionView时调用
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    NSInteger index = scrollView.contentOffset.x/scrollView.bounds.size.width;
//    self.nowIndex = index;
//    NSLog(@"2---------%ld",index);
//}
//
//-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//    NSInteger index = scrollView.contentOffset.x/scrollView.bounds.size.width;
//    self.nowIndex = index;
//    NSLog(@"3---------%ld",index);
//}

#pragma mark - 点击事件
- (IBAction)last:(id)sender {
    if(self.nowIndex > 0){
        NSIndexPath * nextIndexpath = [NSIndexPath indexPathForItem:self.nowIndex-1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:nextIndexpath atScrollPosition:0 animated:YES];
    }
}

#pragma mark - 懒加载
-(NSArray *)questiones{
    if(_questiones == nil){
        _questiones = @[@"您的投资目的是",@"以下哪项最符合您在未来1年内对某项投资的情况所持的态度",@"以下情况，您会选择哪一种",@"您的投资经验如何？",@"您的职业为",@"您的学历为",@"您家庭就业状况符合以下哪项"];
    }
    return _questiones;
}

-(NSArray *)ansers{
    if(_ansers == nil){
        _ansers = @[
                    @[@"资产保值，我不愿意承担任何投资风险",
                      @"资产稳健增长，我愿意承担一定投资风险",
                      @"资产迅速增长，我愿意承担很大投资风险"],
                    @[@"我能承受50%以内的亏损",
                      @"我能承受25%以内的亏损",
                      @"我能承受10%以内的亏损",
                      @"我几乎不能承受亏损"],
                    @[@"有100%的机会赢取1000元现金",
                      @"有50%的机会赢取5万元现金",
                      @"有25%的机会赢取50万元现金",
                      @"有10%的机会赢取100万元现金"],
                    @[@"无",
                      @"有限",
                      @"良好",
                      @"丰富"],
                    @[@"无固定职业",
                      @"专业技术人员",
                      @"一般企事业单位员工",
                      @"金融行业一般从业人员",
                      @"其他"],
                    @[@"高中及以下",
                      @"中专或大专",
                      @"本科",
                      @"硕士及以上"],
                    @[@"您与配偶均有稳定收入的工作",
                      @"您与配偶其中一人有稳定收入的工作",
                      @"您与配偶均没有稳定收入的工作或已经退休",
                      @"未婚，但有稳定收入的工作",
                      @"未婚，且目前暂无稳定收入的工作"],
                    ];
    }
    return _ansers;
}

-(NSMutableArray *)choosesOfUser{
    if(_choosesOfUser == nil){
        _choosesOfUser = [NSMutableArray arrayWithObjects:@(0),@(0),@(0),@(0),@(0),@(0),@(0),nil];
    }
    return _choosesOfUser;
}
@end
