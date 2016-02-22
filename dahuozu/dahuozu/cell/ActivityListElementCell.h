//
//  ActivityListElementCell.h
//  dahuozu
//
//  Created by apple on 15/12/14.
//  Copyright © 2015年 dahuozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellHeigthManager.h"
#import "ActivitySimpleModel.h"
@interface ActivityListElementCell : UITableViewCell

-(instancetype)initWithImage:(BOOL)haveImage reuseIdentifier:(NSString *)reuseIdentifier;

-(void)setData:(ActivitySimpleModel*)model;

@end
