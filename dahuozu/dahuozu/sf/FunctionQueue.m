//
//  FunctionQueue.m
//  dahuozu
//
//  Created by apple on 16/1/7.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "FunctionQueue.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <libkern/OSAtomic.h>
#import <pthread.h>

@implementation FunctionQueue
#pragma mark 获取一个单例
+(instancetype)shareQueue
{
    static FunctionQueue *_shareQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareQueue = [[FunctionQueue alloc]init];
    });
    
    return _shareQueue;
}
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _plans = [NSMutableArray array];
        _runnings = [NSMutableArray array];
        self.queue = [[NSOperationQueue alloc]init];
    }
    return self;
}
#pragma mark 创建定时触发器并启动
-(void)setupDisplayLink
{
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(checkUndoPlan)];
    [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}
#pragma mark 检查是否还有未执行任务
-(void)checkUndoPlan
{
    //锁
    OSSpinLock spinlock = OS_SPINLOCK_INIT;
    OSSpinLockLock(&spinlock);
    {
        BOOL normal = YES;
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        //检查每一个任务
        for (NSInteger i=0; i<self.plans.count; i = (i + (normal ? 1 : 0)))
        {
            normal = YES;
            
            WorkPlanObject *plan = [self.plans objectAtIndex:i];
            if (plan.haveRun)//计划已实行移除
            {
                normal = NO;
                [self.plans removeObjectAtIndex:i];
                continue;
            }
            else
            {
                if (currentTime>=plan.timeLeft)
                {
                    normal = NO;
                    [self.plans removeObjectAtIndex:i];
                    [self.runnings addObject:plan];
                    plan.haveRun = YES;
                    if (plan.inMain)//主线程执行
                    {
                        [[NSOperationQueue mainQueue] addOperation:plan.plan];
                    }
                    else
                    {
                        [self.queue addOperation:plan.plan];
                    }
                }
                else//添加时已排序如果这个未到时间接下来都没有到触发时间
                {
                    break;
                }
            }
        }
        //如果没有未完成取消触发
        if (self.plans.count<=0)
        {
            [self.link removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        }
    }
    OSSpinLockUnlock(&spinlock);
}
#pragma mark 添加一个任务
-(void)addPlan:(WorkPlanObject*)plan finshBlock:(void(^)(WorkPlanObject *plan))block
{
    if (self.link==nil)
    {
        [self setupDisplayLink];
    }
    if (!plan.haveRun)
    {
        BOOL needRestart = !(self.plans.count>0);
        
        OSSpinLock spinlock = OS_SPINLOCK_INIT;
        OSSpinLockLock(&spinlock);
        {
            WorkPlanObject * __weak weakplan = plan;
            FunctionQueue * __weak weakself = self;
            NSInteger index = 0;
            for (NSInteger i=0; i<self.plans.count; i++)
            {
                WorkPlanObject *ePlan = [self.plans objectAtIndex:i];
                if (ePlan.timeLeft>plan.timeLeft)
                {
                    break;
                }
                index++;
            }
            [self.plans insertObject:plan atIndex:index];
            [plan.plan setCompletionBlock:^{
                WorkPlanObject * __strong strongplan = weakplan;
                FunctionQueue * __strong strongself = weakself;
                [strongself finshOperationPlan:strongplan];
                block(strongplan);
            }];
            
            if (needRestart)
            {
                [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            }
        }
        OSSpinLockUnlock(&spinlock);
    }
}
-(void)finshOperationPlan:(WorkPlanObject*)plan
{
    [self.runnings removeObject:plan];
}
#pragma mark 移除任务通过标识
-(void)removePlanWithMark:(NSString*)mark
{
    OSSpinLock spinlock = OS_SPINLOCK_INIT;
    OSSpinLockLock(&spinlock);
    {
        BOOL normal = YES;
        
        for (NSInteger i=0; i<self.plans.count; i = (i + (normal ? 1 : 0)))
        {
            normal = YES;
            
            WorkPlanObject *plan = [self.plans objectAtIndex:i];
            if (plan.mark!=nil)
            {
                NSString *planMark = [NSString pargramText:plan.mark];
                if ([planMark isEqualToString:mark])
                {
                    normal = NO;
                    [self.plans removeObjectAtIndex:i];
                }
            }
            
        }
        for (NSInteger i=0; i<self.runnings.count; i = (i + (normal ? 1 : 0)))
        {
            normal = YES;
            
            WorkPlanObject *plan = [self.runnings objectAtIndex:i];
            if (plan.mark!=nil)
            {
                NSString *planMark = [NSString pargramText:plan.mark];
                if ([planMark isEqualToString:mark])
                {
                    normal = NO;
                    [plan.plan cancel];
                    [self.runnings removeObjectAtIndex:i];
                }
            }
            
        }
    }
    OSSpinLockUnlock(&spinlock);
}
#pragma mark 移除任务通过类型
-(void)removePlanWithType:(NSUInteger)type
{
    OSSpinLock spinlock = OS_SPINLOCK_INIT;
    OSSpinLockLock(&spinlock);
    {
        BOOL normal = YES;
        
        for (NSInteger i=0; i<self.plans.count; i = (i + (normal ? 1 : 0)))
        {
            normal = YES;
            
            WorkPlanObject *plan = [self.plans objectAtIndex:i];
            if (plan.type!=NSNotFound)
            {
                if (plan.type==type)
                {
                    normal = NO;
                    [self.plans removeObjectAtIndex:i];
                }
            }
            
        }
        for (NSInteger i=0; i<self.runnings.count; i = (i + (normal ? 1 : 0)))
        {
            normal = YES;
            
            WorkPlanObject *plan = [self.runnings objectAtIndex:i];
            if (plan.type!=NSNotFound)
            {
                if (plan.type==type)
                {
                    normal = NO;
                    [plan.plan cancel];
                    [self.runnings removeObjectAtIndex:i];
                }
            }
            
        }
    }
    OSSpinLockUnlock(&spinlock);
}
@end
