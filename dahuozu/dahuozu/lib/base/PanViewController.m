//
//  PanViewController.m
//  dahuozu
//
//  Created by apple on 16/1/4.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "PanViewController.h"

@interface PanViewController ()
{
    ///////////////////右滑退出页面
    UIPanGestureRecognizer *rightGesture;
}
@end

@implementation PanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.navigationController!=nil&&self.navigationController.viewControllers.firstObject!=self)
    {
        [self addPanGesture];
    }
}
#pragma mark 添加右滑手势
-(void)addPanGesture
{
    rightGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panToRight:)];
    [self.view addGestureRecognizer:rightGesture];
}
#pragma mark 处理页面回退手势
-(void)panToRight:(UIPanGestureRecognizer*)gesture
{
    if (gesture==rightGesture)
    {
        if (self.navigationController!=nil&&self.navigationController.viewControllers.firstObject!=self)
        {
            if (gesture.state==UIGestureRecognizerStateBegan)
            {
                if (self.navigationController.viewControllers.count>1)
                {
                    [self.navigationController.view setBackgroundColor:[UIColor colorWithPatternImage:[ImageFunction imageFromView:[[self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count-2)] view]]]];
                }
            }
            CGPoint point = [gesture translationInView:self.view];
            if (point.x>=0)
            {
                [self.view setFrame:CGRectMake(point.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
            }
            if (gesture.state==UIGestureRecognizerStateFailed||gesture.state==UIGestureRecognizerStateCancelled)
            {
                [self.view setFrame:CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
                [self.navigationController.view setBackgroundColor:ColorSystem(whiteColor)];
            }
            if (gesture.state==UIGestureRecognizerStateEnded)
            {
                if (point.x>(self.view.frame.size.width/2.0f))//拖动超过一半页面回退
                {
                    [UIView animateWithDuration:0.5f animations:^{
                        [self.view setFrame:CGRectMake(self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
                        [self.view setAlpha:0.0f];
                    } completion:^(BOOL finished) {
                        [self superClearWork];
                        [self.navigationController popViewControllerAnimated:NO];
                        [self.navigationController.view setBackgroundColor:ColorSystem(whiteColor)];
                    }];
                }
                else//拖动未超过一半页面恢复
                {
                    [UIView animateWithDuration:0.5f animations:^{
                        [self.view setFrame:CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
                    } completion:^(BOOL finished) {
                        [self.navigationController.view setBackgroundColor:ColorSystem(whiteColor)];
                    }];
                }
            }
        }
    }
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
