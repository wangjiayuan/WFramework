//
//  NewMessageView.m
//  我的QQ
//
//  Created by wjymac on 15-1-25.
//  Copyright (c) 2015年 wjymac. All rights reserved.
//

#import "BaseTableView.h"
@implementation BaseTableView
{
    UIImageView *downRefreshAnimationImageView;
    CAGradientLayer *downRefreshAnimationLayer;
    UILabel *downRefreshStateMessageLabel;
    UIImage *downRefreshImageStatic;
    UIImage *downRefreshImageAnimation;
    NSString *downRefreshNormalText;
    NSString *downRefreshGoingText;
    NSString *downRefreshInText;
    
    UILabel *upRefreshStateMessageLabel;
    NSString *upRefreshNormalText;
    NSString *upRefreshGoingText;
    NSString *upRefreshInText;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setDelegate:self];
        
        _needDownRefresh = YES;
        _needUpRefresh = YES;
        self.stateChangePoint = 45.0f;
        

        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        
        _downRefreshStateView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -445.0f, frame.size.width, 445.0f)];
        [_downRefreshStateView setBackgroundColor:ColorSystem(whiteColor)];
        [_downRefreshStateView setUserInteractionEnabled:YES];
        
        
        downRefreshInText = @"正在刷新...";
        downRefreshNormalText = @"下拉刷新";
        downRefreshGoingText = @"释放立即刷新";
        
        
        downRefreshAnimationImageView = [UIImageView new];
        CGSize downRefreshImageSize = CGSizeMake(60.0f, 40.0f);
        NSData *imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loding" ofType:@"gif"]];
        downRefreshImageAnimation = [ImageFunction decodedImageWithImage:[ImageFunction imageWithData:imageData] toWidth:60.0f];
        downRefreshImageStatic = [ImageFunction decodedImageWithImage:[ImageFunction staticImageFromData:imageData] toWidth:60.0f];
        [downRefreshAnimationImageView setImage:downRefreshImageStatic];
        [downRefreshAnimationImageView setAlpha:0.0f];
        [_downRefreshStateView addSubview:downRefreshAnimationImageView];
        
        
        
        downRefreshStateMessageLabel = [UILabel new];
        [downRefreshStateMessageLabel setFont:FontSystem(14)];
        [downRefreshStateMessageLabel setTextColor:ColorSystem(lightGrayColor)];
        [downRefreshStateMessageLabel setNumberOfLines:0];
        [_downRefreshStateView addSubview:downRefreshStateMessageLabel];
        
        
        _progressView = [[ColorsProgress alloc]initWithFrame:CGRectZero colors:@[ColorSystem(redColor),ColorSystem(orangeColor),ColorSystem(yellowColor),ColorSystem(greenColor)]];
        [_downRefreshStateView addSubview:_progressView];
        [_progressView autoPinEdge: ALEdgeBottom toEdge:ALEdgeBottom ofView:_downRefreshStateView];
        [_progressView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_downRefreshStateView];
        [_progressView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_downRefreshStateView];
        [_progressView autoSetDimension:ALDimensionHeight  toSize:2.0f];
        
        
        [downRefreshAnimationImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_downRefreshStateView withOffset:-45.0f];
        [downRefreshAnimationImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_downRefreshStateView withOffset:30.0f];
        [downRefreshAnimationImageView autoSetDimensionsToSize:downRefreshImageSize];
        
        
        
        [downRefreshStateMessageLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:downRefreshAnimationImageView withOffset:15.0f];
        [downRefreshStateMessageLabel autoSetDimension:ALDimensionWidth toSize:160.0f];
        [downRefreshStateMessageLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:downRefreshAnimationImageView];
        [downRefreshStateMessageLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:downRefreshAnimationImageView];
        
        
        [self addSubview:_downRefreshStateView];
        
        _isDownRefresh = NO;
        
        
       
        
        _upRefreshStateView = [UIImageView new];
        [_upRefreshStateView setUserInteractionEnabled:YES];
        [_upRefreshStateView setFrame:CGRectMake(0, frame.size.height, frame.size.width, 445.0f)];
        
        upRefreshInText = @"正在加载...";
        upRefreshNormalText = @"上拉加载";
        upRefreshGoingText = @"释放加载更多";
        
        
        [self addSubview:_upRefreshStateView];
        
        
        _loadView = [[CRLoadView alloc]initWithFrame:CGRectMake(0, 0, 35.0f, 35.0f) color:ColorSystem(lightGrayColor)];
        [_upRefreshStateView addSubview:_loadView];
        
        
        upRefreshStateMessageLabel = [UILabel new];
        [upRefreshStateMessageLabel setFont:FontSystem(14)];
        [upRefreshStateMessageLabel setTextColor:ColorSystem(lightGrayColor)];
        [upRefreshStateMessageLabel setNumberOfLines:0];
        [_upRefreshStateView addSubview:upRefreshStateMessageLabel];
        
        
        [_loadView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_upRefreshStateView withOffset:5.0f];
        [_loadView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_upRefreshStateView withOffset:45.0f];
        [_loadView autoSetDimensionsToSize:CGSizeMake(35.0f, 35.0f)];
        
        
        [upRefreshStateMessageLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_loadView withOffset:30.0f];
        [upRefreshStateMessageLabel autoSetDimension:ALDimensionWidth toSize:160.0f];
        [upRefreshStateMessageLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_loadView];
        [upRefreshStateMessageLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_loadView];
        
        
        _isUpRefresh = NO;
        
    }
    return self;
}
-(void)setNeedDownRefresh:(BOOL)need
{
    _needDownRefresh = need;
    
    [self downReturnNormal];
    
    if (!_needDownRefresh)
    {
        [_downRefreshStateView removeFromSuperview];
    }
    else
    {
        [self addSubview:_downRefreshStateView];
    }
}
-(void)setNeedUpRefresh:(BOOL)need
{
    _needUpRefresh = need;
    [self upReturnNormal];
    if (!_needUpRefresh)
    {
        [_upRefreshStateView removeFromSuperview];
    }
    else
    {
        [self addSubview:_upRefreshStateView];
    }
}
#pragma mark 刷新结束
-(void)endDownRefresh
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    
    downRefreshNormalText = [NSString stringWithFormat:@"下拉刷新\n最近更新：%@",[formatter stringFromDate:[NSDate date]]];
    downRefreshGoingText = [NSString stringWithFormat:@"释放立即刷新\n最近更新：%@",[formatter stringFromDate:[NSDate date]]];
    
    [_progressView endLoadAnimation];
    
    double delayInSeconds = 0.5;
    __weak BaseTableView *weakself = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [weakself downReturnNormal];
        [UIView commitAnimations];
    });
}
#pragma mark 提示释放进入刷新
-(void)downGoingRefresh
{
    [downRefreshStateMessageLabel setText:downRefreshGoingText];
}
#pragma mark 恢复常态
-(void)downReturnNormal
{
    _isDownRefresh = NO;
    [self setContentInset:UIEdgeInsetsZero];
    [downRefreshAnimationImageView setImage:downRefreshImageStatic];
    [downRefreshStateMessageLabel setText:downRefreshNormalText];
}
#pragma mark 进入刷新状态
-(void)downBeginRefresh
{
    _isDownRefresh = YES;
    [_progressView beginLoadAnimation];
    [self setContentInset:UIEdgeInsetsMake(self.stateChangePoint, 0, 0, 0)];
    [downRefreshAnimationImageView setImage:downRefreshImageAnimation];
    [downRefreshStateMessageLabel setText:downRefreshInText];
}



