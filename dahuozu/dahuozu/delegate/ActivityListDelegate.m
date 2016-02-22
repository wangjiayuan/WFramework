//
//  ActivityListDelegate.m
//  dahuozu
//
//  Created by apple on 16/1/23.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "ActivityListDelegate.h"

@implementation ActivityListDelegate

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.dataList = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        ActivitySimpleModel *model = self.dataList[indexPath.row];
        
        if ([model.imageList count]>0)
        {
            ActivityListElementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityListElementImageCell"];
            if (!cell)
            {
                cell = [[ActivityListElementCell alloc]initWithImage:YES reuseIdentifier:@"ActivityListElementImageCell"];
            }
            return cell;
        }
        else
        {
            ActivityListElementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityListElementCell"];
            if (!cell)
            {
                cell = [[ActivityListElementCell alloc]initWithImage:NO reuseIdentifier:@"ActivityListElementCell"];
            }
            return cell;
        }
        
}

@end
