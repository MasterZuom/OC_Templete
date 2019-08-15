//
//  OIDataReportViewController.m
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/9.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import "OIDataReportViewController.h"
#import "OIPhoneRegisterViewController.h"

#define HighProbabilityColor @"rgba(255,150,61,0.8)"
#define LowProbabilityColor @"rgba(255,188,45,1)"
#define WihteColor @"FFFFFF"
#define AverageValueColor @"FFE86A"


@interface OIDataReportViewController ()

@property (weak, nonatomic) IBOutlet PYEchartsView *ChartView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UITextField *initialAmountTextField;
@property (weak, nonatomic) IBOutlet UIImageView *areaImageView;
@property (weak, nonatomic) IBOutlet UILabel *areaExplainLabel;
@property (weak, nonatomic) IBOutlet UILabel *highProbabilityLabel;

///折线图数据
@property(nonatomic,strong)NSArray *highProbabilityMax;
@property(nonatomic,strong)NSArray *avarageData;
@property(nonatomic,strong)NSArray *highProbabilityMin;
@property(nonatomic,strong)NSArray *years;
@property(nonatomic,assign)long lineChartMaxY;
@property(nonatomic,assign)long lineChartMinY;
@property(nonatomic,strong)NSArray *avarageDataInteger;
//饼图数据
@property(nonatomic,strong)NSArray *assetsEn;
@property(nonatomic,strong)NSArray *assetsCN;
@property(nonatomic,strong)NSArray *assetsDist;

@end

@implementation OIDataReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.ChartView removeHandlerForAction:PYEchartActionPieSelected];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击事件
- (IBAction)nextStepClick:(id)sender {
    OIPhoneRegisterViewController *dataReportVC =  [[UIStoryboard storyboardWithName:@"OILoginAndRegister" bundle:nil] instantiateViewControllerWithIdentifier:@"OIPhoneRegisterViewController"];
    [self presentViewController:dataReportVC animated:NO completion:nil];
}

///关闭
- (IBAction)closeBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

///切换数据表格
- (IBAction)changeTheChart:(UISegmentedControl *)sender {
    if(sender.selectedSegmentIndex == 0){
        [self initLineChart];
        [self hiddenLinechartViewComponent:NO];
    }else{
        [self initPieChart];
        [self hiddenLinechartViewComponent:YES];
    }
}

///重新计算收益
- (IBAction)calculate:(id)sender {
    double income = [self.initialAmountTextField.text doubleValue];
    if(income<500 || income>9999999){
        [SVProgressHUD showErrorWithStatus:@"年收入需在500至1000万之间"];
        return;
    }
    self.initialAmount = self.initialAmountTextField.text;
    [self initChartData];
    [SVProgressHUD showWithStatus:@"正在加载中"];
}

///防止因点击CharView时键盘退出而出现的BUG
- (IBAction)initialTextFieldDidBegin:(id)sender {
    self.ChartView.userInteractionEnabled = NO;
}
- (IBAction)initialTextFieldDidEnd:(id)sender {
    self.ChartView.userInteractionEnabled = YES;
}