#pragma mark 刷新结束
-(void)endUpRefresh
{
    
    [_progressView endLoadAnimation];
    double delayInSeconds = 0.5;
    __weak BaseTableView *weakself = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [weakself upReturnNormal];
        [UIView commitAnimations];
    });
}
#pragma mark 提示释放进入刷新
-(void)upGoingRefresh
{

    [upRefreshStateMessageLabel setText:upRefreshGoingText];
}
#pragma mark 恢复常态
-(void)upReturnNormal
{
    _isUpRefresh = NO;
    [self setContentInset:UIEdgeInsetsZero];
    [_loadView endLoading];
    [upRefreshStateMessageLabel setText:upRefreshNormalText];

}
#pragma mark 进入刷新状态
-(void)upBeginRefresh
{
    _isUpRefresh = YES;
    [_progressView beginLoadAnimation];
    [self setContentInset:UIEdgeInsetsMake(_progressView.frame.size.height, 0, self.stateChangePoint+_progressView.frame.size.height, 0)];
    [_loadView startLoading];
    [upRefreshStateMessageLabel setText:upRefreshInText];
    
}

-(void)setContentSize:(CGSize)contentSize
{
    [super setContentSize:contentSize];
    [self upUpdateFrame];
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self upUpdateFrame];
}
#pragma mark 更新上拉刷新显示视图的位置
-(void)upUpdateFrame
{
    // 内容的高度
    CGFloat contentHeight = self.contentSize.height;
    // 表格的高度
    CGFloat scrollHeight = self.frame.size.height;
    CGFloat y = MAX(contentHeight, scrollHeight);
    // 设置边框
    _upRefreshStateView.frame = CGRectMake(0, y,self.frame.size.width, 445.0f);
    _downRefreshStateView.frame = CGRectMake(0, -445.0f, self.frame.size.width, 445.0f);
}

