//
//  NetWorkManager.m
//  dahuozu
//
//  Created by apple on 16/1/7.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "NetWorkManager.h"

static NSString * const AppNetAPIBaseURLString = SERVER_API_URL;


@implementation NetWorkManager
#pragma mark 单例
+ (instancetype)sharedClient
{
    static NetWorkManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NetWorkManager alloc] initWithBaseURL:[NSURL URLWithString:AppNetAPIBaseURLString]];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"text/json",@"application/json",@"text/javascript",@"text/html",@"text/plain",@"text/html",nil];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedClient;
}
#pragma mark 发送GET请求
-(NSURLSessionDataTask *)getRequestApi:(NSString*)subURL parameters:(NSDictionary*)parameters progress:(void (^)(NSProgress * downloadProgress))progressBlock finshBlock:(void (^)(id result, NSError *error))block
{
    return [self GET:subURL parameters:parameters progress:^(NSProgress *downloadProgress)
    {
        if (progressBlock!=NULL)
        {
            progressBlock(downloadProgress);
        }
    }
                                      success:^(NSURLSessionDataTask *task, id responseObject)
    {
        if (block!=NULL)
        {
            block(responseObject,nil);
        }
    }
                                      failure:^(NSURLSessionDataTask * task, NSError * error)
    {
        if (block!=NULL)
        {
            if (task.state==NSURLSessionTaskStateCompleted)
            {
                block(nil,error);
            }
        }
    }];
}
#pragma mark 发送GET请求（没进度）
-(NSURLSessionDataTask *)getRequestApi:(NSString*)subURL parameters:(NSDictionary*)parameters finshBlock:(void (^)(id result, NSError *error))block
{
    return [self getRequestApi:subURL parameters:parameters progress:nil finshBlock:block];
}
#pragma mark 发送GET请求（没有参数）
-(NSURLSessionDataTask *)getRequestApi:(NSString*)subURL finshBlock:(void (^)(id result, NSError *error))block
{
    return [self getRequestApi:subURL parameters:nil finshBlock:block];
}
#pragma mark 发送POST请求（有进度）
-(NSURLSessionDataTask *)postRequestApi:(NSString*)subURL parameters:(NSDictionary*)parameters progress:(void (^)(NSProgress * downloadProgress))progressBlock finshBlock:(void (^)(id result, NSError *error))block
{
    return [self POST:subURL parameters:parameters progress:^(NSProgress *downloadProgress)
            {
                if (progressBlock!=NULL)
                {
                    progressBlock(downloadProgress);
                }
            }
                                      success:^(NSURLSessionDataTask *task, id responseObject)
            {
                if (block!=NULL)
                {
                    block(responseObject,nil);
                }
            }
                                      failure:^(NSURLSessionDataTask * task, NSError * error)
            {
                if (block!=NULL)
                {
                    if (task.state==NSURLSessionTaskStateCompleted)
                    {
                        block(nil,error);
                    }
                }
            }];
}
#pragma mark 发送POST请求（没进度）
-(NSURLSessionDataTask *)postRequestApi:(NSString*)subURL parameters:(NSDictionary*)parameters finshBlock:(void (^)(id result, NSError *error))block
{
    return [self postRequestApi:subURL parameters:parameters progress:nil finshBlock:block];
}
#pragma mark 取消请求
-(void)cancelRequest:(NSString*)taskDescription
{
    NSString *description = [NSString pargramText:taskDescription];
    
    for (NSURLSessionDataTask *task in [self tasks])
    {
        if ([description isEqualToString:task.taskDescription])
        {
            [task cancel];
        }
    }
}
@end

@implementation NSObject (OnlyTagInfo)

-(NSInteger)toTag
{
    return (NSInteger)self;
}

@end
