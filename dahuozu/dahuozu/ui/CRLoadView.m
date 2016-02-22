//
//  CRLoadView.m
//  dahuozu
//
//  Created by apple on 16/1/23.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "CRLoadView.h"

@implementation CRLoadView
{
    CAShapeLayer *layer1;
    CAShapeLayer *layer2;
    CAShapeLayer *layer3;
    CAShapeLayer *layer4;
    CAShapeLayer *layer5;
    CAShapeLayer *layer6;
    CAShapeLayer *layer7;
    CAShapeLayer *layer8;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame color:[UIColor grayColor]];
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame color:(UIColor*)color
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGPoint center = CGPointMake(frame.size.width/2.0f, frame.size.height/2.0f);
        CGFloat r = (MIN(frame.size.width, frame.size.height))/2.0f;
        
        layer1 = [CAShapeLayer layer];
        layer1.frame = self.bounds;
        layer1.fillColor =  [UIColor clearColor].CGColor;
        layer1.strokeColor = color.CGColor;
        layer1.lineCap = kCALineCapRound;
        layer1.lineWidth = 2.0f;
        UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:center radius:r-3.0f startAngle:M_PI_2*0 endAngle:M_PI_2*4 clockwise:YES];
        layer1.path = path1.CGPath;
        [self.layer addSublayer:layer1];
        
        
        layer2 = [CAShapeLayer layer];
        layer2.frame = self.bounds;
        layer2.fillColor =  [UIColor clearColor].CGColor;
        layer2.strokeColor = color.CGColor;
        layer2.lineCap = kCALineCapRound;
        layer2.lineWidth = 2.0f;
        UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:center radius:r-3.0f startAngle:M_PI_2*1 endAngle:M_PI_2*5 clockwise:YES];
        layer2.path = path2.CGPath;
        [self.layer addSublayer:layer2];
        
        
        layer3 = [CAShapeLayer layer];
        layer3.frame = self.bounds;
        layer3.fillColor =  [UIColor clearColor].CGColor;
        layer3.strokeColor = color.CGColor;
        layer3.lineCap = kCALineCapRound;
        layer3.lineWidth = 2.0f;
        UIBezierPath *path3 = [UIBezierPath bezierPathWithArcCenter:center radius:r-3.0f startAngle:M_PI_2*2 endAngle:M_PI_2*6 clockwise:YES];
        layer3.path = path3.CGPath;
        [self.layer addSublayer:layer3];
        
        
        layer4 = [CAShapeLayer layer];
        layer4.frame = self.bounds;
        layer4.fillColor =  [UIColor clearColor].CGColor;
        layer4.strokeColor = color.CGColor;
        layer4.lineCap = kCALineCapRound;
        layer4.lineWidth = 2.0f;
        UIBezierPath *path4 = [UIBezierPath bezierPathWithArcCenter:center radius:r-3.0f startAngle:M_PI_2*3 endAngle:M_PI_2*7 clockwise:YES];
        layer4.path = path4.CGPath;
        [self.layer addSublayer:layer4];
        
        
        layer5 = [CAShapeLayer layer];
        layer5.frame = self.bounds;
        layer5.fillColor =  [UIColor clearColor].CGColor;
        layer5.strokeColor = color.CGColor;
        layer5.lineCap = kCALineCapRound;
        layer5.lineWidth = 1.0f;
        UIBezierPath *path5 = [UIBezierPath bezierPath];
        [path5 moveToPoint:CGPointMake(center.x, center.y-r*0.9f)];
        [path5 addLineToPoint:CGPointMake(center.x+r*0.9f*0.5f*sqrtf(3.0f), center.y+r*0.9f*0.5f)];
        [path5 moveToPoint:CGPointMake(center.x+r*0.9f*0.5f*sqrtf(3.0f), center.y+r*0.9f*0.5f)];
        [path5 addLineToPoint:CGPointMake(center.x-r*0.9f*0.5f*sqrtf(3.0f), center.y+r*0.9f*0.5f)];
        [path5 moveToPoint:CGPointMake(center.x-r*0.9f*0.5f*sqrtf(3.0f), center.y+r*0.9f*0.5f)];
        [path5 addLineToPoint:CGPointMake(center.x, center.y-r*0.9f)];
        layer5.path = path5.CGPath;
        [self.layer addSublayer:layer5];
        
        
        layer6 = [CAShapeLayer layer];
        layer6.frame = self.bounds;
        layer6.fillColor =  [UIColor clearColor].CGColor;
        layer6.strokeColor = color.CGColor;
        layer6.lineCap = kCALineCapRound;
        layer6.lineWidth = 1.0f;
        UIBezierPath *path6 = [UIBezierPath bezierPath];
        [path6 moveToPoint:CGPointMake(center.x, center.y+r*0.9f)];
        [path6 addLineToPoint:CGPointMake(center.x-r*0.9f*0.5f*sqrtf(3.0f), center.y-r*0.9f*0.5f)];
        [path6 moveToPoint:CGPointMake(center.x-r*0.9f*0.5f*sqrtf(3.0f), center.y-r*0.9f*0.5f)];
        [path6 addLineToPoint:CGPointMake(center.x+r*0.9f*0.5f*sqrtf(3.0f), center.y-r*0.9f*0.5f)];
        [path6 moveToPoint:CGPointMake(center.x+r*0.9f*0.5f*sqrtf(3.0f), center.y-r*0.9f*0.5f)];
        [path6 addLineToPoint:CGPointMake(center.x, center.y+r*0.9f)];
        layer6.path = path6.CGPath;
        [self.layer addSublayer:layer6];
        
        
        layer7 = [CAShapeLayer layer];
        layer7.frame = self.bounds;
        layer7.fillColor =  [UIColor clearColor].CGColor;
        layer7.strokeColor = color.CGColor;
        layer7.lineCap = kCALineCapRound;
        layer7.lineWidth = 1.0f;
        UIBezierPath *path7 = [UIBezierPath bezierPath];
        [path7 moveToPoint:CGPointMake(center.x+r*0.9f, center.y)];
        [path7 addLineToPoint:CGPointMake(center.x-r*0.9f*0.5f, center.y-r*0.9f*0.5f*sqrtf(3.0f))];
        [path7 moveToPoint:CGPointMake(center.x-r*0.9f*0.5f, center.y-r*0.9f*0.5f*sqrtf(3.0f))];
        [path7 addLineToPoint:CGPointMake(center.x-r*0.9f*0.5f, center.y+r*0.9f*0.5f*sqrtf(3.0f))];
        [path7 moveToPoint:CGPointMake(center.x-r*0.9f*0.5f, center.y+r*0.9f*0.5f*sqrtf(3.0f))];
        [path7 addLineToPoint:CGPointMake(center.x+r*0.9f, center.y)];
        layer7.path = path7.CGPath;
        [self.layer addSublayer:layer7];
        
        
        
        layer8 = [CAShapeLayer layer];
        layer8.frame = self.bounds;
        layer8.fillColor =  [UIColor clearColor].CGColor;
        layer8.strokeColor = color.CGColor;
        layer8.lineCap = kCALineCapRound;
        layer8.lineWidth = 1.0f;
        UIBezierPath *path8 = [UIBezierPath bezierPath];
        [path8 moveToPoint:CGPointMake(center.x-r*0.9f, center.y)];
        [path8 addLineToPoint:CGPointMake(center.x+r*0.9f*0.5f, center.y+r*0.9f*0.5f*sqrtf(3.0f))];
        [path8 moveToPoint:CGPointMake(center.x+r*0.9f*0.5f, center.y+r*0.9f*0.5f*sqrtf(3.0f))];
        [path8 addLineToPoint:CGPointMake(center.x+r*0.9f*0.5f, center.y-r*0.9f*0.5f*sqrtf(3.0f))];
        [path8 moveToPoint:CGPointMake(center.x+r*0.9f*0.5f, center.y-r*0.9f*0.5f*sqrtf(3.0f))];
        [path8 addLineToPoint:CGPointMake(center.x-r*0.9f, center.y)];
        layer8.path = path8.CGPath;
        [self.layer addSublayer:layer8];
        
    }
    return self;
}

