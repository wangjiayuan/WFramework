//
//  WorkPlanObject.h
//  dahuozu
//
//  Created by apple on 16/1/7.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark 工作计划
@interface WorkPlanObject : NSObject
//计划类型
@property(nonatomic,assign)NSUInteger type;
//计划标识
@property(nonatomic,copy)NSString *mark;
//开始任务时间距离1970的时间戳
@property(nonatomic,assign)NSTimeInterval timeLeft;
//是否已运行
@property(nonatomic,assign)BOOL haveRun;
//计划对象
@property(nonatomic,strong)NSInvocationOperation *plan;
//是否放在主线程
@property(nonatomic,assign)BOOL inMain;
#pragma mark 初始化一个对象
-(instancetype)initWithTarget:(id)target selector:(SEL)sel object:(id)arg;
#pragma mark 初始化一个对象距离现在after的时间戳
NSTimeInterval timeSinceNow(NSTimeInterval after);
@end
