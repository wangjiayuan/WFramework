//
//  AppCenterControl.h
//  dahuozu
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int,ImageForType)
{
    ImageForActivity = 0,
    ImageForShare = 1,
    ImageForUser = 2,
};

@interface AppCenterControl : NSObject
+(NSString*)activityTableName;
+(NSString*)shareTableName;
+(NSString*)userTableName;
+(NSString*)imageTableName;
+(void)startWork;
@end
