//
//  CustomerTabBar.h
//  dahuozu
//
//  Created by apple on 16/1/20.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaHuoTabBarButton.h"
@interface CustomerTabBar : UIView
@property(nonatomic,strong,readonly)NSMutableArray *items;
-(instancetype)initWithItemsCount:(NSInteger)count customerTitle:(BOOL)have;
-(DaHuoTabBarButton*)buttonAtIndex:(NSInteger)index;
-(NSInteger)indexForButton:(DaHuoTabBarButton*)button;
@property(nonatomic,assign)NSInteger selectedIndex;
@end
