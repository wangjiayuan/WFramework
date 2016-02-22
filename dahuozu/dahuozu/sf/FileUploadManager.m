//
//  FileUploadManager.m
//  dahuozu
//
//  Created by apple on 16/1/7.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "FileUploadManager.h"

static NSString * const AppFileNetAPIBaseURLString = @"http://www.dahuozu.com/";

@implementation FileUploadManager
#pragma mark 单例
+ (instancetype)uploadClient
{
    static FileUploadManager *_uploadClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _uploadClient = [[FileUploadManager alloc] initWithBaseURL:[NSURL URLWithString:AppFileNetAPIBaseURLString]];
        _uploadClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"text/json",@"application/json",@"text/javascript",@"text/html",@"text/plain",@"text/html",nil];
        _uploadClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _uploadClient;
}
#pragma mark 上传图片
+(NSURLSessionDataTask *)uploadApiRequest:(NSString*)subURL imageData:(PhotoObject*)photo parameters:(NSDictionary*)parameters progress:(void (^)(NSProgress * uploadProgress))progressBlock finshBlock:(void (^)(id result, NSError *error))block
{
    return [[self uploadClient] POST:subURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  formData)
    {
        [formData appendPartWithFileURL:photo.fileURL name:@"file" fileName:[DataFunction fileNameForJPGPhoto] mimeType:@"image/jpeg" error:nil];
    }
                            progress:^(NSProgress * uploadProgress)
    {
        if (progressBlock!=NULL)
        {
            progressBlock(uploadProgress);
        }
    }
                             success:^(NSURLSessionDataTask * task, id responseObject)
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
            block(nil,error);
        }
    }];
}
#pragma mark 辰悦搭伙族上传图片
+(NSURLSessionDataTask *)uploadDahuozuApiRequest:(NSDictionary*)parameters imageData:(PhotoObject*)photo progress:(void (^)(NSProgress * uploadProgress))progressBlock finshBlock:(void (^)(id result, NSError *error))block
{
    return [self uploadApiRequest:@"CheniueDaHuo/uploadimageforios.html" imageData:photo parameters:parameters progress:progressBlock finshBlock:block];
}
@end
