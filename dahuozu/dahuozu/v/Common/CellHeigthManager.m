//
//  CellHeigthManager.m
//  自动布局
//
//  Created by apple on 15/12/3.
//  Copyright © 2015年 cheniue. All rights reserved.
//

#import "CellHeigthManager.h"

@implementation CellHeigthManager
const static NSMutableDictionary *default_manager_data;
+(NSString*)reuseIdentifierForClass:(Class)aclass type:(NSInteger)type
{
    NSString *reuseIdentifier = [NSStringFromClass(aclass) stringByAppendingFormat:@"__%ld",(long)type];
    return reuseIdentifier;
}
+(void)initialize
{
    [super initialize];
    if (!default_manager_data)
    {
        default_manager_data = [[NSMutableDictionary alloc]initWithCapacity:0];
    }
}
+(void)manageClass:(Class)aclass
{
    [self manageClass:aclass type:0];
}
+(void)manageClass:(Class)aclass type:(NSInteger)type
{
    id cell = [[aclass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self reuseIdentifierForClass:aclass type:type]];
    [self manageClass:aclass type:type withDefaultCell:cell];
}
+(void)manageClass:(Class)aclass type:(NSInteger)type withDefaultCell:(UITableViewCell*)cell
{
    NSString *reuseIdentifier = [self reuseIdentifierForClass:aclass type:type];
    [default_manager_data setValue:cell forKey:reuseIdentifier];
}
+(UITableViewCell *)onlyCellForClass:(Class)aclass type:(NSInteger)type inTableView:(UITableView*)tableView setBlock:(void(^)(id cell))block
{
    if (aclass==nil)
    {
        return nil;
    }
    NSString *reuseIdentifier = [self reuseIdentifierForClass:aclass type:type];
    if ([default_manager_data valueForKey:reuseIdentifier]==nil)
    {
        id cell = [[aclass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [default_manager_data setValue:cell forKey:reuseIdentifier];
    }
    UITableViewCell *cell = [default_manager_data valueForKey:reuseIdentifier];
    if (tableView!=nil)
    {
        [cell setFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
        [cell.contentView setFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
    }
    if (block!=nil)
    {
        block(cell);
        [cell layoutSubviews];
//        [cell updateConstraints];
    }
    return cell;
}

+(UITableViewCell *)onlyCellForClass:(Class)aclass inTableView:(UITableView*)tableView setBlock:(void(^)(id cell))block
{
    return [self onlyCellForClass:aclass type:0 inTableView:tableView setBlock:block];
}
+(UITableViewCell *)onlyCellForClass:(Class)aclass inTableView:(UITableView*)tableView
{
    return [self onlyCellForClass:aclass inTableView:tableView setBlock:nil];
}
+(CGFloat)heightForClass:(Class)aclass inTableView:(UITableView*)tableView
{
    return [self heightForClass:aclass inTableView:tableView setBlock:nil];
}
+(CGFloat)heightForClass:(Class)aclass type:(NSInteger)type inTableView:(UITableView*)tableView
{
    UITableViewCell *cell = [self onlyCellForClass:aclass type:type inTableView:tableView setBlock:nil];
    return [self heightForCell:cell];
}
+(CGFloat)heightForClass:(Class)aclass type:(NSInteger)type inTableView:(UITableView*)tableView setBlock:(void(^)(id cell))block
{
    UITableViewCell *cell = [self onlyCellForClass:aclass type:type inTableView:tableView setBlock:block];
    return [self heightForCell:cell];
}
+(CGFloat)heightForClass:(Class)aclass inTableView:(UITableView*)tableView setBlock:(void(^)(id cell))block
{
    UITableViewCell *cell = [self onlyCellForClass:aclass inTableView:tableView setBlock:block];
    return [self heightForCell:cell];
}
+(CGFloat)heightForCell:(UITableViewCell*)cell
{
    CGFloat height = 0.0f;
    for (UIView *view in cell.subviews)
    {
        height = MAX(view.frame.origin.y+view.frame.size.height, height);
    }
    for (UIView *view in cell.contentView.subviews)
    {
        height = MAX(view.frame.origin.y+view.frame.size.height+cell.contentView.frame.origin.y, height);
    }
    return height;
}
+(UITextView*)textView
{
    static UITextView *_textView;
    if (!_textView)
    {
        _textView = [UITextView new];
    }
    return _textView;
}
@end
