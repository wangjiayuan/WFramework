//
//  WorkPlanObject.m
//  dahuozu
//
//  Created by apple on 16/1/7.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "WorkPlanObject.h"

@implementation WorkPlanObject
#pragma mark 初始化一个对象
-(instancetype)initWithTarget:(id)target selector:(SEL)sel object:(id)arg
{
    self = [self init];
    if (self)
    {
        self.haveRun = NO;
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        self.timeLeft = time;
        self.inMain = YES;
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithTarget:target selector:sel object:arg];
        self.plan = operation;
        self.mark = nil;
        self.type = NSNotFound;
    }
    return self;
}
#pragma mark 初始化一个对象距离现在after的时间戳

NSTimeInterval timeSinceNow(NSTimeInterval after)
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970]+after;
    return time;
}
@end