#pragma mark - 获取网络数据
- (void)initChartData{
    //调度组请求多条数据
    //1.创建队列组
    dispatch_group_t group = dispatch_group_create();
    //2.创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //3.调度组 任务一 (获取折线图数据)
    dispatch_group_async(group, queue, ^{
        //进组
        dispatch_group_enter(group);
        
        [NetworkTool getUserInvestmentExpectationProfitsData:[NSMutableDictionary dictionaryWithObject:self.initialAmount forKey:@"initial_amount"] success:^(id data) {
            
            self.highProbabilityMin = [self processingDataWith:data[@"assets_income"][1] needDecimals:YES];
            self.avarageData = [self processingDataWith:data[@"assets_income"][2] needDecimals:YES];
            self.avarageDataInteger = [self processingDataWith:data[@"assets_income"][2] needDecimals:NO];
            self.highProbabilityMax = [self processingDataWith:data[@"assets_income"][3] needDecimals:YES];
            self.years = [self calculateYearsWith:self.avarageData];
            long maxNum = [self.highProbabilityMax[self.years.count-1] longValue];
            long minNum = [self.highProbabilityMin[0] longValue];
            //折线图纵坐标的最小值
            self.lineChartMinY = [self calculateMinY:minNum];
            //折线图纵坐标的最大值
            self.lineChartMaxY = [self calculateMaxY:maxNum];
            
            dispatch_group_leave(group);
            
        } error:^(NSError *error) {
            dispatch_group_leave(group);
        }];
    });
    
    //调度组 任务二（获取饼状图数据）
    dispatch_group_async(group, queue, ^{
        //进组
        dispatch_group_enter(group);
        
        [NetworkTool getUserPropertyMatchingData:nil success:^(id data) {
            NSDictionary * dist = data[@"assets_dist"][@"dist"];
            NSDictionary * assets = data[@"assets_dist"][@"assets"];
            self.assetsEn = [self getAllAssets:assets inChines:NO];
            self.assetsCN = [self getAllAssets:assets inChines:YES];
            self.assetsDist = [self getAssetsDistForPieChart:dist assets:assets inChines:YES];
            dispatch_group_leave(group);
        } error:^(NSError *error) {
            dispatch_group_leave(group);
        }];
    });
    
    //4.队列组所有请求完成回调刷新UI
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //刷新表格
        if(self.segmentControl.selectedSegmentIndex == 0){
            [self initLineChart];
        }else{
            [self initPieChart];
        }
        [SVProgressHUD dismiss];
        NSLog(@"--------数据获取完毕-------");
    });
}

#pragma mark - 加载表格数据
///加载折线（区域图）
- (void)initLineChart {
    PYNoDataLoadingOption * noDataLoadOption = [PYNoDataLoadingOption new];
    noDataLoadOption.text = @"正在加载中";
    [_ChartView setNoDataLoadingOption:noDataLoadOption];
        
    PYOption *lineOption = [self basicAreaOption];
    [_ChartView setOption:lineOption];
    [_ChartView loadEcharts];
    //刷新标签
    if(self.highProbabilityMax){
       self.highProbabilityLabel.text = [NSString stringWithFormat:@"$%ld万-$%ld万",(long)round([self.highProbabilityMin.lastObject doubleValue]),(long)round([self.highProbabilityMax.lastObject doubleValue])];
    }
}

///加载饼状图
- (void)initPieChart {
    PYOption *pieOption = [self doughnutPieOption];
    [_ChartView setOption:pieOption];
    [_ChartView loadEcharts];
}

///折线面积图的参数
- (PYOption *)basicAreaOption {
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
            title.textEqual(@"预期收益（万美元）").subtextEqual(@"平均年收益率：5.25%");
        }])
        .gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {
            grid.xEqual(@40).x2Equal(@50).y2Equal(@40).borderWidthEqual(@0);
        }])
        .tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
            tooltip.triggerEqual(PYTooltipTriggerAxis)
           .formatterEqual(@"至{b}年您的预期<br/>收益: ${c2}万");
        }])
        .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
            legend.dataEqual(@[@"高概率max",@"高概率min",@"平均值"])
            .showEqual(NO);
        }])
        .calculableEqual(NO)
        .addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            //设置横坐标的属性
            axis.splitLine.showEqual(NO);
            axis.axisLine.showEqual(NO);
            axis.typeEqual(PYAxisTypeCategory).boundaryGapEqual(@NO).addDataArr(self.years);
        }])
        .addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            //设置纵坐标的属性
            axis.typeEqual(PYAxisTypeValue);
            axis.maxEqual(@(self.lineChartMaxY));
            if(self.lineChartMinY>10){
              axis.minEqual(@(self.lineChartMinY));
            }
            axis.positionEqual(@"right");
            axis.axisLine.showEqual(NO);
        }])
