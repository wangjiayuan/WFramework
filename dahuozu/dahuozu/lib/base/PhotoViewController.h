//
//  PhotoUpLoadViewController.h
//  dahuozu
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "PanViewController.h"
#import "PhotoObject.h"
#import "QBImagePickerController.h"
#import "TakePhotoController.h"

@interface PhotoViewController : PanViewController
<QBImagePickerControllerDelegate,TakePhotoDelegate>
#pragma mark 从相册里面选择多张图片
-(void)choosePhoto:(NSInteger)min max:(NSInteger)max;
#pragma mark 从相册里面选择一张照片
-(void)choosePhotoImage;
#pragma mark 拍摄一张照片
-(void)takePhoto;
#pragma mark 选择照片完成
-(void)haveChoosePhotos:(nullable NSArray<__kindof PhotoObject *> *)photos;

@end
