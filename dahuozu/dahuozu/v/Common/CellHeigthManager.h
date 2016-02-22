//
//  CellHeigthManager.h
//  自动布局
//
//  Created by apple on 15/12/3.
//  Copyright © 2015年 cheniue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CellHeigthManager : NSObject
+(UITableViewCell *)onlyCellForClass:(Class)aclass inTableView:(UITableView*)tableView;
+(UITableViewCell *)onlyCellForClass:(Class)aclass inTableView:(UITableView*)tableView setBlock:(void(^)(id cell))block;
+(CGFloat)heightForCell:(UITableViewCell*)cell;
+(CGFloat)heightForClass:(Class)aclass inTableView:(UITableView*)tableView setBlock:(void(^)(id cell))block;
+(CGFloat)heightForClass:(Class)aclass inTableView:(UITableView*)tableView;
+(CGFloat)heightForClass:(Class)aclass type:(NSInteger)type inTableView:(UITableView*)tableView;
+(CGFloat)heightForClass:(Class)aclass type:(NSInteger)type inTableView:(UITableView*)tableView setBlock:(void(^)(id cell))block;
+(NSString*)reuseIdentifierForClass:(Class)aclass type:(NSInteger)type;
+(void)manageClass:(Class)aclass;
+(void)manageClass:(Class)aclass type:(NSInteger)type;
+(void)manageClass:(Class)aclass type:(NSInteger)type withDefaultCell:(UITableViewCell*)cell;
+(UITextView*)textView;
@end
