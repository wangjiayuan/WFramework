//
//  NewMessageView.h
//  我的QQ
//
//  Created by wjymac on 15-1-25.
//  Copyright (c) 2015年 wjymac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorsProgress.h"
#import "CRLoadView.h"


@interface BaseTableView : UITableView
<UITableViewDelegate>
{
    BOOL _isDownRefresh;
    BOOL _isUpRefresh;
    BOOL _needDownRefresh;
    BOOL _needUpRefresh;
}

@property(nonatomic,strong,readonly)UIImageView *downRefreshStateView;
@property(nonatomic,strong,readonly)UIImageView *upRefreshStateView;
@property(nonatomic,strong,readonly)ColorsProgress *progressView;
@property(nonatomic,strong,readonly)CRLoadView *loadView;
@property(nonatomic,assign)CGFloat stateChangePoint;

-(void)downRefreshRequest:(void(^)(id tb))block;
-(void)upRefreshRequest:(void(^)(id tb))block;
-(void)setNeedDownRefresh:(BOOL)need;
-(void)setNeedUpRefresh:(BOOL)need;
-(void)endDownRefresh;
-(void)endUpRefresh;
//进入刷新状态
-(void)downBeginRefresh;
//进入刷新状态
-(void)upBeginRefresh;
- (UIViewController *)getCurrentVC;
#pragma mark 是否需要响应刷新
-(BOOL)needDownRefreshAfterEndDragging;
-(BOOL)needUpRefreshAfterEndDragging;
#pragma mark ScrollView的代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView;
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;
@end
