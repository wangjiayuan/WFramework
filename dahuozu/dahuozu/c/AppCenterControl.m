//
//  AppCenterControl.m
//  dahuozu
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "AppCenterControl.h"

@implementation AppCenterControl
+(NSString*)activityTableName
{
    static NSString *activity_table_name;
    if (activity_table_name==nil)
    {
        activity_table_name = [NSString stringWithFormat:@"Activity_%@",[DeviceControl getAppVersion]];
    }
    return activity_table_name;
}
+(NSString*)shareTableName
{
    static NSString *share_table_name;
    if (share_table_name==nil)
    {
        share_table_name = [NSString stringWithFormat:@"Share_%@",[DeviceControl getAppVersion]];
    }
    return share_table_name;
}
+(NSString*)userTableName
{
    static NSString *user_table_name;
    if (user_table_name==nil)
    {
        user_table_name = [NSString stringWithFormat:@"User_%@",[DeviceControl getAppVersion]];
    }
    return user_table_name;
}
+(NSString *)imageTableName
{
    static NSString *image_table_name;
    if (image_table_name==nil)
    {
        image_table_name = [NSString stringWithFormat:@"Image_%@",[DeviceControl getAppVersion]];
    }
    return image_table_name;
}
+(void)startWork
{
    [self createDataSqlitTable];
}
+(void)createDataSqlitTable
{
    [[DBWorker defaultWorker] createTableWithTableName:[self imageTableName] columeNames:@[@"file_path",@"activity_id",@"url_path",@"width",@"height",@"type",@"share_id",@"user_id"] primaryKey:nil];
    [[DBWorker defaultWorker] createTableWithTableName:[self activityTableName] columeNames:@[@"activity_content",@"activity_id",@"address_describe",@"b_time",@"begin_time",@"canjia_count",@"chufa_city",@"city",@"create_time",@"end_time",@"full_begin_time",@"func_type",@"latitude",@"longitude",@"minutes",@"minutesw",@"people_number",@"pinglun",@"praise",@"read_num",@"renzheng",@"status2",@"title",@"title_pic",@"type_title",@"user_id"] primaryKey:@"activity_id"];
    [[DBWorker defaultWorker] createTableWithTableName:[self userTableName] columeNames:@[@"head_pic",@"identity",@"identity_img_front",@"integral",@"name",@"nick_name",@"openid",@"phone",@"sex",@"signature",@"status",@"user_id",@"user_latitude",@"user_longitude"] primaryKey:@"user_id"];
}
@end
