//
//  CRLoadView.h
//  dahuozu
//
//  Created by apple on 16/1/23.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRLoadView : UIImageView
-(void)startLoading;
-(void)endLoading;
-(instancetype)initWithFrame:(CGRect)frame color:(UIColor*)color;
@end
