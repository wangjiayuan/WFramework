//
//  BaseDataModel.m
//  dahuozu
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "BaseDataModel.h"

@implementation WebImageInfo

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.height = [UIScreen mainScreen].bounds.size.width;
        self.width = [UIScreen mainScreen].bounds.size.height;
        self.image_pic = @"";
    }
    return self;
}

@end

@implementation BaseDataModel
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.shouldCalculation = YES;
        self.shouldCalculationLandscape = YES;
        self.height = 0.0f;
        self.heightLandscape  =0.0f;
    }
    return self;
}
@end
