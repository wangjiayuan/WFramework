//
//  FunctionQueue.h
//  dahuozu
//
//  Created by apple on 16/1/7.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkPlanObject.h"
#pragma mark 任务队列
@interface FunctionQueue : NSObject
//执行非主线程任务的队列
@property(nonatomic,strong)NSOperationQueue *queue;
//未执行的任务
@property(nonatomic,strong,readonly)NSMutableArray *plans;
//正在执行的任务
@property(nonatomic,strong,readonly)NSMutableArray *runnings;
//开始时间
@property(nonatomic,readonly,assign)NSTimeInterval startTime;
//定时触发器
@property(nonatomic,strong)CADisplayLink *link;
#pragma mark 添加一个任务
-(void)addPlan:(WorkPlanObject*)plan finshBlock:(void(^)(WorkPlanObject *plan))block;
#pragma mark 移除任务通过标识
-(void)removePlanWithMark:(NSString*)mark;
#pragma mark 移除任务通过类型
-(void)removePlanWithType:(NSUInteger)type;
#pragma mark 获取一个单例
+(instancetype)shareQueue;

@end
