//
//  MyViewController.m
//  TravelProgram
//
//  Created by wjymac on 14-10-29.
//  Copyright (c) 2014年 wjymac. All rights reserved.
//

#import "NetViewController.h"

@interface NetViewController ()
{
    NSCache *DownLoadImage;////出现的全部图片
    NSOperationQueue *UpdateUIqueue;////数据更新队列
    NSOperationQueue *GetImagequeue;////获取图片队列
    NSInteger maxDownLoad;//////最大的并发下载数
    NSInteger maxUpdate;//////最大的视图更新并发数
}
@end
#define LoadTarget (@"_DownLoadImage_wang")
#define NoUrlDown (@"NoImage")
@implementation NetViewController

#pragma mark 创建空白Cell
-(UITableViewCell*)createCell:(NSString*)identifier
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
#pragma mark 重载父类方法并初始化
-(void)awakeFromNib
{
    [super awakeFromNib];
    //////////初始化保存图片的对象下载和更新的最大并发数和队列
    maxDownLoad = 1;
    maxUpdate = 1;
    DownLoadImage = [DataFunction imageData];
    UpdateUIqueue = [[NSOperationQueue alloc]init];
    [UpdateUIqueue setMaxConcurrentOperationCount:maxUpdate];
    GetImagequeue = [[NSOperationQueue alloc]init];
    [GetImagequeue setMaxConcurrentOperationCount:maxDownLoad];
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        //////////初始化保存图片的对象下载和更新的最大并发数和队列
        maxDownLoad = 1;
        maxUpdate = 1;
        DownLoadImage = [DataFunction imageData];
        UpdateUIqueue = [[NSOperationQueue alloc]init];
        [UpdateUIqueue setMaxConcurrentOperationCount:maxUpdate];
        GetImagequeue = [[NSOperationQueue alloc]init];
        [GetImagequeue setMaxConcurrentOperationCount:maxDownLoad];
        _indexMark = NSNotFound;
    }
    return self;
}
#pragma mark 设置最大更新数目
-(void)setMaxUpdateCount:(NSInteger)count
{
    maxUpdate = count;
    [UpdateUIqueue setMaxConcurrentOperationCount:maxUpdate];
}
#pragma mark 设置最大网络图片下载数目
-(void)setMaxDownLoadCount:(NSInteger)count
{
    maxDownLoad = count;
    [UpdateUIqueue setMaxConcurrentOperationCount:maxDownLoad];
}
/*
 ******************
 参数：
 描述：初始化手势
 结果：
 ******************
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)dealloc
{
    MyMemoryLog(@"视图控制器：%@销毁内存了",self);
}
#pragma mark 加入图片下载队列
-(void)insertToDownload:(NSURL*)url forImageView:(id)imageView
{
    if ([DownLoadImage objectForKey:[url absoluteString]]!=nil)
    {
        return;
    }
    [DownLoadImage setObject:[NSNumber numberWithBool:NO] forKey:[url absoluteString]];
    
    UIImage *cacheImage = [DataFunction getCacheImageFile:[url absoluteString]];
    
    if ([cacheImage isKindOfClass:[UIImage class]])
    {
        [DownLoadImage setObject:cacheImage forKey:[url absoluteString]];
        [imageView setImage:cacheImage];
        return;
    }
    
    
    NSInvocationOperation *request = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(requestImage:) object:url];
    NetViewController * __weak weakself = self;
    NSInvocationOperation * __weak weakrequest = request;
    
    [request setCompletionBlock:^
     {
         NSData *data = [weakrequest result];
         NSString *key = [url absoluteString];
         NSDictionary *updateInfo = [NSDictionary dictionaryWithObjectsAndKeys:url,@"url",imageView,@"imageView",data,@"data",key,@"key",nil];
         [weakself performSelectorOnMainThread:@selector(setSimpleImage:) withObject:updateInfo waitUntilDone:YES];
     }];
    
    [GetImagequeue addOperation:request];
}
#pragma mark 获取一张图片
-(NSData*)requestImage:(NSURL*)url
{
    NSData *data = [NSData dataWithContentsOfURL:url];
    return data;
}
#pragma mark 解读更新信息
-(void)processSingerImageViewImageInfo:(NSDictionary*)updateInfo
{
    NSData *data = [updateInfo valueForKey:@"data"];
    NSString *key = [updateInfo valueForKey:@"key"];
    UIImage *tempImage = [DataFunction saveImageDataFile:data key:key];
    if (!tempImage)
    {
        [DownLoadImage setObject:[NSNumber numberWithBool:NO] forKey:key];
    }
    else
    {
        [DownLoadImage setObject:tempImage forKey:key];
    }
}
#pragma mark 设置图片
-(void)setSimpleImage:(NSDictionary*)updateInfo
{
    NSInvocationOperation *oper = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(processSingerImageViewImageInfo:) object:updateInfo];
    __weak NetViewController *weakself = self;
    [oper setCompletionBlock:^
     {
         [weakself setSingerImageViewImage:updateInfo];
     }];
    [UpdateUIqueue addOperation:oper];
    
}
#pragma mark 给图片控件设置图片
-(void)setSingerImageViewImage:(NSDictionary*)updateInfo
{
    id imageView = [updateInfo valueForKey:@"imageView"];
    id url = [updateInfo valueForKey:@"url"];
    if (url&&[url isKindOfClass:[NSURL class]])
    {
        if (imageView)
        {
            UIImage *image = [self getImage:url];
            if ([image isKindOfClass:[UIImage class]])
            {
                if ([imageView isKindOfClass:[UIImageView class]])
                {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        [imageView setImage:image];
                    });
                }
                if ([imageView isKindOfClass:[UIButton class]])
                {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        [(UIButton*)imageView setImage:image forState:UIControlStateNormal];
                    });
                    
                }
                [imageView setNeedsDisplay];
            }
        }
    }
}
#pragma mark TableView的图片下载更新
-(void)insertToDownload:(NSURL*)url forTableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath otherWork:(SEL)work withObject:(id)object
{
    
    if ([DownLoadImage objectForKey:[url absoluteString]]!=nil)
    {
        return;
    }
    [DownLoadImage setObject:[NSNumber numberWithBool:NO] forKey:[url absoluteString]];
    
    UIImage *cacheImage = [DataFunction getCacheImageFile:[url absoluteString]];
    
    if ([cacheImage isKindOfClass:[UIImage class]])
    {
        [DownLoadImage setObject:cacheImage forKey:[url absoluteString]];
        
        if (tableView!=nil&&indexPath!=nil)
        {
            if ([tableView isKindOfClass:[UITableView class]]&&[indexPath isKindOfClass:[NSIndexPath class]])
            {
                if ([tableView cellForRowAtIndexPath:indexPath]!=nil&&tableView.dataSource!=nil)
                {
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }
        if (self!=nil)
        {
            if ([self respondsToSelector:work])
            {
                [self performSelectorOnMainThread:work withObject:object waitUntilDone:YES];
            }
        }
        return;
    }
    
    NSInvocationOperation *request = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(requestImage:) object:url];
    NetViewController * __weak weakself = self;
    NSInvocationOperation * __weak weakrequest = request;
    
    [request setCompletionBlock:^{
        NSData *data = [weakrequest result];
        NSString *key = [url absoluteString];
        NSMutableDictionary *updateInfo = [NSMutableDictionary dictionary];
        [updateInfo setValue:indexPath forKey:@"indexPath"];
        [updateInfo setValue:tableView forKey:@"tableView"];
        [updateInfo setValue:key forKey:@"key"];
        [updateInfo setValue:data forKey:@"data"];
        [updateInfo setValue:NSStringFromSelector(work) forKey:@"work"];
        [updateInfo setValue:object forKey:@"object"];
        [weakself performSelectorOnMainThread:@selector(addToReLoadQueue:) withObject:updateInfo waitUntilDone:YES];
    }];
    [GetImagequeue addOperation:request];
    
    
}
#pragma mark 更新视图
-(void)addToReLoadQueue:(NSDictionary*)tableViewInfo
{
    NSInvocationOperation *oper = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(processTableViewImageInfo:) object:tableViewInfo];
    __weak NetViewController *weakself = self;
    [oper setCompletionBlock:^{
        [weakself tableViewReloadData:tableViewInfo];
    }];
    [UpdateUIqueue addOperation:oper];
}
-(void)processTableViewImageInfo:(NSDictionary*)tableViewInfo
{
    NSData *data = [tableViewInfo valueForKey:@"data"];
    NSString *key = [tableViewInfo valueForKey:@"key"];
    UIImage *tempImage = [DataFunction saveImageDataFile:data key:key];
    if (!tempImage)
    {
        [DownLoadImage setObject:[NSNumber numberWithBool:NO] forKey:key];
    }
    else
    {
        [DownLoadImage setObject:tempImage forKey:key];
    }
    
    NetViewController * __weak weakself = self;
    SEL work = NSSelectorFromString([tableViewInfo valueForKey:@"work"]);
    id object = [tableViewInfo valueForKey:@"object"];
    if (self!=nil)
    {
        if ([weakself respondsToSelector:work])
        {
            [weakself performSelectorOnMainThread:work withObject:object waitUntilDone:YES];
        }
    }
}
-(void)tableViewReloadData:(NSDictionary*)tableViewInfo
{
    [self performSelectorOnMainThread:@selector(loadData:) withObject:tableViewInfo waitUntilDone:YES];
}
-(void)loadData:(NSDictionary*)tableViewInfo
{
    UITableView *tableView = [tableViewInfo valueForKey:@"tableView"];
    NSIndexPath *indexPath = [tableViewInfo valueForKey:@"indexPath"];
    if (tableView!=nil&&indexPath!=nil)
    {
        if ([tableView isKindOfClass:[UITableView class]]&&[indexPath isKindOfClass:[NSIndexPath class]])
        {
            if ([tableView cellForRowAtIndexPath:indexPath]!=nil&&tableView.dataSource!=nil)
            {
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
}
#pragma mark 获取图片
-(id)getImage:(id)path
{
    if ([path isKindOfClass:[NSURL class]])
    {
        NSString *key = [path absoluteString];
        return [DownLoadImage objectForKey:key];
    }
    if ([path isKindOfClass:[NSString class]])
    {
        return [DownLoadImage objectForKey:path];
    }
    return [DownLoadImage objectForKey:[[NSURL URLWithString:NoUrlDown] absoluteString]];
    return nil;
}
#pragma mark 清空队列和图片
-(void)superClearWork
{
    [UpdateUIqueue cancelAllOperations];
    [GetImagequeue cancelAllOperations];
}
#pragma mark 设置图片
-(BOOL)simpleImageView:(id)imageView setImagePath:(id)path withPlaceholder:(UIImage*)holderImage
{
    BOOL isHave = NO;
    id imageData = [self getImage:path];
    __weak id weakPath = path;
    __weak UIImageView *weakImageView = imageView;
    if (!imageData)
    {
        if ([imageView isKindOfClass:[UIImageView class]])
        {
            [imageView setImage:holderImage];
        }
        if ([imageView isKindOfClass:[UIButton class]])
        {
            [imageView setImage:holderImage forState:UIControlStateNormal];
        }
        if ([path isKindOfClass:[NSString class]])
        {
            [self insertToDownload:[NSURL URLWithString:weakPath] forImageView:weakImageView];
        }
        else if ([path isKindOfClass:[NSURL class]])
        {
            [self insertToDownload:weakPath forImageView:weakImageView];
        }
        else
        {
            [self insertToDownload:[NSURL URLWithString:NoUrlDown] forImageView:weakImageView];
        }
    }
    else
    {
        if ([imageData isKindOfClass:[UIImage class]])
        {
            if ([imageView isKindOfClass:[UIImageView class]])
            {
                [imageView setImage:imageData];
            }
            if ([imageView isKindOfClass:[UIButton class]])
            {
                [imageView setImage:imageData forState:UIControlStateNormal];
            }
            isHave = YES;
        }
        else
        {
            if ([imageView isKindOfClass:[UIImageView class]])
            {
                [imageView setImage:holderImage];
            }
            if ([imageView isKindOfClass:[UIButton class]])
            {
                [imageView setImage:holderImage forState:UIControlStateNormal];
            }
        }
    }
    return isHave;
}
-(BOOL)setImageView:(id)imageView withImagePath:(id)path withPalceImage:(UIImage*)place inTableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath useWork:(SEL)work withObject:(id)object
{
    BOOL isHave = NO;
    id imageData = [self getImage:path];
    __weak id weakPath = path;
    __weak UITableView *weakTableView = tableView;
    if (!imageData)
    {
        if ([imageView isKindOfClass:[UIImageView class]])
        {
            [imageView setImage:place];
        }
        if ([imageView isKindOfClass:[UIButton class]])
        {
            [imageView setImage:place forState:UIControlStateNormal];
        }
        if ([path isKindOfClass:[NSString class]])
        {
            [self insertToDownload:[NSURL URLWithString:weakPath] forTableView:weakTableView atIndexPath:indexPath otherWork:work withObject:object];
        }
        else if ([path isKindOfClass:[NSURL class]])
        {
            [self insertToDownload:weakPath forTableView:weakTableView atIndexPath:indexPath otherWork:work withObject:object];
        }
        else
        {
            [self insertToDownload:[NSURL URLWithString:NoUrlDown] forTableView:weakTableView atIndexPath:indexPath otherWork:work withObject:object];
        }
    }
    else
    {
        if ([imageData isKindOfClass:[UIImage class]])
        {
            if ([imageView isKindOfClass:[UIImageView class]])
            {
                [imageView setImage:imageData];
            }
            if ([imageView isKindOfClass:[UIButton class]])
            {
                [imageView setImage:imageData forState:UIControlStateNormal];
            }
            isHave = YES;
        }
        else
        {
            if ([imageView isKindOfClass:[UIImageView class]])
            {
                [imageView setImage:place];
            }
            if ([imageView isKindOfClass:[UIButton class]])
            {
                [imageView setImage:place forState:UIControlStateNormal];
            }
        }
    }
    return isHave;
}

#pragma mark 取消图片的下载
-(void)cancelImageDownLoad
{
    [GetImagequeue cancelAllOperations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [DownLoadImage removeAllObjects];
    MyDataLog(@"\\***************\n收到内存警告\\***************\n%@\\***************\n",self);
    // Dispose of any resources that can be recreated.
}
#pragma mark 获取操作次数标识
-(NSInteger)getIndexMark
{
    if (_indexMark==NSNotFound)
    {
        _indexMark = 0;
    }
    return _indexMark;
}
#pragma mark 增加次数标识
-(void)insertIndexMark
{
    _indexMark++;
    
    if (_indexMark>=NSIntegerMax)
    {
        _indexMark = 0;
    }
}
#pragma mark 网络请求相关的接口
#pragma mark 发送GET请求（有进度）
-(NSURLSessionDataTask *)getRequestApi:(NSString*)subURL parameters:(NSDictionary*)parameters progress:(void (^)(NSProgress * downloadProgress))progressBlock finshBlock:(void (^)(id result, NSError *error))block
{
    NSURLSessionDataTask *task = [[NetWorkManager sharedClient] getRequestApi:subURL parameters:parameters progress:progressBlock finshBlock:block];
    OnlyMarkObject *onlyMark = [OnlyMarkObject onlyMarkWithMark:subURL type:[self toTag] index:0];
    task.taskDescription = onlyMark.markDescription;
    return task;
}
#pragma mark 发送GET请求（没进度）
-(NSURLSessionDataTask *)getRequestApi:(NSString*)subURL parameters:(NSDictionary*)parameters finshBlock:(void (^)(id result, NSError *error))block
{
    return [self getRequestApi:subURL parameters:parameters progress:nil finshBlock:block];
}
#pragma mark 发送GET请求（没有参数）
-(NSURLSessionDataTask *)getRequestApi:(NSString*)subURL finshBlock:(void (^)(id result, NSError *error))block
{
    return [self getRequestApi:subURL parameters:nil progress:nil finshBlock:block];
}
#pragma mark 发送POST请求（有进度）
-(NSURLSessionDataTask *)postRequestApi:(NSString*)subURL parameters:(NSDictionary*)parameters progress:(void (^)(NSProgress * downloadProgress))progressBlock finshBlock:(void (^)(id result, NSError *error))block
{
    NSURLSessionDataTask *task = [[NetWorkManager sharedClient] postRequestApi:subURL parameters:parameters progress:progressBlock finshBlock:block];
    OnlyMarkObject *onlyMark = [OnlyMarkObject onlyMarkWithMark:subURL type:[self toTag] index:0];
    task.taskDescription = onlyMark.markDescription;
    return task;
}
#pragma mark 发送POST请求（没进度）
-(NSURLSessionDataTask *)postRequestApi:(NSString*)subURL parameters:(NSDictionary*)parameters finshBlock:(void (^)(id result, NSError *error))block
{
    return [self postRequestApi:subURL parameters:parameters progress:nil finshBlock:block];
}
#pragma mark 取消请求
-(void)cancelRequest:(NSString*)taskDescription
{
    [[NetWorkManager sharedClient] cancelRequest:taskDescription];
}
@end


