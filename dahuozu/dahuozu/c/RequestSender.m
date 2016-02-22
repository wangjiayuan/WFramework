//
//  RequestSender.m
//  dahuozu
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "RequestSender.h"
#import "NetWorkManager.h"
#import "ResponseAnalysis.h"

@implementation RequestSender
#pragma mark 请求活动列表数据
+(NSURLSessionDataTask*)getActivityListData:(NSDictionary*)parameters finshBlock:(void (^)(NSArray *listData, RequestResponseResultType state))block
{
    NSURLSessionDataTask *task = [[NetWorkManager sharedClient] postRequestApi:@"queryactivity.html" parameters:parameters finshBlock:^(id result, NSError *error) {
        if ([self isResult:result])
        {
            MyDataLog(@"开始");
            NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithTarget:[ResponseAnalysis shareAnalysis] selector:@selector(saveActivityListResponse:) object:result];
            NSInvocationOperation * __weak weakoperation = operation;
            [operation setCompletionBlock:^{
                NSInvocationOperation * __strong strongoperation = weakoperation;
                NSMutableArray *responseResult = [strongoperation result];
                if ([responseResult count]>0)
                {
                    block(responseResult,RequestResponseResultSuccess);
                }
                else
                {
                    block(responseResult,RequestResponseResultNoData);
                }
            }];
            [operation start];
        }
        else
        {
            block(nil,RequestResponseResultError);
        }
    }];
    return task;
}
#pragma mark 验证返回是否正确
+(BOOL)isResult:(id)result
{
    if ([result isKindOfClass:[NSDictionary class]])
    {
        if ([[result valueForKey:@"returnCode"] integerValue]==0)
        {
            return YES;
        }
    }
    return NO;
}
@end
