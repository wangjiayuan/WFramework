//
//  CustomerButton.h
//  dahuozu
//
//  Created by apple on 16/1/20.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef CGRect (^FrameBlock)(CGRect);

@interface CustomerButton : UIButton


@property(nonatomic,copy)FrameBlock imageBlock;
@property(nonatomic,copy)FrameBlock titleBlock;

+(instancetype)buttonWithFrame:(CGRect)frame;
+(instancetype)buttonWithFrame:(CGRect)frame imageFrameBlock:(CGRect(^)(CGRect contentRect))imageBlock titleFrameBlock:(CGRect(^)(CGRect contentRect))titleBlock;
+(instancetype)buttonWithImageFrameBlock:(CGRect (^)(CGRect contentRect))imageBlock titleFrameBlock:(CGRect (^)(CGRect contentRect))titleBlock;

@end
