//
//  EditViewController.h
//  dahuozu
//
//  Created by apple on 15/12/17.
//  Copyright © 2015年 dahuozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableView.h"

@interface EditViewController : UIViewController

#pragma mark 当第一次视图已经显示在界面时
-(void)firstDidAppear;
#pragma mark 当第一次视图将要显示在界面时
-(void)firstWillAppear;
#pragma mark 初始化时执行的函数
-(void)functionInInit;
#pragma mark 对象销毁时执行的函数
-(void)functionInDealloc;

@end