//        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
//            series.smoothEqual(YES).symbolEqual(@"none")
//            .nameEqual(@"低概率min")
//            .typeEqual(PYSeriesTypeLine)
//            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
//                
//                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
//                    //设置线条的属性（设置为透明）
//                    normal.colorEqual(@"transparent");
//                    normal.areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
//                        //设置线条下面区域的颜色为（最底下线条下面区域的颜色）(此颜色应该与背景颜色一致)
//                        areaStyle.typeEqual(PYAreaStyleTypeDefault).colorEqual(@"FFFFFF");
//                    }]);
//                }]);
//            }])
//            .dataEqual(self.lowProbabilityMin);
//        }])
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.smoothEqual(YES).symbolEqual(@"none")
            .nameEqual(@"高概率min")
            .typeEqual(PYSeriesTypeLine)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
                    //设置线条的属性（设置为透明）
                    normal.colorEqual(@"transparent");
                    normal.areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
                        //有色区域的最下方区域的颜色（应该与最上方区域的颜色一致）
                        areaStyle.typeEqual(PYAreaStyleTypeDefault).colorEqual(WihteColor);
                    }]);
                }]);
            }])
            .dataEqual(self.highProbabilityMin);
        }])
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.smoothEqual(YES).symbolEqual(@"none")
            .nameEqual(@"平均值")
            .typeEqual(PYSeriesTypeLine)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
                    //设置平均值曲线线条的颜色
                    normal.colorEqual(AverageValueColor);
                    normal.areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
                        //设为透明即可
                        areaStyle.typeEqual(PYAreaStyleTypeDefault).colorEqual(@"transparent");
                    }]);
                }]);
            }])
            .dataEqual(self.avarageData);
        }])
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.smoothEqual(YES).symbolEqual(@"none")
            .nameEqual(@"平均值整数形式(只为显示整数形式的纵坐标用的)")
            .typeEqual(PYSeriesTypeLine)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
                    //设置平均值曲线线条的颜色
                    normal.colorEqual(@"transparent");
                    normal.areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
                        //设为透明即可
                        areaStyle.typeEqual(PYAreaStyleTypeDefault).colorEqual(@"transparent");
                    }]);
                }]);
            }])
            .dataEqual(self.avarageDataInteger);
        }])
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.smoothEqual(YES).symbolEqual(@"none")
            .nameEqual(@"高概率max")
            .typeEqual(PYSeriesTypeLine)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
                    //设置线条的属性（设置为透明）
                    normal.colorEqual(@"transparent");
                    normal.areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
                        //有色区域的中间区域的颜色
                        areaStyle.typeEqual(PYAreaStyleTypeDefault).colorEqual(HighProbabilityColor);
                    }]);
                }]);
            }])
            .dataEqual(self.highProbabilityMax);
        }]);
//        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
//            series.smoothEqual(YES).symbolEqual(@"none")
//            .nameEqual(@"低概率max")
//            .typeEqual(PYSeriesTypeLine)
//            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
//                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
//                    //设置线条的属性（设置为透明）
//                    normal.colorEqual(@"transparent");
//                    normal.areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
//                        //有色区域的最上方区域的颜色（应该与最下方区域的颜色一致）
//                        areaStyle.typeEqual(PYAreaStyleTypeDefault).colorEqual(LowProbabilityColor);;
//                    }]);
//                }]);
//            }])
//            .dataEqual(self.lowProbabilityMax);
//        }]);
    }];
}

//环形图参数
- (PYOption *)doughnutPieOption{
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
            tooltip.triggerEqual(PYTooltipTriggerItem)
            .formatterEqual(@" {b} :<br/> {d}%");
        }])
        .titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
            title.textEqual(@"产品组合模型");
        }])
        .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
            legend.orientEqual(PYOrientVertical)
            .xEqual(@"55%")
            .yEqual(@"20%")
            .selectedModeEqual(@(NO))
            .dataEqual(self.assetsCN);
        }])
        .calculableEqual(NO)
        .addSeries([PYPieSeries initPYPieSeriesWithBlock:^(PYPieSeries *series) {
            series.selectedModeEqual(@"single")
            .centerEqual(@[@"25%",@"50%"])
            .radiusEqual(@[@"30%",@"50%"])
            .nameEqual(@"访问来源")
            .typeEqual(PYSeriesTypePie)
            .dataEqual(self.assetsDist)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp){
                    itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                        label.showEqual(NO);
                        
                    }])
                    .labelLineEqual([PYLabelLine initPYLabelLineWithBlock:^(PYLabelLine *labelLine) {
                        labelLine.showEqual(NO);
                    }]);
                }])
                .emphasisEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp){
                    itemStyleProp.labelLine.showEqual(NO);
                    itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                        label.showEqual(NO).positionEqual(PYPositionCenter)
                        .textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                            textStyle.fontSizeEqual(@30)
                            .fontWeightEqual(PYTextStyleFontWeightBold);
                        }]);
                    }]);
                }]);
            }]);
        }]);
    }];
}

