//
//  ActivityListElementCell.m
//  dahuozu
//
//  Created by apple on 15/12/14.
//  Copyright © 2015年 dahuozu. All rights reserved.
//

#import "ActivityListElementCell.h"

@implementation ActivityListElementCell
{
    UIImageView *headImageView;
    UIImageView *sexTypeImageView;
    UILabel *realyNameLabel;
    UILabel *fromAddressLabel;
    UILabel *toAddressLabel;
    UILabel *dateLabel;
    UILabel *timeLabel;
    UILabel *commentNumLabel;
    UILabel *detailAddressLabel;
    UILabel *nameLabel;
    UILabel *descriptLabel;
    UILabel *personLabel;
    UILabel *jionTypeLabel;
    UILabel *activityTypeLabel;
    UILabel *watchNumLabel;
    UIImageView *backgroundView;
    UIImageView *imageView1;
    UIImageView *imageView2;
    UIImageView *imageView3;
    UIImageView *commentMark;
    
    ///标识
    UIImageView *dateMark;
    UIImageView *personNumMark;
    UIImageView *needRealNameMark;
    UIImageView *activityTypeMark;
    UIImageView *watchNumMark;
}
- (void)awakeFromNib
{
    // Initialization code
}

-(instancetype)initWithImage:(BOOL)haveImage reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        if (haveImage)
        {
            [self setUpHaveImageContent];
        }
        else
        {
            [self setUpNoImageContent];
        }
        
    }
    return self;
}
+(void)initialize
{
    [super initialize];
    ActivityListElementCell *cell1 = [[ActivityListElementCell alloc]initWithImage:NO reuseIdentifier:[CellHeigthManager reuseIdentifierForClass:[self class] type:0]];
    [CellHeigthManager manageClass:[self class] type:0 withDefaultCell:cell1];
    ActivityListElementCell *cell2 = [[ActivityListElementCell alloc]initWithImage:YES reuseIdentifier:[CellHeigthManager reuseIdentifierForClass:[self class] type:1]];
    [CellHeigthManager manageClass:[self class] type:1 withDefaultCell:cell2];
}
-(UILabel*)labelForFont:(UIFont*)font
{
    UILabel *label = [UILabel new];
    [label setBackgroundColor:ColorSystem(clearColor)];
    [label setTextColor:ColorFromInt16(0x2f2f2f)];
    [label setFont:font];
    [label setText:@""];
    
    return label;
}
///有图片的布局
-(void)setUpHaveImageContent
{
    //背景图片
    backgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [backgroundView setUserInteractionEnabled:YES];
    //头像
    headImageView = [UIImageView new];
    [backgroundView addSubview:headImageView];
    //发起者是否实名
    realyNameLabel = [self labelForFont:FontSystem(10)];
    [realyNameLabel setTextColor:ColorSystem(whiteColor)];
    [realyNameLabel sizeToFit];
    [backgroundView addSubview:realyNameLabel];
    //发起者性别
    sexTypeImageView = [UIImageView new];
    [sexTypeImageView setContentMode:UIViewContentModeScaleAspectFit];
    [backgroundView addSubview:sexTypeImageView];
    //出发地点
    fromAddressLabel = [self labelForFont:FontSystem(12.5)];
    [fromAddressLabel sizeToFit];
    [backgroundView addSubview:fromAddressLabel];
    //地点往返标识
    UIImageView *returnGoMark = [UIImageView new];
    [returnGoMark setImage:[UIImage imageNamed:@"组-1-拷贝"]];
    [returnGoMark setContentMode:UIViewContentModeScaleAspectFit];
    [backgroundView addSubview:returnGoMark];
    //目的地
    toAddressLabel = [self labelForFont:FontSystem(12.5)];
    [toAddressLabel sizeToFit];
    [backgroundView addSubview:toAddressLabel];
    //日期标识
    dateMark = [UIImageView new];
    [dateMark setImage:[UIImage imageNamed:@"15"]];
    [backgroundView addSubview:dateMark];
    //日期值
    dateLabel = [self labelForFont:FontSystem(10)];
    [dateLabel sizeToFit];
    [backgroundView addSubview:dateLabel];
    //剩余时间
    timeLabel = [self labelForFont:FontSystem(10)];
    [timeLabel sizeToFit];
    [backgroundView addSubview:timeLabel];
    //评论标识
    commentMark = [UIImageView new];
    [commentMark setImage:[UIImage imageNamed:@"11"]];
    [backgroundView addSubview:commentMark];
    //评论人数
    commentNumLabel = [self labelForFont:FontSystem(10)];
    [commentNumLabel setText:@""];
    [commentNumLabel setTextAlignment:1];
    [commentNumLabel setAdjustsFontSizeToFitWidth:YES];
    [commentNumLabel setTextColor:ColorSystem(whiteColor)];
    [commentNumLabel setFrame:CGRectMake(3.5f, 2.5f, 18.0f, 12.0f)];
    
    [commentMark addSubview:commentNumLabel];
    ///详细地点
    detailAddressLabel = [self labelForFont:FontSystem(11.5)];
    [detailAddressLabel sizeToFit];
    [detailAddressLabel setNumberOfLines:0];
    [backgroundView addSubview:detailAddressLabel];
    //活动描述
    descriptLabel = [self labelForFont:FontSystem(14)];
    [descriptLabel sizeToFit];
    [descriptLabel setTextColor:ColorFromInt16(0x979797)];
    [descriptLabel setNumberOfLines:0];
    [backgroundView addSubview:descriptLabel];
    //图片
    imageView1 = [UIImageView new];
    [imageView1 setContentMode:UIViewContentModeScaleAspectFill];
    [imageView1 setClipsToBounds:YES];
    [backgroundView addSubview:imageView1];
    imageView2 = [UIImageView new];
    [imageView2 setContentMode:UIViewContentModeScaleAspectFill];
    [imageView2 setClipsToBounds:YES];
    [backgroundView addSubview:imageView2];
    imageView3 = [UIImageView new];
    [imageView3 setContentMode:UIViewContentModeScaleAspectFill];
    [imageView3 setClipsToBounds:YES];
    [backgroundView addSubview:imageView3];
    //昵称
    nameLabel = [self labelForFont:FontSystem(12)];
    [nameLabel setTextAlignment:1];
    [backgroundView addSubview:nameLabel];

    //参加人数背景
    UIView *personNumView = [UIView new];
    //参加人数标识
    personNumMark = [UIImageView new];
    [personNumMark setContentMode:UIViewContentModeScaleAspectFit];
    [personNumMark setImage:[UIImage imageNamed:@"16"]];
    [personNumView addSubview:personNumMark];
    //参加人数值
    personLabel = [self labelForFont:FontSystem(10)];
    [personLabel setAdjustsFontSizeToFitWidth:YES];
    [personNumView addSubview:personLabel];
    [backgroundView addSubview:personNumView];
    //是否实名参加背景
    UIView *needRealNameView = [UIView new];
    //是否实名参加标识
    needRealNameMark = [UIImageView new];
    [needRealNameMark setContentMode:UIViewContentModeScaleAspectFit];
    [needRealNameMark setImage:[UIImage imageNamed:@"3"]];
    [needRealNameView addSubview:needRealNameMark];
    //是否实名参加值
    jionTypeLabel = [self labelForFont:FontSystem(10)];
    [jionTypeLabel setAdjustsFontSizeToFitWidth:YES];
    [needRealNameView addSubview:jionTypeLabel];
    [backgroundView addSubview:needRealNameView];
    //活动类型背景
    UIView *activityTypeView = [UIView new];
    //活动类型标识
    activityTypeMark = [UIImageView new];
    [activityTypeMark setContentMode:UIViewContentModeScaleAspectFit];
    [activityTypeMark setImage:[UIImage imageNamed:@"6"]];
    [activityTypeView addSubview:activityTypeMark];
    //活动类型值
    activityTypeLabel = [self labelForFont:FontSystem(10)];
    [activityTypeLabel setAdjustsFontSizeToFitWidth:YES];
    [activityTypeView addSubview:activityTypeLabel];
    [backgroundView addSubview:activityTypeView];
    //浏览人数背景
    UIView *watchNumView = [UIView new];
    //浏览人数标识
    watchNumMark = [UIImageView new];
    [watchNumMark setContentMode:UIViewContentModeScaleAspectFit];
    [watchNumMark setImage:[UIImage imageNamed:@"7"]];
    [watchNumView addSubview:watchNumMark];
    //浏览人数值
    watchNumLabel = [self labelForFont:FontSystem(10)];
    [watchNumLabel setAdjustsFontSizeToFitWidth:YES];
    [watchNumView addSubview:watchNumLabel];
    [backgroundView addSubview:watchNumView];
    
    [self addSubview:backgroundView];
    
    ///约束
    [backgroundView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:5.0f];
    [backgroundView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-5.0f];
    [backgroundView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:5.0f];
    
    [headImageView setFrame:CGRectMake(5.0f, 30.0f, 70.0f, 70.0f)];
    [headImageView setClipsToBounds:YES];
    [headImageView.layer setCornerRadius:35.0f];
    
    [realyNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:headImageView];
    [realyNameLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:headImageView];
    
    [sexTypeImageView autoSetDimensionsToSize:CGSizeMake(20.0f, 20.0f)];
    [sexTypeImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:headImageView];
    [sexTypeImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:headImageView];
    
    [fromAddressLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:headImageView];
    [fromAddressLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:headImageView withOffset:5.0f];
    [fromAddressLabel autoSetDimension:ALDimensionWidth toSize:80.0f relation:NSLayoutRelationLessThanOrEqual];
    
    
    [returnGoMark autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:fromAddressLabel withOffset:2.5f];
    [returnGoMark autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:fromAddressLabel withOffset:2.5f];
    [returnGoMark autoSetDimensionsToSize:CGSizeMake(20.0f, 10.0f)];
    
    [toAddressLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:fromAddressLabel];
    [toAddressLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:returnGoMark withOffset:2.5f];
    [toAddressLabel autoSetDimension:ALDimensionWidth toSize:80.0f relation:NSLayoutRelationLessThanOrEqual];
    
    
    [commentMark autoSetDimensionsToSize:CGSizeMake(30.0f, 22.0f)];
    [commentMark autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:backgroundView withOffset:5.0f];
    [commentMark autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:backgroundView withOffset:-5.0f];
    
    
    [timeLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:backgroundView withOffset:-5.0f];
    [timeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:backgroundView withOffset:32.5f];
    [timeLabel autoSetDimension:ALDimensionHeight toSize:15.0f];
    
    [dateLabel autoSetDimension:ALDimensionHeight toSize:15.0f];
    [dateLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:commentMark];
    [dateLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:commentMark withOffset:-25.0f];
    
    [dateMark autoSetDimensionsToSize:CGSizeMake(10.0f, 10.0f)];
    [dateMark autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:dateLabel withOffset:-2.5f];
    [dateMark autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:dateLabel withOffset:2.5f];
    
    [detailAddressLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:fromAddressLabel];
    [detailAddressLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:returnGoMark withOffset:7.5f];
    [detailAddressLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:backgroundView withOffset:-5.0f];
    
    [descriptLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:detailAddressLabel withOffset:-5.0f];
    [descriptLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:detailAddressLabel];
    [descriptLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:detailAddressLabel withOffset:10.0f];
    [descriptLabel autoSetDimension:ALDimensionHeight toSize:60.0f relation:NSLayoutRelationLessThanOrEqual];
    
    [imageView1 autoSetDimensionsToSize:CGSizeMake((SMax_Width-140.0f)/3.0f, (SMax_Width-140.0f)/3.0f)];
    [imageView1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:descriptLabel];
    [imageView1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:descriptLabel withOffset:5.0f];
    
    [imageView2 autoSetDimensionsToSize:CGSizeMake((SMax_Width-140.0f)/3.0f, (SMax_Width-140.0f)/3.0f)];
    [imageView2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView1 withOffset:10.0f];
    [imageView2 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:imageView1];
    
    [imageView3 autoSetDimensionsToSize:CGSizeMake((SMax_Width-140.0f)/3.0f, (SMax_Width-140.0f)/3.0f)];
    [imageView3 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView2 withOffset:10.0f];
    [imageView3 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:imageView2];
    
    [nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:headImageView];
    [nameLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:headImageView];
    [nameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:headImageView withOffset:5.0f];
    [nameLabel autoSetDimension:ALDimensionHeight toSize:20.0f];
    
    NSArray *views = @[personNumView, needRealNameView, activityTypeView,watchNumView];
    
    [views autoMatchViewsDimension:ALDimensionWidth];
    
    [[views firstObject] autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:backgroundView withOffset:-5.0f relation:NSLayoutRelationGreaterThanOrEqual];
    
    [views autoSetViewsDimension:ALDimensionHeight toSize:20.0f];
    
    
    [[views firstObject] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5.0f];//2.5f];
    
    UIView *previousView = nil;
    for (UIView *view in views)
    {
        if (previousView)
        {
            [view autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:previousView];
            [view autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:previousView];
        }
        previousView = view;
    }
    [[views lastObject] autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];//2.5f];
    
    [backgroundView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:imageView1 withOffset:25.0f relation:NSLayoutRelationGreaterThanOrEqual];
    [backgroundView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:nameLabel withOffset:25.0f relation:NSLayoutRelationGreaterThanOrEqual];
    
    
    [personNumMark autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:personNumView withOffset:2.5f];
    [personNumMark autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:personNumView withOffset:2.5f];
    [personNumMark autoSetDimensionsToSize:CGSizeMake(15.0f, 15.0f)];
    [personLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:personNumMark withOffset:2.5f];
    [personLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:personNumMark];
    [personLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:personNumView];
    [personLabel autoSetDimension:ALDimensionHeight toSize:15.0f];
    
    
    [needRealNameMark autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:needRealNameView withOffset:2.5f];
    [needRealNameMark autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:needRealNameView withOffset:2.5f];
    [needRealNameMark autoSetDimensionsToSize:CGSizeMake(15.0f, 15.0f)];
    [jionTypeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:needRealNameMark withOffset:2.5f];
    [jionTypeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:needRealNameMark];
    [jionTypeLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:needRealNameView];
    [jionTypeLabel autoSetDimension:ALDimensionHeight toSize:15.0f];
    
    
    [activityTypeMark autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:activityTypeView withOffset:2.5f];
    [activityTypeMark autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:activityTypeView withOffset:2.5f];
    [activityTypeMark autoSetDimensionsToSize:CGSizeMake(15.0f, 15.0f)];
    [activityTypeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:activityTypeMark withOffset:2.5f];
    [activityTypeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:activityTypeMark];
    [activityTypeLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:activityTypeView];
    [activityTypeLabel autoSetDimension:ALDimensionHeight toSize:15.0f];
    
    
    
    [watchNumMark autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:watchNumView withOffset:2.5f];
    [watchNumMark autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:watchNumView withOffset:2.5f];
    [watchNumMark autoSetDimensionsToSize:CGSizeMake(15.0f, 15.0f)];
    [watchNumLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:watchNumMark withOffset:2.5f];
    [watchNumLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:watchNumMark];
    [watchNumLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:watchNumView];
    [watchNumLabel autoSetDimension:ALDimensionHeight toSize:15.0f];
    
    
    
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"activitybg"]]];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}
///没有图片的布局
-(void)setUpNoImageContent
{
    //背景图片
    backgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [backgroundView setUserInteractionEnabled:YES];
    //头像
    headImageView = [UIImageView new];
    [backgroundView addSubview:headImageView];
    //发起者是否实名
    realyNameLabel = [self labelForFont:FontSystem(10)];
    [realyNameLabel setTextColor:ColorSystem(whiteColor)];
    [realyNameLabel sizeToFit];
    [backgroundView addSubview:realyNameLabel];
    //发起者性别
    sexTypeImageView = [UIImageView new];
    [sexTypeImageView setContentMode:UIViewContentModeScaleAspectFit];
    [backgroundView addSubview:sexTypeImageView];
    //出发地点
    fromAddressLabel = [self labelForFont:FontSystem(13)];
    [fromAddressLabel sizeToFit];
    [backgroundView addSubview:fromAddressLabel];
    //地点往返标识
    UIImageView *returnGoMark = [UIImageView new];
    [returnGoMark setImage:[UIImage imageNamed:@"组-1-拷贝"]];
    [returnGoMark setContentMode:UIViewContentModeScaleAspectFit];
    [backgroundView addSubview:returnGoMark];
    //目的地
    toAddressLabel = [self labelForFont:FontSystem(13)];
    [toAddressLabel sizeToFit];
    [backgroundView addSubview:toAddressLabel];
    //日期标识
    dateMark = [UIImageView new];
    [dateMark setImage:[UIImage imageNamed:@"15"]];
    [backgroundView addSubview:dateMark];
    //日期值
    dateLabel = [self labelForFont:FontSystem(10)];
    [dateLabel sizeToFit];
    [backgroundView addSubview:dateLabel];
    //剩余时间
    timeLabel = [self labelForFont:FontSystem(10)];
    [timeLabel sizeToFit];
    [backgroundView addSubview:timeLabel];
    //评论标识
    commentMark = [UIImageView new];
    [commentMark setImage:[UIImage imageNamed:@"11"]];
    [backgroundView addSubview:commentMark];
    //评论人数
    commentNumLabel = [self labelForFont:FontSystem(10)];
    [commentNumLabel setText:@""];
    [commentNumLabel setTextAlignment:1];
    [commentNumLabel setAdjustsFontSizeToFitWidth:YES];
    [commentNumLabel setTextColor:ColorSystem(whiteColor)];
    [commentNumLabel setFrame:CGRectMake(3.5f, 2.5f, 18.0f, 12.0f)];

    [commentMark addSubview:commentNumLabel];
    ///详细地点
    detailAddressLabel = [self labelForFont:FontSystem(12)];
    [detailAddressLabel sizeToFit];
    [detailAddressLabel setNumberOfLines:0];
    [backgroundView addSubview:detailAddressLabel];
    //活动描述
    descriptLabel = [self labelForFont:FontSystem(14)];
    [descriptLabel sizeToFit];
    [descriptLabel setTextColor:ColorFromInt16(0x979797)];
    [descriptLabel setNumberOfLines:0];
    [backgroundView addSubview:descriptLabel];
    //昵称
    nameLabel = [self labelForFont:FontSystem(12)];
    [nameLabel setTextAlignment:1];
    [backgroundView addSubview:nameLabel];

    //参加人数背景
    UIView *personNumView = [UIView new];
    //参加人数标识
    personNumMark = [UIImageView new];
    [personNumMark setContentMode:UIViewContentModeScaleAspectFit];
    [personNumMark setImage:[UIImage imageNamed:@"16"]];
    [personNumView addSubview:personNumMark];
    //参加人数值
    personLabel = [self labelForFont:FontSystem(10)];
    [personLabel setAdjustsFontSizeToFitWidth:YES];
    [personNumView addSubview:personLabel];
    [backgroundView addSubview:personNumView];
    //是否实名参加背景
    UIView *needRealNameView = [UIView new];
    //是否实名参加标识
    needRealNameMark = [UIImageView new];
    [needRealNameMark setContentMode:UIViewContentModeScaleAspectFit];
    [needRealNameMark setImage:[UIImage imageNamed:@"3"]];
    [needRealNameView addSubview:needRealNameMark];
    //是否实名参加值
    jionTypeLabel = [self labelForFont:FontSystem(10)];
    [jionTypeLabel setAdjustsFontSizeToFitWidth:YES];
    [needRealNameView addSubview:jionTypeLabel];
    [backgroundView addSubview:needRealNameView];
    //活动类型背景
    UIView *activityTypeView = [UIView new];
    //活动类型标识
    activityTypeMark = [UIImageView new];
    [activityTypeMark setContentMode:UIViewContentModeScaleAspectFit];
    [activityTypeMark setImage:[UIImage imageNamed:@"6"]];
    [activityTypeView addSubview:activityTypeMark];
    //活动类型值
    activityTypeLabel = [self labelForFont:FontSystem(10)];
    [activityTypeLabel setAdjustsFontSizeToFitWidth:YES];
    [activityTypeView addSubview:activityTypeLabel];
    [backgroundView addSubview:activityTypeView];
    //浏览人数背景
    UIView *watchNumView = [UIView new];
    //浏览人数标识
    watchNumMark = [UIImageView new];
    [watchNumMark setContentMode:UIViewContentModeScaleAspectFit];
    [watchNumMark setImage:[UIImage imageNamed:@"7"]];
    [watchNumView addSubview:watchNumMark];
    //浏览人数值
    watchNumLabel = [self labelForFont:FontSystem(10)];
    [watchNumLabel setAdjustsFontSizeToFitWidth:YES];
    [watchNumView addSubview:watchNumLabel];
    [backgroundView addSubview:watchNumView];
    
    [self addSubview:backgroundView];
    
    ///约束
    [backgroundView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:5.0f];
    [backgroundView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-5.0f];
    [backgroundView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:5.0f];
    
    [headImageView setFrame:CGRectMake(5.0f, 30.0f, 70.0f, 70.0f)];
    [headImageView setClipsToBounds:YES];
    [headImageView.layer setCornerRadius:35.0f];
    
    [realyNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:headImageView];
    [realyNameLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:headImageView];
    
    [sexTypeImageView autoSetDimensionsToSize:CGSizeMake(20.0f, 20.0f)];
    [sexTypeImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:headImageView];
    [sexTypeImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:headImageView];
    
    [fromAddressLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:headImageView];
    [fromAddressLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:headImageView withOffset:5.0f];
    [fromAddressLabel autoSetDimension:ALDimensionWidth toSize:80.0f relation:NSLayoutRelationLessThanOrEqual];
    
    
    [returnGoMark autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:fromAddressLabel withOffset:2.5f];
    [returnGoMark autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:fromAddressLabel withOffset:2.5f];
    [returnGoMark autoSetDimensionsToSize:CGSizeMake(20.0f, 10.0f)];
    
    [toAddressLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:fromAddressLabel];
    [toAddressLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:returnGoMark withOffset:2.5f];
    [toAddressLabel autoSetDimension:ALDimensionWidth toSize:80.0f relation:NSLayoutRelationLessThanOrEqual];
    
    
    [commentMark autoSetDimensionsToSize:CGSizeMake(30.0f, 22.0f)];
    [commentMark autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:backgroundView withOffset:5.0f];
    [commentMark autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:backgroundView withOffset:-5.0f];
    
    
    [timeLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:backgroundView withOffset:-5.0f];
    [timeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:backgroundView withOffset:32.5f];
    [timeLabel autoSetDimension:ALDimensionHeight toSize:15.0f];
    
    [dateLabel autoSetDimension:ALDimensionHeight toSize:15.0f];
    [dateLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:commentMark];
    [dateLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:commentMark withOffset:-25.0f];
    
    [dateMark autoSetDimensionsToSize:CGSizeMake(10.0f, 10.0f)];
    [dateMark autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:dateLabel withOffset:-5.0f];
    [dateMark autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:dateLabel withOffset:2.5f];
    
    [detailAddressLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:fromAddressLabel];
    [detailAddressLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:returnGoMark withOffset:7.5f];
    [detailAddressLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:backgroundView withOffset:-5.0f];
    
    [descriptLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:detailAddressLabel withOffset:-5.0f];
    [descriptLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:detailAddressLabel];
    [descriptLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:detailAddressLabel withOffset:10.0f];
    [descriptLabel autoSetDimension:ALDimensionHeight toSize:60.0f relation:NSLayoutRelationLessThanOrEqual];
    
    [nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:headImageView];
    [nameLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:headImageView];
    [nameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:headImageView withOffset:5.0f];
    [nameLabel autoSetDimension:ALDimensionHeight toSize:20.0f];
    
    NSArray *views = @[personNumView, needRealNameView, activityTypeView,watchNumView];//@[distantView, personNumView, needRealNameView, activityTypeView,watchNumView,collectionNumView];
    
    [views autoMatchViewsDimension:ALDimensionWidth];
    
    [[views firstObject] autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:backgroundView withOffset:-5.0f relation:NSLayoutRelationGreaterThanOrEqual];
    
    [views autoSetViewsDimension:ALDimensionHeight toSize:20.0f];
    
    
    [[views firstObject] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5.0f];//2.5f];
    
    UIView *previousView = nil;
    for (UIView *view in views)
    {
        if (previousView)
        {
            [view autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:previousView];
            [view autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:previousView];
        }
        previousView = view;
    }
    [[views lastObject] autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];//2.5f];
    
    [backgroundView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:descriptLabel withOffset:25.0f relation:NSLayoutRelationGreaterThanOrEqual];
    [backgroundView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:nameLabel withOffset:25.0f relation:NSLayoutRelationGreaterThanOrEqual];
    
    
    [personNumMark autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:personNumView withOffset:2.5f];
    [personNumMark autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:personNumView withOffset:2.5f];
    [personNumMark autoSetDimensionsToSize:CGSizeMake(15.0f, 15.0f)];
    [personLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:personNumMark withOffset:2.5f];
    [personLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:personNumMark];
    [personLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:personNumView];
    [personLabel autoSetDimension:ALDimensionHeight toSize:15.0f];
    
    
    [needRealNameMark autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:needRealNameView withOffset:2.5f];
    [needRealNameMark autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:needRealNameView withOffset:2.5f];
    [needRealNameMark autoSetDimensionsToSize:CGSizeMake(15.0f, 15.0f)];
    [jionTypeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:needRealNameMark withOffset:2.5f];
    [jionTypeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:needRealNameMark];
    [jionTypeLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:needRealNameView];
    [jionTypeLabel autoSetDimension:ALDimensionHeight toSize:15.0f];
    
    
    [activityTypeMark autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:activityTypeView withOffset:2.5f];
    [activityTypeMark autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:activityTypeView withOffset:2.5f];
    [activityTypeMark autoSetDimensionsToSize:CGSizeMake(15.0f, 15.0f)];
    [activityTypeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:activityTypeMark withOffset:2.5f];
    [activityTypeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:activityTypeMark];
    [activityTypeLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:activityTypeView];
    [activityTypeLabel autoSetDimension:ALDimensionHeight toSize:15.0f];
    
    
    
    [watchNumMark autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:watchNumView withOffset:2.5f];
    [watchNumMark autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:watchNumView withOffset:2.5f];
    [watchNumMark autoSetDimensionsToSize:CGSizeMake(15.0f, 15.0f)];
    [watchNumLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:watchNumMark withOffset:2.5f];
    [watchNumLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:watchNumMark];
    [watchNumLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:watchNumView];
    [watchNumLabel autoSetDimension:ALDimensionHeight toSize:15.0f];
    
    
    
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"activitybg"]]];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setData:(ActivitySimpleModel*)model
{
    NSString *head_path = [NSString pargramText:model.head_pic];
    
    [imageView1 setImage:nil];
    [imageView2 setImage:nil];
    [imageView3 setImage:nil];
    NSInteger count = [model.imageList count];
    count = MIN(count, 3);
    for (NSInteger i=0; i<count; i++)
    {
        NSString *image_pic = [[model.imageList objectAtIndex:i] valueForKey:@"image_pic"];
        switch (i)
        {
            case 0:
            {
                [imageView1 setImageWithURL:[NSURL URLWithString:image_pic] placeholderImage:[UIImage imageNamed:@"grayBG.png"]];
            }
                break;
            case 1:
            {
                [imageView2 setImageWithURL:[NSURL URLWithString:image_pic] placeholderImage:[UIImage imageNamed:@"grayBG.png"]];
            }
                break;
            case 2:
            {
                [imageView3 setImageWithURL:[NSURL URLWithString:image_pic] placeholderImage:[UIImage imageNamed:@"grayBG.png"]];
            }
                break;
            default:
                break;
        }
    }
    
    NSInteger status = model.status;//用户是否已认证，1未认证0已认证2认证失败
    if (status==0)
    {
        [realyNameLabel setText:@"实名"];
        [realyNameLabel setBackgroundColor:ColorSystem(cyanColor)];
    }
    else
    {
        [realyNameLabel setText:@"实名"];
        [realyNameLabel setBackgroundColor:ColorSystem(lightGrayColor)];
    }
    
    if (model.sex == 0)
    {
        [sexTypeImageView setImage:[UIImage imageNamed:@"sex_man"]];
        [headImageView setImageWithURL:[NSURL URLWithString:head_path] placeholderImage:[UIImage imageNamed:@"B"]];
    }
    else
    {
        [sexTypeImageView setImage:[UIImage imageNamed:@"sex_woman.png"]];
        [headImageView setImageWithURL:[NSURL URLWithString:head_path] placeholderImage:[UIImage imageNamed:@"G"]];
    }
    NSString *nick_name = [NSString pargramText:model.nick_name];
    [nameLabel setText:nick_name];
    NSString *chufa_city = [NSString pargramText:model.chufa_city];
    NSString *city = [NSString pargramText:model.city];
    [fromAddressLabel setText:chufa_city];
    [toAddressLabel setText:city];
    
    [dateLabel setText:model.b_time];
    
    [timeLabel setTextColor:ColorSystem(blackColor)];
    NSDate *endDate = [NSDate dateWithString:model.end_time format:@"yyyy-MM-dd HH:mm"];
    NSDate *beginDate = [NSDate dateWithString:model.b_time format:@"yyyy-MM-dd HH:mm"];
    NSInteger timeLeft = [endDate daysFromNow];
    NSInteger timeGone = [beginDate daysFromNow];
    
    if (timeLeft>=0)
    {
        if(timeGone<=0)
        {
            NSMutableAttributedString *   attibuttionStr=[[NSMutableAttributedString alloc]initWithString:@"活动中"];
            NSRange range = NSMakeRange(0, 3);
            
            NSDictionary *textAttributes = @{NSForegroundColorAttributeName : [UIColor greenColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:12]};
            
            [attibuttionStr addAttributes:textAttributes range:range];
            
            timeLabel.attributedText =attibuttionStr;
        }
        else
        {
            NSMutableAttributedString *   attibuttionStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"还有%li天",(long)timeGone]];
            NSRange range=NSMakeRange(2, attibuttionStr.length-3);
            
            NSDictionary *textAttributes = @{NSForegroundColorAttributeName : [UIColor redColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:12]};
            
            [attibuttionStr addAttributes:textAttributes range:range];
            
            timeLabel.attributedText =attibuttionStr;
        }
    }
    NSString *address_describe = [NSString pargramText:model.address_describe];
    [detailAddressLabel setText:address_describe];

    int canjia_count = model.canjia_count;
    if (model.people_number==-1)
    {
        personLabel.text=[NSString stringWithFormat:@"%i",canjia_count+1];
    }
    else
    {
        personLabel.text=[NSString stringWithFormat:@"%i/%i",canjia_count+1,model.people_number+1];
    }
    if (model.renzheng==0)
    {
        [jionTypeLabel setText:@"需实名"];
    }
    else
    {
        [jionTypeLabel setText:@"无需实名"];
    }
    NSString *type_title = [NSString pargramText:model.type_title];
    [activityTypeLabel setText:type_title];
    
    NSString *read_num = [NSString stringWithFormat:@"%i人看",model.read_num];
    [watchNumLabel setText:read_num];

    NSString *activity_content = [NSString pargramText:model.activity_content];

    [descriptLabel setText:activity_content];
    
    if (model.pinglun>0)
    {
        [commentNumLabel setText:[NSString stringWithFormat:@"%li",(long)model.pinglun]];
    }
    else
    {
        [commentNumLabel setText:@""];
    }
    [self setBackgroundImage:model];
}

