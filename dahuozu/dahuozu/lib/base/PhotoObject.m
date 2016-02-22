//
//  PhotoObject.m
//  dahuozu
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 cheniue. All rights reserved.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#import "PhotoObject.h"

@implementation PhotoObject

-(instancetype)initWithAsset:(ALAsset*)asset
{
    self = [self init];
    if (self)
    {
        NSString *filePath = [DataFunction filePathForNSData:[asset valueForProperty:ALAssetPropertyAssetURL]];
        
        NSString *fileSaveKey = [filePath lastPathComponent];

        if (![DataFunction haveFileAtPath:filePath])//如果已保存存在但是绝对路径不相同（MD5加密出来的结果不同）
        {
            Byte *imageBuffer = (Byte*)malloc(asset.defaultRepresentation.size);
            NSUInteger bufferSize = [asset.defaultRepresentation getBytes:imageBuffer fromOffset:0.0 length:asset.defaultRepresentation.size error:nil];
            NSData *imageData = [NSData dataWithBytesNoCopy:imageBuffer length:bufferSize freeWhenDone:YES];
            [imageData writeToFile:filePath atomically:YES];
            UIImage *smallImage = [DataFunction saveImageDataFile:imageData key:fileSaveKey];
            self.smallImage = smallImage;
            self.fullImage = [ImageFunction imageWithData:imageData];
        }
        else
        {
            self.smallImage = [DataFunction getCacheImageFile:fileSaveKey];
            self.fullImage = [DataFunction getCacheFullImageFile:fileSaveKey];
        }
        self.fileURL = [NSURL fileURLWithPath:filePath];
        self.filePath = fileSaveKey;
        self.haveLoad = YES;
        self.type = PhotoTypeAsset;
    }
    return self;
}
-(instancetype)initWithImage:(UIImage *)image
{
    self = [self init];
    if (self)
    {
        NSString *filePath = [DataFunction filePathForJPGPhoto];
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
        [imageData writeToFile:filePath atomically:YES];
        UIImage *smallImage = [DataFunction saveImageDataFile:imageData key:filePath];
        self.smallImage = smallImage;
        self.fullImage = image;
        self.fileURL = [NSURL fileURLWithPath:filePath];
        self.filePath = filePath;
        self.haveLoad = YES;
        self.type = PhotoTypeToken;
    }
    return self;
}

-(instancetype)initWithFile:(NSString *)filePath
{
    self = [self init];
    if (self)
    {
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        UIImage *smallImage = [DataFunction saveImageDataFile:imageData key:filePath];
        self.smallImage = smallImage;
        self.fullImage = [UIImage imageWithContentsOfFile:filePath];
        self.fileURL = [NSURL fileURLWithPath:filePath];
        self.filePath = filePath;
        self.haveLoad = YES;
        self.type = PhotoTypeLocation;
    }
    return self;
}
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.haveLoad = NO;
        self.indexMark = NSNotFound;
    }
    return self;
}

-(instancetype)initWithURL:(NSString *)urlPath
{
    self = [self init];
    if (self)
    {
        if ([DataFunction haveSaveImage:urlPath])
        {
            self.smallImage = [DataFunction getCacheImageFile:urlPath];
            self.fullImage = [DataFunction getCacheFullImageFile:urlPath];
            self.filePath = [DataFunction fullFilePath:urlPath];
            self.fileURL = [NSURL fileURLWithPath:self.filePath];
            self.haveLoad = YES;
        }
        self.urlPath = urlPath;
        self.type = PhotoTypeWeb;
    }
    return self;
}

@end


#pragma clang diagnostic pop
