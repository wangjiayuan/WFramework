//
//  BaseDataModel.h
//  dahuozu
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface WebImageInfo : NSObject

@property(nonatomic,assign)CGFloat height;
@property(nonatomic,assign)CGFloat width;
@property(nonatomic,strong)NSString *image_pic;

@end

@interface BaseDataModel : NSObject
@property(nonatomic,assign)BOOL shouldCalculation;
@property(nonatomic,assign)CGFloat height;
@property(nonatomic,assign)BOOL shouldCalculationLandscape;
@property(nonatomic,assign)CGFloat heightLandscape;
@end
