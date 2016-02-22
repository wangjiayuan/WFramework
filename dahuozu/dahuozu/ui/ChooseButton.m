//
//  ChooseButton.m
//  dahuozu
//
//  Created by apple on 16/1/20.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "ChooseButton.h"

@implementation ChooseButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setHaveChoose:(BOOL)haveChoose
{
    if (_haveChoose)
    {
        if (!haveChoose)
        {
            [self exChangeNormalHighlightedState];
        }
    }
    else
    {
        if (haveChoose)
        {
            [self exChangeNormalHighlightedState];
        }
    }
    
    _haveChoose = haveChoose;
}
-(void)exChangeNormalHighlightedState
{
    NSString *highlightedTitle = [self titleForState:UIControlStateHighlighted];
    NSString *normalTitle = [self titleForState:UIControlStateNormal];
    UIImage *highlightedImage = [self imageForState:UIControlStateHighlighted];
    UIImage *normalImage = [self imageForState:UIControlStateNormal];
    UIImage *highlightedBackgroundImage = [self backgroundImageForState:UIControlStateHighlighted];
    UIImage *normalBackgroundImage = [self backgroundImageForState:UIControlStateNormal];
    UIColor *normalTitleColor = [self titleColorForState:UIControlStateNormal];
    UIColor *highlightedTitleColor = [self titleColorForState:UIControlStateHighlighted];
    UIColor *normalTitleShadowColor = [self titleShadowColorForState:UIControlStateNormal];
    UIColor *highlightedTitleShadowColor = [self titleShadowColorForState:UIControlStateHighlighted];
    NSAttributedString *normalAttributedTitle = [self attributedTitleForState:UIControlStateNormal];
    NSAttributedString *highlightedAttributedTitle = [self attributedTitleForState:UIControlStateHighlighted];
    
    [self setTitle:highlightedTitle forState:UIControlStateNormal];
    [self setTitle:normalTitle forState:UIControlStateHighlighted];
    [self setBackgroundImage:highlightedBackgroundImage forState:UIControlStateNormal];
    [self setBackgroundImage:normalBackgroundImage forState:UIControlStateHighlighted];
    [self setTitleColor:normalTitleColor forState:UIControlStateHighlighted];
    [self setTitleColor:highlightedTitleColor forState:UIControlStateNormal];
    [self setImage:normalImage forState:UIControlStateHighlighted];
    [self setImage:highlightedImage forState:UIControlStateNormal];
    [self setTitleShadowColor:normalTitleShadowColor forState:UIControlStateHighlighted];
    [self setTitleShadowColor:highlightedTitleShadowColor forState:UIControlStateNormal];
    [self setAttributedTitle:normalAttributedTitle forState:UIControlStateHighlighted];
    [self setAttributedTitle:highlightedAttributedTitle forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    if (state==UIControlStateNormal)
    {
        if ([self titleForState:UIControlStateHighlighted]==nil)
        {
            [self setTitle:title forState:UIControlStateHighlighted];
        }
    }
    
    [super setTitle:title forState:state];
}
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    if (state==UIControlStateNormal)
    {
        if ([self titleColorForState:UIControlStateHighlighted]==nil)
        {
            [self setTitleColor:color forState:UIControlStateHighlighted];
        }
    }
    
    [super setTitleColor:color forState:state];
}
- (void)setTitleShadowColor:(UIColor *)color forState:(UIControlState)state
{
    if (state==UIControlStateNormal)
    {
        if ([self titleShadowColorForState:UIControlStateHighlighted]==nil)
        {
            [self setTitleShadowColor:color forState:UIControlStateHighlighted];
        }
    }
    
    [super setTitleShadowColor:color forState:state];
}
- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    if (state==UIControlStateNormal)
    {
        if ([self imageForState:UIControlStateHighlighted]==nil)
        {
            [self setImage:image forState:UIControlStateHighlighted];
        }
    }
    
    [super setImage:image forState:state];
}
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
    if (state==UIControlStateNormal)
    {
        if ([self backgroundImageForState:UIControlStateHighlighted]==nil)
        {
            [self setBackgroundImage:image forState:UIControlStateHighlighted];
        }
    }
    
    [super setBackgroundImage:image forState:state];
}
- (void)setAttributedTitle:(NSAttributedString *)title forState:(UIControlState)state
{
    if (state==UIControlStateNormal)
    {
        if ([self attributedTitleForState:UIControlStateHighlighted]==nil)
        {
            [self setAttributedTitle:title forState:UIControlStateHighlighted];
        }
    }
    
    [super setAttributedTitle:title forState:state];
}

@end
