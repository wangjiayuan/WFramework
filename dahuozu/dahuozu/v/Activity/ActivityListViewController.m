//
//  AvtivityListViewController.m
//  dahuozu
//
//  Created by apple on 16/1/19.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "ActivityListViewController.h"
#import "ActivityListDelegate.h"
@interface ActivityListViewController ()
{
    BaseTableView *activityListView;
    ActivityListDelegate *listDelegate;
}
@end

@implementation ActivityListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTableView];
}
#pragma mark 创建列表视图
-(void)createTableView
{
    activityListView = [BaseTableView new];
    [self.view addSubview:activityListView];
    listDelegate = [[ActivityListDelegate alloc]init];
    [activityListView setDataSource:listDelegate];
    [activityListView setDelegate:self];
    [activityListView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [activityListView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [activityListView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset: 64.0f];
    [activityListView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-49.0f];
}
#pragma mark 视图第一次将要呈现时请求用户位置
-(void)firstWillAppear
{
    [super firstDidAppear];
    [[DeviceControl centerController] locationUserPoint];
    
}

#pragma mark 当获取地图经纬度时
-(void)getUserLocation:(CLLocationCoordinate2D)coord
{
    [[DeviceControl centerController] getAddressWithLocation:coord];
}
#pragma mark 当解析到地图信息时执行
-(void)getAddressInfo:(NSDictionary *)addressInfo location:(CLLocationCoordinate2D)coord
{
    BaiduAddress *address = [[BaiduAddress alloc]initWithDictionary:addressInfo];
    [address saveBaiduAddressForKey:USER_LOCATION_ADDRESS];
    
    MyDataLog(@"用户当前位置：%@",address);
}

#pragma mark 取消地图信息监控
-(void)functionInDealloc
{
    [self listenLocationResult:NO];
}
#pragma mark 注册地图信息监控
-(void)functionInInit
{
    [self listenLocationResult:YES];
}

#pragma mark 响应TableView的交互事件
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [activityListView scrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([activityListView needDownRefreshAfterEndDragging])
    {
        [listDelegate.dataList removeAllObjects];
        [activityListView reloadData];
        Weak__(activityListView);
        Weak__(self);
        [activityListView downRefreshRequest:^(id tb)
         {
             [RequestSender getActivityListData:@{@"rows":@"20",@"page":@"0"} finshBlock:^(NSArray *listData, RequestResponseResultType state) {
                 MyDataLog(@"数据：\n%@",listData);
                 Strong__(BaseTableView, activityListView);
                 Strong__(ActivityListViewController, self);
                 UPDATE_UI_ASYNC(
                 {
                     [strongself setModelHeight:listData];
                     [strongactivityListView endDownRefresh];
                     [listDelegate.dataList addObjectsFromArray:listData];
                     [strongactivityListView reloadData];
                 })
             }];
         }];
    }
    else if ([activityListView needUpRefreshAfterEndDragging])
    {
        Weak__(activityListView);
        Weak__(self);
        [activityListView upRefreshRequest:^(id tb)
         {
             [RequestSender getActivityListData:@{@"rows":@"20",@"page":@"19"} finshBlock:^(NSArray *listData, RequestResponseResultType state) {
                 MyDataLog(@"数据：\n%@",listData);
                 Strong__(BaseTableView, activityListView);
                 Strong__(ActivityListViewController, self);
                 UPDATE_UI_ASYNC(
                 {
                     [strongself setModelHeight:listData];
                     [strongactivityListView endUpRefresh];
                     [listDelegate.dataList addObjectsFromArray:listData];
                     [strongactivityListView reloadData];
                 })
             }];
         }];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivitySimpleModel *model = [listDelegate.dataList objectAtIndex:indexPath.row];
    return model.height;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivitySimpleModel *model = listDelegate.dataList[indexPath.row];
    [(ActivityListElementCell*)cell setData:model];
}
#pragma mark 计算高度
-(void)setModelHeight:(NSArray*)models
{
    for (ActivitySimpleModel *model in models)
    {
        if ([model.imageList count]>0)
        {
            CGFloat height = [CellHeigthManager heightForClass:[ActivityListElementCell class] type:1 inTableView:activityListView setBlock:^(id cell) {
                
                [cell setData:model];
            }];
            model.height = height;
        }
        else
        {
            CGFloat height = [CellHeigthManager heightForClass:[ActivityListElementCell class] type:0 inTableView:activityListView setBlock:^(id cell) {
                
                [cell setData:model];
            }];
            model.height = height;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
