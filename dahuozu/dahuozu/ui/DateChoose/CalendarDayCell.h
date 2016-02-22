//
//  CalendarDayCell.h
//  tttttt
//
//  Created by 张凡 on 14-8-20.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>
#import "CalendarDayModel.h"

#define COLOR_THEME1 ([UIColor redColor])//大红色
#define COLOR_THEME ([UIColor colorWithRed:26/256.0  green:168/256.0 blue:186/256.0 alpha:1])
#define COLOR_THEME2 ([UIColor colorWithRed:186/256.0  green:26/256.0 blue:168/256.0 alpha:1])

#define COLOR_THEME3 ([UIColor colorWithRed:168/256.0  green:186/256.0 blue:26/256.0 alpha:1])

typedef NS_ENUM(NSInteger, ClickDateType)
{
    ClickDateTypeBegin = 0,   //出发日期
    ClickDateTypeEnd = 1,    //结束日期日期
    ClickDateTypeCurrent = 2,    //只在当天
    ClickDateTypeIng = 3,//活动日期
};

@interface CalendarDayCell : UICollectionViewCell
{
    UILabel *day_lab;//今天的日期或者是节日
    UILabel *day_title;//显示标签
    UIImageView *imgview;//选中时的图片
}

@property(nonatomic , strong)CalendarDayModel *model;

-(void)addClickDateType:(ClickDateType)type day:(NSInteger)day;

@end