-(void)addAnimation
{

    [layer1 addAnimation:[self startAnimationInsertInToLayer:1.0f] forKey:@"setStrokeStart"];
    [layer1 addAnimation:[self endAnimationInsertInToLayer] forKey:@"setStrokeEnd"];
//    [layer1 addAnimation:[self scaleAnimationInsertToLayer] forKey:@"setScale"];
    
    
    [layer2 addAnimation:[self startAnimationInsertInToLayer:1.0f] forKey:@"setStrokeStart"];
    [layer2 addAnimation:[self endAnimationInsertInToLayer] forKey:@"setStrokeEnd"];
//    [layer2 addAnimation:[self scaleAnimationInsertToLayer] forKey:@"setScale"];

    
    [layer3 addAnimation:[self startAnimationInsertInToLayer:1.0f] forKey:@"setStrokeStart"];
    [layer3 addAnimation:[self endAnimationInsertInToLayer] forKey:@"setStrokeEnd"];
//    [layer3 addAnimation:[self scaleAnimationInsertToLayer] forKey:@"setScale"];

    
    [layer4 addAnimation:[self startAnimationInsertInToLayer:1.0f] forKey:@"setStrokeStart"];
    [layer4 addAnimation:[self endAnimationInsertInToLayer] forKey:@"setStrokeEnd"];
//    [layer4 addAnimation:[self scaleAnimationInsertToLayer] forKey:@"setScale"];
    
    
    [layer5 addAnimation:[self startAnimationInsertInToLayer:6.0f] forKey:@"setStrokeStart"];
    [layer5 addAnimation:[self endAnimationInsertInToLayer] forKey:@"setStrokeEnd"];
    [layer5 addAnimation:[self scaleAnimationInsertToLayer] forKey:@"setScale"];
    
    [layer6 addAnimation:[self startAnimationInsertInToLayer:6.0f] forKey:@"setStrokeStart"];
    [layer6 addAnimation:[self endAnimationInsertInToLayer] forKey:@"setStrokeEnd"];
    [layer6 addAnimation:[self scaleAnimationInsertToLayer] forKey:@"setScale"];
    
    [layer7 addAnimation:[self startAnimationInsertInToLayer:6.0f] forKey:@"setStrokeStart"];
    [layer7 addAnimation:[self endAnimationInsertInToLayer] forKey:@"setStrokeEnd"];
//    [layer7 addAnimation:[self scaleAnimationInsertToLayer] forKey:@"setScale"];
    
    [layer8 addAnimation:[self startAnimationInsertInToLayer:6.0f] forKey:@"setStrokeStart"];
    [layer8 addAnimation:[self endAnimationInsertInToLayer] forKey:@"setStrokeEnd"];
//    [layer8 addAnimation:[self scaleAnimationInsertToLayer] forKey:@"setScale"];
}

