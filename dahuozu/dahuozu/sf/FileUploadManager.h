//
//  FileUploadManager.h
//  dahuozu
//
//  Created by apple on 16/1/7.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "PhotoObject.h"

@interface FileUploadManager : AFHTTPSessionManager
#pragma mark 上传图片
+(NSURLSessionDataTask *)uploadApiRequest:(NSString*)subURL imageData:(PhotoObject*)photo parameters:(NSDictionary*)parameters progress:(void (^)(NSProgress * uploadProgress))progressBlock finshBlock:(void (^)(id result, NSError *error))block;
#pragma mark 辰悦搭伙族上传图片
+(NSURLSessionDataTask *)uploadDahuozuApiRequest:(NSDictionary*)parameters imageData:(PhotoObject*)photo progress:(void (^)(NSProgress * uploadProgress))progressBlock finshBlock:(void (^)(id result, NSError *error))block;
@end
