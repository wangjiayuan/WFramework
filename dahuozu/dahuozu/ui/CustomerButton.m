//
//  CustomerButton.m
//  dahuozu
//
//  Created by apple on 16/1/20.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "CustomerButton.h"

@implementation CustomerButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)buttonWithFrame:(CGRect)frame
{
    CustomerButton *button = [self buttonWithFrame:frame imageFrameBlock:NULL titleFrameBlock:NULL];
    return button;
}
+(instancetype)buttonWithFrame:(CGRect)frame imageFrameBlock:(CGRect(^)(CGRect contentRect))imageBlock titleFrameBlock:(CGRect(^)(CGRect contentRect))titleBlock
{
    CustomerButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    button.imageBlock = imageBlock;
    button.titleBlock = titleBlock;
    return button;
}
+(instancetype)buttonWithImageFrameBlock:(CGRect (^)(CGRect contentRect))imageBlock titleFrameBlock:(CGRect (^)(CGRect contentRect))titleBlock
{
    CustomerButton *button = [self buttonWithFrame:CGRectZero imageFrameBlock:imageBlock titleFrameBlock:titleBlock];
    return button;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageBlock = NULL;
        self.titleBlock = NULL;
    }
    return self;
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    if (self.imageBlock==NULL)
    {
        return [super imageRectForContentRect:contentRect];
    }
    return self.imageBlock(contentRect);
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    if (self.titleBlock==NULL)
    {
        return [super titleRectForContentRect:contentRect];
    }
    return self.titleBlock(contentRect);
}
@end