-(CAAnimation*)startAnimationInsertInToLayer:(CGFloat)scale
{
    CAKeyframeAnimation *animationStart = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    animationStart.duration = 2.4;
    animationStart.removedOnCompletion = YES;
    animationStart.repeatCount = HUGE_VALF;
    animationStart.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    NSMutableArray *values = [NSMutableArray array];
    
    
    for (int i=0; i<=180; i++)
    {
        CGFloat strokeRange = i>=90?(0.25*scale*((180-i)*1.0f/90)):(0.25*scale*(i*1.0f/90));
        
        [values addObject:@(1.0f/180*i-strokeRange)];
    }
    animationStart.values = values;
    animationStart.autoreverses = NO;
    
    return animationStart;
}

-(CAAnimation*)endAnimationInsertInToLayer
{
    CAKeyframeAnimation *animationEnd = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    animationEnd.duration = 2.4;
    animationEnd.removedOnCompletion = YES;
    animationEnd.repeatCount = HUGE_VALF;
    animationEnd.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    NSMutableArray *values = [NSMutableArray array];
    for (int i=0; i<=180; i++)
    {
        [values addObject:@(1.0f/180*i)];
    }
    animationEnd.values = values;
    animationEnd.autoreverses = NO;
    
    return animationEnd;
}

-(CAAnimation*)scaleAnimationInsertToLayer
{
    CABasicAnimation *animationScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animationScale.duration = 1.2f;
    animationScale.removedOnCompletion = YES;
    animationScale.repeatCount = HUGE_VALF;
    animationScale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animationScale.fromValue = @(1.0f);
    animationScale.toValue = @(0.3f);
    animationScale.autoreverses = YES;
    return animationScale;
}

-(void)startLoading
{
    [self addAnimation];
}
-(void)endLoading
{
    [layer1 removeAllAnimations];
    [layer2 removeAllAnimations];
    [layer3 removeAllAnimations];
    [layer4 removeAllAnimations];
    [layer5 removeAllAnimations];
    [layer6 removeAllAnimations];
    [layer7 removeAllAnimations];
    [layer8 removeAllAnimations];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
