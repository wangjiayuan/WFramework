//
//  NetWorkManager.h
//  dahuozu
//
//  Created by apple on 16/1/7.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@protocol NetRequestFunction <NSObject>

#pragma mark 发送GET请求（有进度）
-(NSURLSessionDataTask *)getRequestApi:(NSString*)subURL parameters:(NSDictionary*)parameters progress:(void (^)(NSProgress * downloadProgress))progressBlock finshBlock:(void (^)(id result, NSError *error))block;
#pragma mark 发送GET请求（没进度）
-(NSURLSessionDataTask *)getRequestApi:(NSString*)subURL parameters:(NSDictionary*)parameters finshBlock:(void (^)(id result, NSError *error))block;
#pragma mark 发送GET请求（没有参数）
-(NSURLSessionDataTask *)getRequestApi:(NSString*)subURL finshBlock:(void (^)(id result, NSError *error))block;
#pragma mark 发送POST请求（有进度）
-(NSURLSessionDataTask *)postRequestApi:(NSString*)subURL parameters:(NSDictionary*)parameters progress:(void (^)(NSProgress * downloadProgress))progressBlock finshBlock:(void (^)(id result, NSError *error))block;
#pragma mark 发送POST请求（没进度）
-(NSURLSessionDataTask *)postRequestApi:(NSString*)subURL parameters:(NSDictionary*)parameters finshBlock:(void (^)(id result, NSError *error))block;
#pragma mark 取消请求
-(void)cancelRequest:(NSString*)taskDescription;

@end

@interface NetWorkManager : AFHTTPSessionManager
<NetRequestFunction>


#pragma mark 单例
+ (instancetype)sharedClient;

@end

@interface NSObject (OnlyTagInfo)

-(NSInteger)toTag;

@end
