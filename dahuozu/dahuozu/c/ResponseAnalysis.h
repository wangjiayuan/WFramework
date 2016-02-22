//
//  ResponseAnalysis.h
//  dahuozu
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivitySimpleModel.h"

@interface ResponseAnalysis : NSObject
#pragma mark 单例
+(ResponseAnalysis*)shareAnalysis;
#pragma mark 解析保存活动列表数据
-(NSMutableArray*)saveActivityListResponse:(id)result;
@end
