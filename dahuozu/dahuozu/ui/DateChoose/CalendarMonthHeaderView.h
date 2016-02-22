//
//  ETIMonthHeaderView.h
//  CalendarIOS7
//
//  Created by Jerome Morissard on 3/3/14.
//  Copyright (c) 2014 Jerome Morissard. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>

#define Head_COLOR_THEME1 ([UIColor redColor])//大红色
#define Head_COLOR_THEME ([UIColor colorWithRed:26/256.0  green:168/256.0 blue:186/256.0 alpha:1])//去哪儿绿
#define Head_COLOR_THEME2 ([UIColor colorWithRed:186/256.0  green:26/256.0 blue:168/256.0 alpha:1])//去哪儿绿

@interface CalendarMonthHeaderView : UICollectionReusableView

@property (weak, nonatomic) UILabel *masterLabel;

@end
