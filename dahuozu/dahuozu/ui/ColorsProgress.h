//
//  ColorsProgress.h
//  dahuozu
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface ColorsProgress : UIView
-(id)initWithFrame:(CGRect)frame colors:(NSArray*)colors;
-(void)setPercent:(CGFloat)percent;
-(void)beginLoadAnimation;
-(void)endLoadAnimation;
@end
