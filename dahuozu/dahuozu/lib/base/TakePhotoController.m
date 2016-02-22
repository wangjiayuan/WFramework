//
//  TakePhotoController.m
//  自定义相机
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "TakePhotoController.h"
#import "CameraDevice.h"
#import <CoreMotion/CoreMotion.h>

@interface TakePhotoController ()
{
    UIButton *cancelBtn;
    UIButton *doneBtn;
    UIButton *lightBtn;
    UIButton *frontBtn;
    UIButton *takeBtn;
    CameraDevice *photoDevice;
    NSInteger lightType;
    NSInteger isFront;
    UIImage *photoImage;
    UIImageView *showImageView;
    UIDeviceOrientation deviceOrientation;
    UIDeviceOrientation saveImageDeviceOrientation;
    BOOL navigationBarHide;
}
@end

@implementation TakePhotoController

static CMMotionManager *motionManager;
#pragma mark 类单例（感应器）
+(void)initialize
{
    [super initialize];
    if (motionManager==nil)
    {
        motionManager = [[CMMotionManager alloc]init];
    }
}
#pragma mark 获取设备方向
-(void)deviceCurrentInfoData:(CMAccelerometerData*)accelerometerData
{
    CGFloat x = accelerometerData.acceleration.x;
    
    CGFloat y = -accelerometerData.acceleration.y;
    
    CGFloat z = accelerometerData.acceleration.z;
    
    CGFloat device_angle = M_PI / 2.0f - atan2(y, x);
    
    UIDeviceOrientation orientation = UIDeviceOrientationUnknown;
    
    if (device_angle > M_PI)
    {
        device_angle -= 2 * M_PI;
    }
    
    if ((x < -0.60f) || (z > 0.60f))
    {
        
        if ( UIDeviceOrientationIsLandscape(deviceOrientation) )
        {
            orientation = deviceOrientation;
        }
        else
        {
            orientation = UIDeviceOrientationUnknown;
        }
        
    }
    else
    {
        
        if ( (device_angle >= -M_PI_4) && (device_angle <= M_PI_4) )
        {
            orientation = UIDeviceOrientationPortrait;
        }
        else if ((device_angle <= -M_PI_4) && (device_angle >= -3 * M_PI_4))
        {
            orientation = UIDeviceOrientationLandscapeLeft;
        }
        else if ((device_angle >= M_PI_4) && (device_angle <= 3 * M_PI_4))
        {
            orientation = UIDeviceOrientationLandscapeRight;
        }
        else
        {
            orientation = UIDeviceOrientationPortraitUpsideDown;
        }
        
    }
    if (orientation != deviceOrientation)
    {
        deviceOrientation = orientation;
    }
}
#pragma mark 控制器入口
- (void)viewDidLoad
{
    if (self.navigationController!=nil)
    {
        navigationBarHide = [self.navigationController isNavigationBarHidden];
    }
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    deviceOrientation = UIDeviceOrientationUnknown;
    // Do any additional setup after loading the view.
    [self setUpControlButton];
    
}
#pragma mark 创建拍照控制按钮
-(void)setUpControlButton
{
    showImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [showImageView setUserInteractionEnabled:YES];
    [self.view addSubview:showImageView];
    
    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(5.0f, 5.0f, 40.0f, 40.0f)];
    [cancelBtn setImageEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    [cancelBtn setImage:[UIImage imageNamed:@"cancle"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(exitPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setFrame:CGRectMake(self.view.frame.size.width-45.0f, 5.0f, 40.0f, 40.0f)];
    [doneBtn addTarget:self action:@selector(takePhotoDone) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setEnabled:NO];
    [doneBtn setImageEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    [doneBtn setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    [self.view addSubview:doneBtn];
    
    
    
    
    frontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [frontBtn setFrame:CGRectMake(self.view.frame.size.width/2.0f-20.0f, 5.0f, 40.0f, 40.0f)];
    isFront = NO;
    [frontBtn setImageEdgeInsets:UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 0.0f)];
    [frontBtn setImage:[UIImage imageNamed:@"front-camera"] forState:UIControlStateNormal];
    [frontBtn addTarget:self action:@selector(changeFront) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:frontBtn];
    
    
    lightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lightBtn setFrame:CGRectMake(5.0f, self.view.frame.size.height-70.0f, 40.0f, 40.0f)];
    lightType = 0;
    [lightBtn setImageEdgeInsets:UIEdgeInsetsMake(6.0f, 5.0f, 6.0f, 5.0f)];
    [lightBtn setImage:[UIImage imageNamed:@"flash-auto"] forState:UIControlStateNormal];
    [lightBtn addTarget:self action:@selector(changeLight) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lightBtn];
    
    
    takeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [takeBtn setFrame:CGRectMake(self.view.frame.size.width/2.0f-50.0f, self.view.frame.size.height-70.0f, 100.0f, 40.0f)];
    [takeBtn setBackgroundImage:[UIImage imageNamed:@"camera-button"] forState:UIControlStateNormal];
    [takeBtn setImageEdgeInsets:UIEdgeInsetsMake(6.0f, 35.0f, 6.0f, 35.0f)];
    [takeBtn setImage:[UIImage imageNamed:@"camera-icon"] forState:UIControlStateNormal];
    [takeBtn addTarget:self action:@selector(getPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takeBtn];
    
    
}
#pragma mark 选取照片结束
-(void)takePhotoDone
{
    if (self.delegate!=nil)
    {
        if ([self.delegate respondsToSelector:@selector(takePhoto:doneState:)])
        {
            if (photoImage==nil)
            {
                [self.delegate takePhoto:nil doneState:2];
            }
            else
            {
                switch (saveImageDeviceOrientation)
                {
                    case UIDeviceOrientationLandscapeLeft:
                    {
                        photoImage = [UIImage imageWithCGImage:photoImage.CGImage scale:1.0f orientation:UIImageOrientationUp];
                    }
                        break;
                    case UIDeviceOrientationLandscapeRight:
                    {
                        photoImage = [UIImage imageWithCGImage:photoImage.CGImage scale:1.0f orientation:UIImageOrientationDown];
                    }
                        break;
                    case UIDeviceOrientationPortraitUpsideDown:
                    {
                        photoImage = [UIImage imageWithCGImage:photoImage.CGImage scale:1.0f orientation:UIImageOrientationLeft];
                    }
                        break;
                    default:
                        break;
                }

                PhotoObject *photo = [[PhotoObject alloc]initWithImage:photoImage];
                
                [self.delegate takePhoto:photo doneState:0];
            }
        }
    }
    [self exitPage];
}
#pragma mark 前置后置摄像头改变
-(void)changeFront
{
    isFront = !isFront;
    [photoDevice setIsFront:isFront];
}
#pragma mark 改变闪光灯模式
-(void)changeLight
{
    ++lightType;
    lightType = lightType>2?0:lightType;
    lightType = lightType<0?0:lightType;
    switch (lightType)
    {
        case 0:
        {
            [lightBtn setImage:[UIImage imageNamed:@"flash-auto"] forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            [lightBtn setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [lightBtn setImage:[UIImage imageNamed:@"flash-off"] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    [photoDevice setLightModel:lightType];
}
#pragma amrk 退出页面
-(void)exitPage
{
    if (self.navigationController!=nil)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark 拍照
-(void)getPhoto
{
    if ([photoDevice inCatch])
    {
        TakePhotoController * __weak weakself = self;
        [photoDevice takePhoto:^(UIImage *image) {
            TakePhotoController * __strong strongself = weakself;
            [strongself saveImage:image];
        }];
    }
    else
    {
        [doneBtn setEnabled:NO];
        [showImageView setImage:nil];
        [photoDevice start];
    }
    
}
#pragma mark 展现拍照获得的图片
-(void)saveImage:(UIImage*)image
{
    photoImage = nil;
    photoImage = [image copy];
    [showImageView setImage:photoImage];
    saveImageDeviceOrientation = deviceOrientation;
    [photoDevice stop];
    [doneBtn setEnabled:YES];
}
#pragma mark 视图即将呈现隐藏导航和分页
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController!=nil)
    {
        [self.navigationController setNavigationBarHidden:YES];
    }

    [self setHidesBottomBarWhenPushed:YES];
}
#pragma mark 视图呈现开始工作初始化拍照设备
-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    TakePhotoController * __weak weakSelf = self;
    
    if ([motionManager isAccelerometerAvailable] == YES)
    {
        //所有的感应器都是通过类似方法工作的（设置更新时间间隔、开始状态更新）
        
        [motionManager setAccelerometerUpdateInterval:0.01f];
        [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error)
        {
            [weakSelf deviceCurrentInfoData:accelerometerData];
        }];
    }
    
    if (!photoDevice)
    {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(status == AVAuthorizationStatusAuthorized)
        {
            // authorized
            [self setUpDevice];
        }
        else if(status == AVAuthorizationStatusDenied)
        {
            // denied
            return ;
        }
        else if(status == AVAuthorizationStatusRestricted)
        {
            // restricted
        }
        else if(status == AVAuthorizationStatusNotDetermined)
        {
            // not determined
            TakePhotoController * __weak weakself = self;
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
             {
                 if(granted)
                 {
                     TakePhotoController * __strong strongself = weakself;
                     [strongself setUpDevice];
                 }
                 else
                 {
                     return;
                 }
             }];
        }
        
    }
    [photoDevice start];
}
#pragma mark 开始工作
-(void)setUpDevice
{
    photoDevice = [CameraDevice deviceWithView:self.view];
    [photoDevice start];
}
#pragma mark 视图即将消失暂停工作
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [photoDevice stop];
    
    if ([motionManager isAccelerometerActive] == YES)
    {
        [motionManager stopAccelerometerUpdates];
    }
    
    if (self.navigationController!=nil)
    {
        [self.navigationController setNavigationBarHidden:navigationBarHide];
    }
    
    [self setHidesBottomBarWhenPushed:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