#pragma mark - Private
-(void)setupUI{
    self.highProbabilityLabel.text = @"$0万-$0万";
    self.initialAmountTextField.text = self.initialAmount;
    [self initLineChart];
    [self initChartData];
}

///对后台返回的数据进行处理(需不需要小数值)
-(NSArray *)processingDataWith:(id)data needDecimals:(BOOL)need{
    NSMutableArray * dataArr = [NSMutableArray new];
    for (NSString * numString in data) {
        double num = [numString doubleValue];
        if(need){
            double chartNum = round(num/10000*100) / 100;
            [dataArr addObject:@(chartNum)];
        }else{
            long chartNumInt = round(num/10000);
            [dataArr addObject:@(chartNumInt)];
        }
    }
    return dataArr.copy;
}

///对年份做一个计算
-(NSArray*)calculateYearsWith:(NSArray *)data{
    NSMutableArray * years = [NSMutableArray new];
    long thisYear = 2016;
    [years addObject:@"2016"];
    for(int i=1;i<data.count;i++){
        thisYear += 1;
        [years addObject:[NSString stringWithFormat:@"%ld",thisYear]];
    }
    return years.copy;
}

///计算Y轴最大坐标值
-(long)calculateMaxY:(long)y{
    if(y<10){
        return (long)(y+y*0.2);
    }else{
        return (long)(y+y*0.1)/10 *10;
    }
}

///计算Y轴最小坐标值
-(long)calculateMinY:(long)y{
    if(y<=10){
        return y;
    }else{
        return (long)(y-y*0.05)/10 *10;
    }
}

///处理饼状图数据，返回所有资产的数组(isChinese 是中文 否则英文)
-(NSArray *)getAllAssets:(NSDictionary *)assets inChines:(BOOL)isChinese{
    NSMutableArray * assetsArrM = [NSMutableArray new];
    [assets enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSDictionary * obj, BOOL * _Nonnull stop) {
        if(isChinese){
            [assetsArrM addObject:obj[@"name_cn"]];
        }else{
            [assetsArrM addObject:obj[@"name_en"]];
        }
    }];
    return assetsArrM.copy;
}

///获取资产配比数据
-(NSArray *)getAssetsDistForPieChart:(NSDictionary *)dist assets:(NSDictionary *)assets inChines:(BOOL)isChinese{
    NSMutableArray * assetsDistArrM = [NSMutableArray new];
    [dist enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString *obj, BOOL * _Nonnull stop) {
        NSMutableDictionary * assetsDistDic = [NSMutableDictionary new];
        double assetValue = [obj doubleValue] * 100;
        [assetsDistDic setObject:@(assetValue) forKey:@"value"];
        if(isChinese){
            [assetsDistDic setObject:assets[key][@"name_cn"] forKey:@"name"];
        }else{
            [assetsDistDic setObject:assets[key][@"name_en"] forKey:@"name"];
        }
        [assetsDistArrM addObject:assetsDistDic];
    }];
    return assetsDistArrM.copy;
}

///隐藏用来说明lineChartView的小控件
-(void)hiddenLinechartViewComponent:(BOOL)hidden{
    if(hidden){
        self.areaImageView.hidden = YES;
        self.areaExplainLabel.hidden = YES;
        self.highProbabilityLabel.hidden = YES;
    }else{
        self.areaImageView.hidden = NO;
        self.areaExplainLabel.hidden = NO;
        self.highProbabilityLabel.hidden = NO;
    }
}

@end
