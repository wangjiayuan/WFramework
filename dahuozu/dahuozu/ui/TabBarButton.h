//
//  TabBarButton.h
//  dahuozu
//
//  Created by apple on 16/1/20.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "ChooseButton.h"

@interface TabBarButton : ChooseButton
@property(nonatomic,strong,readonly)UILabel *badgeValueLabel;
@property(nonatomic,assign)int badgeValue;
-(void)setSelectedImage:(UIImage*)selectedImage disselectedImage:(UIImage*)disselectedImage;
-(void)setSelectedTitleColor:(UIColor*)selectedTitleColor disselectedTitleColor:(UIColor*)disselectedTitleColor;
+(TabBarButton*)tabBarButton:(BOOL)customerTitle;
@end