-(void)setBackgroundImage:(ActivitySimpleModel*)model
{
    
    if (model.renzheng==0)
    {
        [needRealNameMark setImage:[UIImage imageNamed:@"3"]];
    }
    else
    {
        [needRealNameMark setImage:[UIImage imageNamed:@"4"]];
    }
//    func_type 1 可以参加，2自己发布的 3，已参加
    if (model.func_type==1)
    {
        static UIImage* image1;
        if (!image1)
        {
             image1 = [[UIImage imageNamed:@"2222-拷贝111"] resizableImageWithCapInsets:UIEdgeInsetsMake(36.0f, 50.0f, 15.0f, 15.0f) resizingMode:UIImageResizingModeTile];
        }
        [backgroundView setImage:image1];
    }
    else
    {
        static UIImage* image2;
        if (!image2)
        {
            image2 = [[UIImage imageNamed:@"2222-拷贝222"] resizableImageWithCapInsets:UIEdgeInsetsMake(36.0f, 50.0f, 15.0f, 15.0f) resizingMode:UIImageResizingModeTile];
        }
        [backgroundView setImage:image2];
    }
    
    NSDate *endDate = [NSDate dateWithString:model.end_time format:@"yyyy-MM-dd HH:mm"];
    NSInteger timeLeft = [endDate daysFromNow];
    
    if (timeLeft<=1)
    {
        [dateMark setImage:[UIImage imageNamed:@"15"]];
    }
    else
    {
        [dateMark setImage:[UIImage imageNamed:@"17"]];
    }

    if (model.people_number==-1)
    {
        [personNumMark setImage:[UIImage imageNamed:@"2"]];
    }
    else if(model.canjia_count>=model.people_number)
    {
        [personNumMark setImage:[UIImage imageNamed:@"16"]];
    }
    else
    {
        [personNumMark setImage:[UIImage imageNamed:@"2"]];
    }
    
        
        [activityTypeMark setImage:[UIImage imageNamed:@"6"]];
        [watchNumMark setImage:[UIImage imageNamed:@"7"]];

    if (model.pinglun>0)
    {
        [commentMark setImage:[UIImage imageNamed:@"12"]];
    }
    else
    {
        [commentMark setImage:[UIImage imageNamed:@"11"]];
    }

}
@end
