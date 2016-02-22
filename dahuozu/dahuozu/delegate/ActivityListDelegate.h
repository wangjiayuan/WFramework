//
//  ActivityListDelegate.h
//  dahuozu
//
//  Created by apple on 16/1/23.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityListElementCell.h"

@interface ActivityListDelegate : NSObject
<UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *dataList;
@end
