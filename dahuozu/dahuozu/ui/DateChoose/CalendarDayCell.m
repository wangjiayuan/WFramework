//
//  CalendarDayCell.m
//  tttttt
//
//  Created by 张凡 on 14-8-20.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CalendarDayCell.h"

@implementation CalendarDayCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initView];
    }
    return self;
}

- (void)initView{
    
    //选中时显示的图片
    imgview = [[UIImageView alloc]initWithFrame:CGRectMake((self.bounds.size.width-self.bounds.size.height+30)/2.0f, 15, self.bounds.size.height-30, self.bounds.size.height-30)];
    [imgview setClipsToBounds:YES];
    [imgview.layer setCornerRadius:MIN(imgview.frame.size.width, imgview.frame.size.height)/2.0f];
    [imgview setBackgroundColor:COLOR_THEME];
    [self addSubview:imgview];
    
    //日期
    day_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, self.bounds.size.width, self.bounds.size.height-30)];
    day_lab.textAlignment = NSTextAlignmentCenter;
    day_lab.font = [UIFont systemFontOfSize:14];
    [self addSubview:day_lab];

    //农历
    day_title = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-13, self.bounds.size.width, 13)];
    day_title.textColor = [UIColor lightGrayColor];
    day_title.font = [UIFont boldSystemFontOfSize:10];
    day_title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:day_title];
    

}


- (void)setModel:(CalendarDayModel *)model
{
    
    if(model.style==CellDayTypeEmpty)
    {
        [self hidden_YES];

        return;
    }
    else if (model.style==CellDayTypePast)
    {
        [self hidden_NO];
        if (model.holiday) {
            day_lab.text = model.holiday;
        }else{
            day_lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
        }
        
        day_lab.textColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0f];
        day_title.textColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0f];
        day_title.text = model.Chinese_calendar;


        return;
    }
    else if (model.style==CellDayTypeFutur)
    {
        [self hidden_NO];
        
        if (model.holiday) {
            day_lab.text = model.holiday;
            day_lab.textColor = [UIColor orangeColor];
        }else{
            day_lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
            day_lab.textColor = COLOR_THEME;
        }
        
        day_title.text = model.Chinese_calendar;
        day_title.textColor = [UIColor lightGrayColor];
        
        return;
    }
    else if(model.style==CellDayTypeWeek)
    {
        [self hidden_NO];
        
        if (model.holiday) {
            day_lab.text = model.holiday;
            day_lab.textColor = [UIColor orangeColor];
        }else{
            day_lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
            day_lab.textColor = COLOR_THEME1;
        }
        
        day_title.text = model.Chinese_calendar;
        day_title.textColor = [UIColor lightGrayColor];
        return;
    }
    else if(model.style==CellDayTypeClick)
    {
        [self hidden_NO];
        
        day_lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
        day_lab.textColor = [UIColor whiteColor];
        day_title.text = model.Chinese_calendar;
        day_title.textColor = [UIColor lightGrayColor];
        
        return;
    }



}

-(void)addClickDateType:(ClickDateType)type day:(NSInteger)day
{
    imgview.hidden  = NO;
    switch (type)
    {
        case ClickDateTypeBegin:
        {
            [imgview setBackgroundColor:COLOR_THEME];
            day_lab.text = [NSString stringWithFormat:@"%ld",(long)day];
            day_lab.textColor = [UIColor whiteColor];
            [day_title setTextColor:imgview.backgroundColor];
            [day_title setText:@"开始"];
        }
            break;
        case ClickDateTypeEnd:
        {
            [imgview setBackgroundColor:COLOR_THEME2];
            day_lab.text = [NSString stringWithFormat:@"%ld",(long)day];
            day_lab.textColor = [UIColor whiteColor];
            [day_title setTextColor:imgview.backgroundColor];
            [day_title setText:@"结束"];
        }
            break;
        case ClickDateTypeCurrent:
        {
            [imgview setBackgroundColor:COLOR_THEME1];
            day_lab.text = [NSString stringWithFormat:@"%ld",(long)day];
            day_lab.textColor = [UIColor whiteColor];
            [day_title setTextColor:imgview.backgroundColor];
            [day_title setText:@"当天"];
        }
            break;
        case ClickDateTypeIng:
        {
            [imgview setBackgroundColor:COLOR_THEME3];
            day_lab.text = [NSString stringWithFormat:@"%ld",(long)day];
            day_lab.textColor = [UIColor whiteColor];
            [day_title setTextColor:imgview.backgroundColor];
        }
            break;
        default:
            break;
    }
}

- (void)hidden_YES{
    
    day_lab.hidden = YES;
    day_title.hidden = YES;
    imgview.hidden = YES;
    
}


- (void)hidden_NO{
    
    day_lab.hidden = NO;
    day_title.hidden = NO;
    imgview.hidden = YES;
    
}


@end
