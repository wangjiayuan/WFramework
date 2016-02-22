//
//  RequestSender.h
//  dahuozu
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,RequestResponseResultType)
{
    RequestResponseResultSuccess = 0,//成功
    RequestResponseResultNoData = 1,//没有更多数据
    RequestResponseResultError = 2,//网络错误没有任何返回
    RequestResponseResultOther = 3//其他错误
};

@interface RequestSender : NSObject
#pragma mark 请求活动列表数据
+(NSURLSessionTask*)getActivityListData:(NSDictionary*)parameters finshBlock:(void (^)(NSArray *listData, RequestResponseResultType state))block;
@end
