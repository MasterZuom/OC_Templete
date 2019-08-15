//
//  OIMyHistoryBenifitViewController.m
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/28.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import "OIMyHistoryBenifitViewController.h"

@interface OIMyHistoryBenifitViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet PYEchartsView *chartView;
@property (weak, nonatomic) IBOutlet UITableView *benefitTableview;


//折线图的数据
@property(nonatomic,strong)NSArray * days;
@property(nonatomic,strong)NSArray * everyDaysBenifits;

@end

@implementation OIMyHistoryBenifitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
///加载UI
-(void)setupUI{
    [self initData];
    self.title = @"历史收益";
    self.benefitTableview.delegate = self;
    self.benefitTableview.dataSource = self;
    [self.chartView setOption:[self standardLineOption]];
    [self.chartView loadEcharts];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

///加载网络数据
-(void)initData{
    self.days = @[@"2016.10.1",@"2016.10.2",@"2016.10.3",@"2016.10.4",@"2016.10.5",@"2016.10.6",@"2016.10.7"];
    self.everyDaysBenifits = @[@(8),@(2),@(4),@(12),@(5),@(18),@(22)];
    
}

#pragma mark - 加折线图
///加载折线图
- (PYOption *)standardLineOption {
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
            title.textEqual(@"收益趋势");
        }])
        .tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
            tooltip.triggerEqual(PYTooltipTriggerAxis);
        }])
        .gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {
            grid.xEqual(@40).x2Equal(@50).y2Equal(@20).borderWidthEqual(@0);
        }])
        .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
            legend.xEqual(@"70%").yEqual(@"10%").selectedModeEqual(@NO);
            legend.dataEqual(@[@"收益"]);
        }])
        .addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            //设置横坐标
            axis.splitLine.showEqual(NO);
            axis.axisLine.showEqual(NO);
            axis.typeEqual(PYAxisTypeCategory)
            .boundaryGapEqual(@NO)
            .addDataArr(self.days);
        }])
        .addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            //设置纵坐标
            axis.positionEqual(@"right");
            axis.axisLine.showEqual(NO);
            axis.typeEqual(PYAxisTypeValue)
            .axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) {
                axisLabel.formatterEqual(@"{value} W");
            }]);
        }])
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.smoothEqual(YES).symbolEqual(@"none")
            .nameEqual(@"收益")
            .typeEqual(PYSeriesTypeLine)
            .dataEqual(self.everyDaysBenifits);
        }]);
        //        .addSeries([PYSeries initPYSeriesWithBlock:^(PYSeries *series) {
        //            series.nameEqual(@"最高温度")
        //            .typeEqual(PYSeriesTypeLine)
        //            .dataEqual(@[@(11),@(11),@(15),@(13),@(12),@(13),@(10)]);
        //        }]);
    }];
}

#pragma mark - tableView Delegate And Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.days.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"benefitCell" forIndexPath:indexPath];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"benefitCell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.days[indexPath.row]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@(万元)",[self.everyDaysBenifits[indexPath.row] stringValue]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

@end
