//
//  PhotoObject.h
//  dahuozu
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 cheniue. All rights reserved.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImageInfoObject.h"
typedef NS_ENUM(NSInteger, PhotoType)
{
    PhotoTypeAsset = 0,
    PhotoTypeWeb = 1,
    PhotoTypeLocation = 2,
    PhotoTypeToken = 3,
};
typedef PhotoType PhotoType;

@interface PhotoObject : NSObject

-(instancetype)initWithAsset:(ALAsset*)asset;

-(instancetype)initWithImage:(UIImage*)image;

-(instancetype)initWithFile:(NSString*)filePath;

-(instancetype)initWithURL:(NSString*)urlPath;

//小图
@property(nonatomic,strong)UIImage *smallImage;
//满屏图
@property(nonatomic,strong)UIImage *fullImage;
//文件保存后的URL
@property(nonatomic,strong)NSURL *fileURL;
//文件路径
@property(nonatomic,strong)NSString *filePath;
//文件网络路径
@property(nonatomic,strong)NSString *urlPath;
//是否已存在文件
@property(nonatomic,assign)BOOL haveLoad;
//图片类型
@property(nonatomic,assign)PhotoType type;
//图片的标识
@property(nonatomic,assign)NSInteger indexMark;

@end

#pragma clang diagnostic pop
