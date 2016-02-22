//
//  ColorsProgress.m
//  dahuozu
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "ColorsProgress.h"

@implementation ColorsProgress
{
    CAGradientLayer *colorsLayer;
    CAShapeLayer *animationLayer;
    NSArray *gradientColors;
    CGFloat currentPercent;
    CADisplayLink *animaitonLink;
}

-(id)initWithFrame:(CGRect)frame colors:(NSArray *)colors
{
    self = [super initWithFrame:frame];
    if (self)
    {
        gradientColors = [NSArray arrayWithArray:colors];
        currentPercent = 0.0f;
        animaitonLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(stepAnimation:)];
        animaitonLink.frameInterval = 20;
        [animaitonLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        animaitonLink.paused = YES;
        [self setProgressLayer];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self setProgressLayer];
}
-(void)dealloc
{
    [colorsLayer removeFromSuperlayer];
    [colorsLayer setMask:nil];
    animationLayer = nil;
    colorsLayer = nil;
    gradientColors = nil;
    animaitonLink.paused = YES;
    [animaitonLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [animaitonLink invalidate];
    animaitonLink = nil;
}
-(void)setProgressLayer
{
    [colorsLayer removeFromSuperlayer];
    [colorsLayer setMask:nil];
    animationLayer = nil;
    colorsLayer = nil;
    
    colorsLayer =  [CAGradientLayer layer];
    colorsLayer.frame = self.bounds;
    NSMutableArray *colorsArray = [NSMutableArray array];
    NSMutableArray *locationArray = [NSMutableArray array];
    for (NSInteger i=0; i<gradientColors.count; i++)
    {
        UIColor *color = [gradientColors objectAtIndex:i];
        NSNumber *location = [NSNumber numberWithFloat:(1.0f/gradientColors.count*i)];
        [colorsArray addObject:(id)color.CGColor];
        [locationArray addObject:location];
    }
    [colorsLayer setColors:colorsArray];
    [colorsLayer setLocations:locationArray];
    [colorsLayer setStartPoint:CGPointMake(0.0, 0.5)];
    [colorsLayer setEndPoint:CGPointMake(1.0, 0.5)];
    
    
    animationLayer = [CAShapeLayer layer];
    animationLayer.frame = self.bounds;
    animationLayer.fillColor =  ColorSystem(clearColor).CGColor;
    animationLayer.strokeColor = ColorSystem(whiteColor).CGColor;
    animationLayer.lineCap = kCALineCapRound;
    animationLayer.lineWidth = self.bounds.size.height;
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(0, self.bounds.size.height/2.0f)];
    [linePath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height/2.0f)];
    animationLayer.path = linePath.CGPath;
    animationLayer.strokeStart = currentPercent;
    animationLayer.strokeEnd = 1.0f;
    
    [colorsLayer setMask:animationLayer];
    [self.layer addSublayer:colorsLayer];
}
-(void)setPercent:(CGFloat)percent
{
    currentPercent = percent;
    animationLayer.strokeStart = currentPercent;
}
-(void)beginLoadAnimation
{
    [self setPercent:0.0f];
    [animaitonLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    animaitonLink.paused = NO;
}
-(void)stepAnimation:(CADisplayLink*)link
{
    if (currentPercent<=0.20f)
    {
        [self setPercent:currentPercent+(1.0f-currentPercent)*0.025f];
    }
    else if (currentPercent>=0.85f)
    {
        [self setPercent:currentPercent+(1.0f-currentPercent)*0.0125f];
    }
    else if (currentPercent>=0.95f)
    {
        animaitonLink.paused = YES;
    }
    else
    {
        [self setPercent:currentPercent+(1.0f-currentPercent)*0.075f];
    }
}
-(void)endLoadAnimation
{
    [self setPercent:1.0f];
    animaitonLink.paused = YES;
    
}
@end
