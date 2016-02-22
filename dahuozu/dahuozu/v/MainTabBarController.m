//
//  MainTabBarController.m
//  dahuozu
//
//  Created by apple on 16/1/19.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "MainTabBarController.h"
#import "CustomerTabBar.h"

@interface MainTabBarController ()
{
    ActivityListViewController *VC(activity);
    ShareListViewController *VC(share);
    ChatOtherViewController *VC(chat);
    UserInfoViewController *VC(info);
    CustomerTabBar *dahuoTabBar;
}
@end

@implementation MainTabBarController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self setupViewControllers];
        [self setupTabBar];
    }
    return self;
}
#pragma mark 设置视图控制器
-(void)setupViewControllers
{
    activityViewController = Init(ActivityListViewController);
    shareViewController = Init(ShareListViewController);
    chatViewController = Init(ChatOtherViewController);
    infoViewController = Init(UserInfoViewController);
    DaHuoNavigationController *NVC(activity) = [[DaHuoNavigationController alloc]initWithRootViewController:activityViewController];
    DaHuoNavigationController *NVC(share) = [[DaHuoNavigationController alloc]initWithRootViewController:shareViewController];
    DaHuoNavigationController *NVC(chat) = [[DaHuoNavigationController alloc]initWithRootViewController:chatViewController];
    DaHuoNavigationController *NVC(info) = [[DaHuoNavigationController alloc]initWithRootViewController:infoViewController];
    [self setViewControllers:@[NVC(activity),NVC(share),NVC(chat),NVC(info)]];
}
#pragma mark 设置TabBar
-(void)setupTabBar
{
    dahuoTabBar = [[CustomerTabBar alloc] initWithItemsCount:4 customerTitle:NO];
    
    [dahuoTabBar setBackgroundColor:ColorWithRGB(132, 184, 200)];
    
    [[dahuoTabBar buttonAtIndex:0] setSelectedImage:[UIImage imageNamed:@"bar_1_selected"] disselectedImage:[UIImage imageNamed:@"bar_1_disselected"]];
    
    [[dahuoTabBar buttonAtIndex:1] setSelectedImage:[UIImage imageNamed:@"bar_2_selected"] disselectedImage:[UIImage imageNamed:@"bar_2_disselected"]];
    
    [[dahuoTabBar buttonAtIndex:2] setSelectedImage:[UIImage imageNamed:@"bar_3_selected"] disselectedImage:[UIImage imageNamed:@"bar_3_disselected"]];
    
    [[dahuoTabBar buttonAtIndex:3] setSelectedImage:[UIImage imageNamed:@"bar_4_selected"] disselectedImage:[UIImage imageNamed:@"bar_4_disselected"]];
    
    
    [self.tabBar.superview addSubview:dahuoTabBar];
    
    [dahuoTabBar autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.tabBar];
    [dahuoTabBar autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.tabBar];
    [dahuoTabBar autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.tabBar];
    [dahuoTabBar autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.tabBar];
    
    
    for (NSInteger i=0; i<[dahuoTabBar.items count]; i++)
    {
        [[dahuoTabBar buttonAtIndex:i] addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [dahuoTabBar setSelectedIndex:0];
}
#pragma mark 显示某个视图控制器
-(void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
    [dahuoTabBar setSelectedIndex:selectedIndex];
}
-(void)setSelectedViewController:(__kindof UIViewController *)selectedViewController
{
    [super setSelectedViewController:selectedViewController];
    [dahuoTabBar setSelectedIndex:[self.viewControllers indexOfObject:selectedViewController]];
}
#pragma mark 底下按钮点击事件
-(void)tabBarButtonClick:(DaHuoTabBarButton*)button
{
    NSInteger index = [dahuoTabBar indexForButton:button];
    [button setBadgeValue:button.badgeValue+1];
    if (self.selectedIndex!=index)
    {
        [super setSelectedIndex:index];
    }
    else
    {
        [self repeatClickButtonAtIndex:index];
    }
    [dahuoTabBar setSelectedIndex:index];
}
#pragma mark 重复点击某个按钮
-(void)repeatClickButtonAtIndex:(NSInteger)index
{
    
}
#pragma mark 程序一般入口
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
