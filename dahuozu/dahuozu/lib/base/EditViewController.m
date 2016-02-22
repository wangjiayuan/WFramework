//
//  EditViewController.m
//  dahuozu
//
//  Created by apple on 15/12/17.
//  Copyright © 2015年 dahuozu. All rights reserved.
//

#import "EditViewController.h"

@implementation UIView (FindFirstResponder)
#pragma mark 寻找第一事件响应者
- (UIView *)findFirstResponder
{
    if (self.isFirstResponder)
    {
        return self;
    }
    for (UIView *subView in self.subviews)
    {
        UIView *firstResponder = [subView findFirstResponder];
        if (firstResponder != nil)
        {
            return firstResponder;
        }
    }
    return nil;
}
@end

#pragma mark 实现编辑代理的视图控制器

@interface EditViewController ()
{
    CGFloat startY;
    BOOL _firstDAppear;/////是否第一次视图已经出现
    BOOL _firstWAppear;//////是否第一次视图即将出现
    UITapGestureRecognizer *singleTapGR;////////单击手势（为了编辑时取消编辑）
}
@end

@implementation EditViewController

#pragma mark 初始化时执行的函数
-(void)functionInInit
{
}
#pragma mark 对象销毁时执行的函数
-(void)functionInDealloc
{
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //视图呈现时监听键盘事件
    [self setUpForDismissKeyboard];
    if (_firstDAppear)
    {
        [self firstDidAppear];
        _firstDAppear = NO;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_firstWAppear)
    {
        [self firstWillAppear];
        _firstWAppear = NO;
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeObserverForKeyboard];
}
#pragma mark 视图第一次呈现
-(void)firstDidAppear
{
}
#pragma mark 视图第一次即将呈现
-(void)firstWillAppear
{
}

#pragma mark 重载父类方法并初始化
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        //////////初始化保存图片的对象下载和更新的最大并发数和队列
        _firstDAppear = YES;
        _firstWAppear = YES;
        [self functionInInit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    startY = self.view.frame.origin.y;
    [self.view setBackgroundColor:ColorSystem(whiteColor)];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 单击退出键盘
- (void)setUpForDismissKeyboard
{
    [self removeObserverForKeyboard];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(addTapGestureRecognizer:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(removeTapGestureRecognizer:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChange:)name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void)keyboardWillChange:(NSNotification*)note
{
    NSDictionary *info = [note userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;//获取键盘的size值
    [self editedWork:keyboardSize.height];
}

-(void)addTapGestureRecognizer:(NSNotification*)note
{
    NSDictionary *info = [note userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;//获取键盘的size值
    [self editedWork:keyboardSize.height];
    [self.view addGestureRecognizer:singleTapGR];
}
-(void)removeTapGestureRecognizer:(NSNotification*)note
{
    [self.view removeGestureRecognizer:singleTapGR];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, startY, self.view.frame.size.width, self.view.frame.size.height)];
}
-(void)removeObserverForKeyboard
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [nc removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [nc removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void)editedWork:(CGFloat)h
{
    UIView *view = [self.view findFirstResponder];
    CGFloat y = [view convertPoint:CGPointMake(0, view.frame.size.height+2.0f) toView:[UIApplication sharedApplication].keyWindow].y;
    CGFloat dy = [UIApplication sharedApplication].keyWindow.frame.size.height-y;
    CGFloat newY = self.view.frame.origin.y-(h-dy);
    if (newY<startY)
    {
        CGRect newFrame = CGRectMake(self.view.frame.origin.x, newY, self.view.frame.size.width, self.view.frame.size.height);
        [self.view setFrame:newFrame];
    }
}

#pragma mark 编辑状态下点击退出编辑
- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer
{
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

-(void)dealloc
{
    [self functionInDealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
