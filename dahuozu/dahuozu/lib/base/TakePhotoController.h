//
//  TakePhotoController.h
//  自定义相机
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoObject.h"

@protocol TakePhotoDelegate <NSObject>

@optional

-(void)takePhoto:(PhotoObject*)photo doneState:(NSInteger)state;

@end

@interface TakePhotoController : UIViewController

@property(nonatomic,weak)id<TakePhotoDelegate> delegate;

@end
