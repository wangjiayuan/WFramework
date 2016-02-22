//
//  ImageFunction.h
//  yueyishenghuo
//
//  Created by t on 15-3-10.
//  Copyright (c) 2015年 t. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImageIO/ImageIO.h>
@interface ImageFunction : NSObject
#pragma mark 图片压缩的方法（压缩到宽度等于屏幕分辨率）
+(UIImage *)decodedImageWithImage:(UIImage *)image;
#pragma mark 图片压缩的方法
+(UIImage *)decodedImageWithImage:(UIImage *)image toWidth:(CGFloat)newWidth;
#pragma mark 根据NSData生成图片
+ (UIImage *)imageWithData:(NSData *)data;
#pragma mark 判断是否为GIF图片
+(BOOL)watchIsGIF:(NSData*)data;
#pragma mark 获取静态图
+(UIImage*)staticImageFromData:(NSData*)data;
#pragma mark 图片旋转到正向方位返回
+(UIImage*)imageRotate:(UIImage*)image;
#pragma mark 获取某个视图的截图
+(UIImage*)imageFromView:(UIView*)view;
#pragma mark 获取屏幕截图
+(UIImage*)ScreenCopyImage;
////////////截取
+(UIImage*)imageFromImage:(UIImage*)image inRect:(CGRect)rect;
#pragma mark 颜色创建图片
+ (UIImage *)createImageWithColor:(UIColor *)color;
#pragma mark 改变图片大小
+(UIImage*)originImage:(UIImage *)image scaleToSize:(CGSize)size;
#pragma mark 创建动态图片数据
+(BOOL)createGifImage:(NSArray*)gifImages timesArray:(NSArray*)times toFilePath:(NSString*)filePath;
#pragma mark 旋转照片
+(UIImage*)rotateImage:(UIImage*)image toAngle:(CGFloat)angle;
@end