#pragma mark ScrollView的代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [downRefreshAnimationImageView setAlpha:(-self.contentOffset.y)/self.stateChangePoint];
    
    CGFloat f = ((scrollView.contentSize.height-scrollView.frame.size.height)>0?(scrollView.contentSize.height-scrollView.frame.size.height):0)+self.stateChangePoint;

    if ((_isDownRefresh&&_needDownRefresh)||(_isUpRefresh&&_needUpRefresh))
    {
        return;
    }
    else if(scrollView.contentOffset.y<0&&scrollView.contentOffset.y>-self.stateChangePoint)
    {
        [self downReturnNormal];
    }
    else if(scrollView.contentOffset.y<0&&scrollView.contentOffset.y<=-self.stateChangePoint&&_needDownRefresh)
    {
        [self downGoingRefresh];
    }
    else if (scrollView.contentOffset.y>(scrollView.contentSize.height-scrollView.frame.size.height)&&scrollView.contentOffset.y<f)
    {
        [self upReturnNormal];
    }
    else if (scrollView.contentOffset.y>(scrollView.contentSize.height-scrollView.frame.size.height)&&scrollView.contentOffset.y>=f&&_needUpRefresh)
    {
        [self upGoingRefresh];
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat f = ((scrollView.contentSize.height-scrollView.frame.size.height)>0?(scrollView.contentSize.height-scrollView.frame.size.height):0)+self.stateChangePoint;
    if ((_isDownRefresh&&_needDownRefresh)||(_isUpRefresh&&_needUpRefresh))
    {
        return;
    }
    if (scrollView.contentOffset.y<=-self.stateChangePoint&&_needDownRefresh)
    {
        [self downBeginRefresh];
    }
    else if (scrollView.contentOffset.y>=f&&_needUpRefresh)
    {
        [self upBeginRefresh];
    }
}
-(BOOL)needDownRefreshAfterEndDragging
{
    if ((_isDownRefresh&&_needDownRefresh)||(_isUpRefresh&&_needUpRefresh))
    {
        return NO;
    }
    if (self.contentOffset.y<=-self.stateChangePoint&&_needDownRefresh)
    {
        return YES;
    }
    return NO;
}
-(BOOL)needUpRefreshAfterEndDragging
{
    CGFloat f = ((self.contentSize.height-self.frame.size.height)>0?(self.contentSize.height-self.frame.size.height):0)+self.stateChangePoint;
    if ((_isDownRefresh&&_needDownRefresh)||(_isUpRefresh&&_needUpRefresh))
    {
        return NO;
    }
    if (self.contentOffset.y>=f&&_needUpRefresh)
    {
        return YES;
    }
    return NO;
}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    id page = self;
    for (int i=0; i<100; i++)
    {
        if ([page isKindOfClass:[UIViewController class]])
        {
            return page;
        }
        page = [page nextResponder];
    }
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)downRefreshRequest:(void (^)(id))block
{
    [self downBeginRefresh];
    
    
    
    typeof(self) __weak weakself = self;
    block(weakself);
    
}
-(void)upRefreshRequest:(void (^)(id))block
{
    [self upBeginRefresh];
    
    
    
    typeof(self) __weak weakself = self;
    block(weakself);
}
@end
