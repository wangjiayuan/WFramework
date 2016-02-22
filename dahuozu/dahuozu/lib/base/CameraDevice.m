//
//  CameraDevice.m
//  自定义相机
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "CameraDevice.h"

@interface CameraDevice ()

//AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
@property (nonatomic, strong) AVCaptureSession  * session;
//AVCaptureDeviceInput对象是输入流
@property (nonatomic, strong) AVCaptureDeviceInput * videoInput;
//照片输出流对象，当然我的照相机只有拍照功能，所以只需要这个对象就够了
@property (nonatomic, strong) AVCaptureStillImageOutput * stillImageOutput;
//预览图层，来显示照相机拍摄到的画面
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * previewLayer;
//放置预览图层的View
@property (nonatomic, weak) UIView * cameraShowView;

@end


@implementation CameraDevice

+(instancetype)deviceWithView:(UIView*)showView
{
    CameraDevice *device = [[CameraDevice alloc]init];
    [device setCameraShowView:showView];
    [device initialSession];
    [device setUpCameraLayer];
    [device setLightModel:0];
    return device;
}

-(void)dealloc
{
    [self.session removeInput:self.videoInput];
    [self.session removeOutput:self.stillImageOutput];
    self.session = nil;
    self.videoInput = nil;
    self.stillImageOutput = nil;
    [self.previewLayer removeFromSuperlayer];
    self.previewLayer = nil;
}

#pragma mark 初始化对象
- (void) initialSession
{
    //这个方法的执行我放在init方法里了
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:nil];
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    //这是输出流的设置参数表示以JPEG的图片格式输出图片
    
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput])
    {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput])
    {
        [self.session addOutput:self.stillImageOutput];
    }
    
}
#pragma mark 获取摄像头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position)
        {
            return device;
        }
    }
    return nil;
}

#pragma mark 获取前摄像头
- (AVCaptureDevice *)frontCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

#pragma mark 获取后摄像头
- (AVCaptureDevice *)backCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}
#pragma mark 初始化预览图层
- (void)setUpCameraLayer
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(status != AVAuthorizationStatusAuthorized)
    {
        return;
    }
    
    if (self.previewLayer == nil)
    {
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        
        UIView * view = self.cameraShowView;
        CALayer * viewLayer = [view layer];
        [viewLayer setMasksToBounds:YES];
        
        CGRect bounds = [view bounds];
        [self.previewLayer setFrame:bounds];
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
        
        [viewLayer insertSublayer:self.previewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
        
    }
}

#pragma mark 切换前后镜头
-(void)setIsFront:(BOOL)isFront
{
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    
    _isFront = isFront;
    
    if (cameraCount > 1)
    {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput;
        
        AVCaptureDevicePosition position = [[_videoInput device] position];
        
        if (position == AVCaptureDevicePositionBack && _isFront)
        {
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
        }
        else if (position == AVCaptureDevicePositionFront && !isFront)
        {
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:&error];
        }
        else
        {
            return;
        }
        
        if (newVideoInput != nil)
        {
            [self.session beginConfiguration];
            [self.session removeInput:self.videoInput];
            
            if ([self.session canAddInput:newVideoInput])
            {
                [self.session addInput:newVideoInput];
                [self setVideoInput:newVideoInput];
            }
            else
            {
                [self.session addInput:self.videoInput];
            }
            [self.session commitConfiguration];
        }
        else if (error)
        {
            NSLog(@"切换镜头失败, 错误信息: %@", error);
        }
    }
}
#pragma mark 是否在捕捉场景
-(BOOL)inCatch
{
    if (!self.session)
    {
        return NO;
    }
    return self.session.isRunning;
}
#pragma mark 设置闪光灯模式
-(void)setLightModel:(NSInteger)lightModel
{
    _lightModel = lightModel;
    
    switch (_lightModel)
    {
        case 1://开
        {
            AVCaptureDevice *camera = [self backCamera];
            if ([camera hasFlash])
            {
                if ([camera lockForConfiguration:nil])
                {
                    if ([camera isFlashModeSupported:AVCaptureFlashModeOn])
                    {
                        [camera setFlashMode:AVCaptureFlashModeOn];
                    }
                    [camera unlockForConfiguration];
                }
            }
        }
            break;
        case 2://关
        {
            AVCaptureDevice *camera = [self backCamera];
            if ([camera hasFlash])
            {
                if ([camera lockForConfiguration:nil])
                {
                    if ([camera isFlashModeSupported:AVCaptureFlashModeOff])
                    {
                        [camera setFlashMode:AVCaptureFlashModeOff];
                    }
                    [camera unlockForConfiguration];
                }
            }
        }
            break;
        default://自动
        {
            AVCaptureDevice *camera = [self backCamera];
            if ([camera hasFlash])
            {
                if ([camera lockForConfiguration:nil])
                {
                    if ([camera isFlashModeSupported:AVCaptureFlashModeAuto])
                    {
                        [camera setFlashMode:AVCaptureFlashModeAuto];
                    }
                    [camera unlockForConfiguration];
                }
            }
        }
            break;
    }
}

#pragma mark 开始
-(void)start
{
    if (self.session)
    {
        [self.session startRunning];
    }
}
#pragma mark 结束
-(void)stop
{
    if (self.session)
    {
        [self.session stopRunning];
    }
}
#pragma mark 拍照
-(void)takePhoto:(void (^)(UIImage *image))work
{
    AVCaptureConnection * videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection)
    {
        if (work != NULL)
        {
            work(nil);
        }
        return;
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
    {
        if (imageDataSampleBuffer == NULL)
        {
            if (work != NULL)
            {
                work(nil);
            }
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage * image = [UIImage imageWithData:imageData];
        if (work != NULL)
        {
            work(image);
        }
    }];
}
@end
