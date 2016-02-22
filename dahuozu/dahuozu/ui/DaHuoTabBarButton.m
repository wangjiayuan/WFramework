//
//  DaHuoTabBarButton.m
//  dahuozu
//
//  Created by apple on 16/1/20.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "DaHuoTabBarButton.h"

@implementation DaHuoTabBarButton


+(DaHuoTabBarButton*)tabBarButton:(BOOL)customerTitle
{
    if (!customerTitle)
    {
        DaHuoTabBarButton *button = [self buttonWithImageFrameBlock:^CGRect(CGRect contentRect) {
            return [self imageRectFromRect:contentRect];
        } titleFrameBlock:^CGRect(CGRect contentRect) {
            return CGRectZero;
        }];
        [button setClipsToBounds:YES];
        return button;
    }
    else
    {
        DaHuoTabBarButton *button = [self buttonWithImageFrameBlock:^CGRect(CGRect contentRect) {
            return [self imageRectFromRect:CGRectMake(contentRect.origin.x, contentRect.origin.y, contentRect.size.width, contentRect.size.height-20.0f)];
        } titleFrameBlock:^CGRect(CGRect contentRect) {
            return CGRectMake(contentRect.origin.x, contentRect.origin.y+contentRect.size.height-20.0f, contentRect.size.width, 20.0f);;
        }];
        [button setClipsToBounds:YES];
        return button;
    }
}




+(CGRect)imageRectFromRect:(CGRect)imageContentRect
{
    CGFloat needWidth = DaHuoTabBarImageSize*imageContentRect.size.height;
    return CGRectMake(imageContentRect.origin.x+(imageContentRect.size.width-needWidth)/2.0f, imageContentRect.origin.y, needWidth, imageContentRect.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
