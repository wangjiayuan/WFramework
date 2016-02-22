//
//  MyViewController.h
//  TravelProgram
//
//  Created by wjymac on 14-10-29.
//  Copyright (c) 2014年 wjymac. All rights reserved.
//基本的视图控制器

#import "EditViewController.h"
#import "FileUploadManager.h"
#import "NetWorkManager.h"

@interface NetViewController : EditViewController
<NetRequestFunction>

#pragma mark 将一张添加在TableView的图片加载到下载队列中
-(void)insertToDownload:(NSURL*)url forTableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath otherWork:(SEL)work withObject:(id)object;
#pragma mark 通过下载路径（key）获取图片
-(id)getImage:(id)path;
#pragma mark 设置最大同时更新数目
-(void)setMaxUpdateCount:(NSInteger)count;
#pragma mark 最大图片同时下载数目
-(void)setMaxDownLoadCount:(NSInteger)count;
#pragma mark 设置TableView上的图片
-(BOOL)setImageView:(id)imageView withImagePath:(id)path withPalceImage:(UIImage*)place inTableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath useWork:(SEL)work withObject:(id)object;
#pragma mark 设置一般的图片
-(BOOL)simpleImageView:(id)imageView setImagePath:(id)path withPlaceholder:(UIImage*)holderImage;
#pragma mark 清空队列和图片
-(void)superClearWork;

-(UITableViewCell*)createCell:(NSString*)identifier;

#pragma mark 操作次数标识
@property(nonatomic,assign,readonly)NSInteger indexMark;

#pragma mark 获取操作次数标识
-(NSInteger)getIndexMark;
#pragma mark 增加次数标识
-(void)insertIndexMark;

@end
