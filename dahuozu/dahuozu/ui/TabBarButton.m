//
//  TabBarButton.m
//  dahuozu
//
//  Created by apple on 16/1/20.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "TabBarButton.h"

@implementation TabBarButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setSelectedImage:(UIImage*)selectedImage disselectedImage:(UIImage*)disselectedImage
{
    if (!self.haveChoose)
    {
        [self setImage:selectedImage forState:UIControlStateHighlighted];
        [self setImage:disselectedImage forState:UIControlStateNormal];
    }
    else
    {
        [self setImage:disselectedImage forState:UIControlStateHighlighted];
        [self setImage:selectedImage forState:UIControlStateNormal];
    }
}
-(void)setSelectedTitleColor:(UIColor*)selectedTitleColor disselectedTitleColor:(UIColor*)disselectedTitleColor
{
    if (!self.haveChoose)
    {
        [self setTitleColor:selectedTitleColor forState:UIControlStateHighlighted];
        [self setTitleColor:disselectedTitleColor forState:UIControlStateNormal];
    }
    else
    {
        [self setTitleColor:disselectedTitleColor forState:UIControlStateHighlighted];
        [self setTitleColor:selectedTitleColor forState:UIControlStateNormal];
    }
}
+(TabBarButton*)tabBarButton:(BOOL)customerTitle
{
    if (!customerTitle)
    {
        TabBarButton *button = [self buttonWithImageFrameBlock:^CGRect(CGRect contentRect) {
            return contentRect;
        } titleFrameBlock:^CGRect(CGRect contentRect) {
            return CGRectZero;
        }];
        return button;
    }
    else
    {
        TabBarButton *button = [self buttonWithImageFrameBlock:^CGRect(CGRect contentRect) {
            return CGRectMake(contentRect.origin.x, contentRect.origin.y, contentRect.size.width, contentRect.size.height-20.0f);
        } titleFrameBlock:^CGRect(CGRect contentRect) {
            return CGRectMake(contentRect.origin.x, contentRect.origin.y+contentRect.size.height-20.0f, contentRect.size.width, 20.0f);;
        }];
        return button;
    }
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _badgeValue = 0;
        _badgeValueLabel = [UILabel new];
        [_badgeValueLabel setBackgroundColor:ColorSystem(redColor)];
        [_badgeValueLabel setClipsToBounds:YES];
        [_badgeValueLabel setUserInteractionEnabled:NO];
        [_badgeValueLabel setTextAlignment:1];
        [_badgeValueLabel setTextColor:ColorSystem(whiteColor)];
        [_badgeValueLabel setFont:FontSystem(10)];
        [_badgeValueLabel sizeToFit];
        [_badgeValueLabel.layer setCornerRadius:8.0f];
        [self addSubview:_badgeValueLabel];
        [_badgeValueLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
        [_badgeValueLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
        [_badgeValueLabel autoSetDimension:ALDimensionHeight toSize:16.0f];
        [_badgeValueLabel autoSetDimension:ALDimensionWidth toSize:16.0f relation:NSLayoutRelationGreaterThanOrEqual];
        [_badgeValueLabel setHidden:YES];
        
        [self.titleLabel setFont:FontSystem(12)];
    }
    return self;
}

-(void)setBadgeValue:(int)badgeValue
{
    _badgeValue = MAX(0, badgeValue);
    if (_badgeValue<=0)
    {
        [_badgeValueLabel setHidden:YES];
    }
    else
    {
        [_badgeValueLabel setHidden:NO];
        [_badgeValueLabel setText:[NSString stringWithFormat:@"%i",_badgeValue]];
    }
}
@end
