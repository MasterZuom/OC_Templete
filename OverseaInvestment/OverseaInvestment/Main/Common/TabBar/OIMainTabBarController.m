//
//  OIMainTabBarController.m
//  OverseaInvestment
//
//  Created by mao zuo on 16/11/3.
//  Copyright © 2016年 B2C. All rights reserved.
//

#import "OIMainTabBarController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "OIProfileTableViewController.h"

@interface OIMainTabBarController ()

@end

@implementation OIMainTabBarController

#pragma mark - view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加子控制器
    [self setupChildsViewController];
    
    if (@available(iOS 15.0, *)){
        
        UITabBarAppearance *bar = [UITabBarAppearance new];
        bar.stackedLayoutAppearance.selected.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor redColor]};
        bar.stackedLayoutAppearance.normal.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blueColor]};
        self.tabBar.scrollEdgeAppearance = bar;
        self.tabBar.standardAppearance = bar;
    }else{
        self.tabBar.backgroundColor = [UIColor whiteColor];
        self.tabBar.barTintColor = [UIColor whiteColor];
        self.tabBar.translucent = NO;
    
//        self.tabBar.backgroundColor = IUIColor whiteColorl:
//        self.tabBar.barTintColor = [UlColor whiteColor1:
//        self.tabBar.translucent = NO
//        IUlTabBar appearance] setBackgroundlmage:(Ullmage imageWithColor:[UlColor whiteColorl:UlTabBarltem appearancel setTitleTextAttributes:@NSForegroundColorAttributeName:k tab normalColor!forState:UIControlStateNormall;
//        (UlTabBarltem appearance] setTitleTextAttributes:@(NSForegroundColorAttributeName:[UlColor redColorj)forState:UlControlStateSelectedl;
    }
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - 创建子控制器
/// 创建控制器
- (void)setupChildsViewController {
    
    FirstViewController *firstVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FirstViewController"];
    [self addOneChildViewController:firstVC image:@"News25x25" selectedImage:@"NewsSelected25x25" title:@"新闻"];
    
    SecondViewController *secondVC =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SecondViewController"];;
    [self addOneChildViewController:secondVC image:@"Deal25x25" selectedImage:@"DealSelected25x25" title:@"项目"];
    
    OIProfileTableViewController *profileVC =  [[UIStoryboard storyboardWithName:@"OIProfile" bundle:nil] instantiateViewControllerWithIdentifier:@"OIProfileTableViewController"];
    [self addOneChildViewController:profileVC image:@"Account25x25" selectedImage:@"AccountSelected25x25" title:@"我的"];
}

///添加一个子控制器
- (void)addOneChildViewController:(UIViewController *)vc image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title{
    
    // 包装一个导航控制器后,再成为tabbar的子控制器
    OINavigationController *nav = [[OINavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
    nav.tabBarItem.image = [UIImage imageNamed:image];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    nav.tabBarItem.title = title;
}


@end
