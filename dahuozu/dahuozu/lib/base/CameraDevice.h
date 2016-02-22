//
//  CameraDevice.h
//  自定义相机
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <ImageIO/ImageIO.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>

@interface CameraDevice : NSObject

#pragma mark 初始化一个照相机

+(instancetype)deviceWithView:(UIView*)showView;

//是否在捕捉场景
-(BOOL)inCatch;

//是否前置摄像头
@property(nonatomic,assign)BOOL isFront;
//闪光灯模式
@property(nonatomic,assign)NSInteger lightModel;//0自动1开2关
#pragma mark 开始
-(void)start;
#pragma mark 结束
-(void)stop;
#pragma mark 拍照
-(void)takePhoto:(void (^)(UIImage *image))work;

@end
