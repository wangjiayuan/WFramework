//
//  DaHuoCommonController.m
//  dahuozu
//
//  Created by apple on 16/1/19.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "DaHuoCommonController.h"

@interface DaHuoCommonController ()

@end

@implementation DaHuoCommonController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCommonSettings];
    
}
#pragma mark 设置通用导航栏格式
-(void)setCommonSettings
{
    [self.navigationController.navigationBar setBarTintColor:MAIN_COLOR];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
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
