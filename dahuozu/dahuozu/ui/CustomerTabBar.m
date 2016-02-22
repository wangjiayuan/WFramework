//
//  CustomerTabBar.m
//  dahuozu
//
//  Created by apple on 16/1/20.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "CustomerTabBar.h"

@implementation CustomerTabBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithItemsCount:(NSInteger)count customerTitle:(BOOL)have
{
    self = [self initWithFrame:CGRectZero];
        
    _items = [NSMutableArray array];
    
    _selectedIndex = NSNotFound;
    
    if (self)
    {
        if (count>0)
        {
            for (NSInteger i=0; i<count; i++)
            {
                DaHuoTabBarButton *button = [DaHuoTabBarButton tabBarButton:have];
                [_items addObject:button];
                [self addSubview:button];
            }
            
            [_items autoMatchViewsDimension:ALDimensionWidth];
            
            [[_items firstObject] autoPinEdgeToSuperviewEdge:ALEdgeTop];
            [[_items firstObject] autoPinEdgeToSuperviewEdge:ALEdgeLeft];
            [[_items firstObject] autoPinEdgeToSuperviewEdge:ALEdgeBottom];
            
            UIView *previousView = nil;
            for (UIView *view in _items)
            {
                if (previousView)
                {
                    [view autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:previousView];
                    [view autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:previousView];
                    [view autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:previousView];
                }
                previousView = view;
            }
            
            [[_items lastObject] autoPinEdgeToSuperviewEdge:ALEdgeRight];
        }
    }
    
    return self;
}
-(DaHuoTabBarButton *)buttonAtIndex:(NSInteger)index
{
    if (index<0||index>=[_items count])
    {
        return nil;
    }
    return [_items objectAtIndex:index];
}
-(NSInteger)indexForButton:(DaHuoTabBarButton*)button
{
    if ([_items containsObject:button])
    {
        return [_items indexOfObject:button];
    }
    return NSNotFound;
}
-(void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (selectedIndex>=0&&selectedIndex<[_items count])
    {
        for (NSInteger i=0; i<_items.count; i++)
        {
            if (i==selectedIndex)
            {
                [[self buttonAtIndex:i] setHaveChoose:YES];
            }
            else
            {
                [[self buttonAtIndex:i] setHaveChoose:NO];
            }
        }
        _selectedIndex = selectedIndex;
    }
}
@end
