//
//  QBImagePickerThumbnailView.h
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/31.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface QBImagePickerThumbnailView : UIView

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

@end

#pragma clang diagnostic pop
