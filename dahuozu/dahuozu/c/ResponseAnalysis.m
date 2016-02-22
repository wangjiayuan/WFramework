//
//  ResponseAnalysis.m
//  dahuozu
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "ResponseAnalysis.h"
#import "ActivityListElementCell.h"

@implementation ResponseAnalysis
#pragma mark 单例
+(ResponseAnalysis*)shareAnalysis
{
    static ResponseAnalysis *_shareAnalysis = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareAnalysis = [[ResponseAnalysis alloc]init];
    });
    
    return _shareAnalysis;
}
#pragma mark 解析保存活动列表数据
-(NSMutableArray*)saveActivityListResponse:(id)result
{
    NSArray *list = [result valueForKey:@"list"];
    
    NSMutableArray *activityResult = [NSMutableArray array];
    
    for (NSDictionary *activity in list)
    {
        NSString *activity_id = [NSString pargramText:[activity valueForKey:@"activity_id"]];
        NSString *user_id = [NSString pargramText:[activity valueForKey:@"user_id"]];
        if ([[DBWorker defaultWorker] rowCountBase:[AppCenterControl activityTableName] where:@{@"activity_id":activity_id}]>0)
        {
            [[DBWorker defaultWorker] updateToDBBase:[AppCenterControl activityTableName] rowData:activity where:@{@"activity_id":activity_id}];
        }
        else
        {
            [[DBWorker defaultWorker] insertBase:activity DBName:[AppCenterControl activityTableName]];
        }
        
        if ([[DBWorker defaultWorker] rowCountBase:[AppCenterControl userTableName] where:@{@"user_id":user_id}]>0)
        {
            [[DBWorker defaultWorker] updateToDBBase:[AppCenterControl userTableName] rowData:activity where:@{@"user_id":user_id}];
        }
        else
        {
            [[DBWorker defaultWorker] insertBase:activity DBName:[AppCenterControl userTableName]];
        }
        
        for(NSDictionary *image in [activity valueForKey:@"imageList"])
        {
            NSString *image_pic = [NSString pargramText:[image valueForKey:@"image_pic"]];
            CGFloat width = [[image valueForKey:@"width"] floatValue];
            CGFloat height = [[image valueForKey:@"height"] floatValue];
            NSString *type = [NSString stringWithFormat:@"%i",ImageForActivity];
            
            NSMutableDictionary *imageInfo = [NSMutableDictionary dictionary];
            [imageInfo setValue:activity_id forKey:@"activity_id"];
            [imageInfo setValue:image_pic forKey:@"url_path"];
            [imageInfo setValue:type forKey:@"type"];
            [imageInfo setValue:user_id forKey:@"user_id"];
            
            if (width>0&&height>0)
            {
                [imageInfo setValue:[NSString stringWithFormat:@"%.0f",width] forKey:@"width"];
                [imageInfo setValue:[NSString stringWithFormat:@"%.0f",height] forKey:@"height"];
            }
            
            if ([[DBWorker defaultWorker] rowCountBase:[AppCenterControl imageTableName] where:@{@"url_path":image_pic}]>0)
            {
                [[DBWorker defaultWorker] updateToDBBase:[AppCenterControl imageTableName] rowData:imageInfo where:@{@"url_path":image_pic}];
            }
            else
            {
                [[DBWorker defaultWorker] insertBase:imageInfo DBName:[AppCenterControl imageTableName]];
            }
        }
        ActivitySimpleModel *model = [[ActivitySimpleModel alloc]init];
        NSDictionary *activityInfo = [[[DBWorker defaultWorker] searchBase:[AppCenterControl activityTableName] where:@{@"activity_id":activity_id} orderBy:nil offset:0 count:1] resultAtIndex:0];
        NSDictionary *userInfo = [[[DBWorker defaultWorker] searchBase:[AppCenterControl userTableName] where:@{@"user_id":user_id} orderBy:nil offset:0 count:1] resultAtIndex:0];
        NSArray *imageListInfo = [[DBWorker defaultWorker] searchBase:[AppCenterControl imageTableName] where:@{@"activity_id":activity_id,@"user_id":user_id,@"type":[NSString stringWithFormat:@"%i",ImageForActivity]} orderBy:nil offset:0 count:INT16_MAX];
        //用户ID
        model.user_id = [NSString pargramText:[userInfo valueForKey:@"user_id"]];
        //活动描述
        model.activity_content = [NSString pargramText:[activityInfo valueForKey:@"activity_content"]];
        //活动ID
        model.activity_id = [NSString pargramText:[activityInfo valueForKey:@"activity_id"]];
        //目的地详情
        model.address_describe = [NSString pargramText:[activityInfo valueForKey:@"address_describe"]];
        //开始时间2016-01-20 16:04
        model.b_time = [NSString pargramText:[activityInfo valueForKey:@"b_time"]];
        //参加人数
        model.canjia_count = [[activityInfo valueForKey:@"canjia_count"] intValue];
        //出发城市
        model.chufa_city = [NSString pargramText:[activityInfo valueForKey:@"chufa_city"]];
        //目的城市
        model.city = [NSString pargramText:[activityInfo valueForKey:@"city"]];
        //创建时间2016-01-20 16:01:25
        model.create_time = [NSString pargramText:[activityInfo valueForKey:@"create_time"]];
        //结束时间
        model.end_time = [NSString pargramText:[activityInfo valueForKey:@"end_time"]];
        //与活动之间的关系
        model.func_type = [[activityInfo valueForKey:@"func_type"] integerValue];
        //发起人头像
        model.head_pic = [NSString pargramText:[activityInfo valueForKey:@"head_pic"]];
        //图片列表
        NSMutableArray *imageList = [NSMutableArray array];
        for (NSDictionary *imageInfo in imageListInfo)
        {
            WebImageInfo *image = [[WebImageInfo alloc]init];
            CGFloat width = [[imageInfo valueForKey:@"width"] floatValue];
            CGFloat height = [[imageInfo valueForKey:@"height"] floatValue];
            if (width>0&&height>0)
            {
                image.width = width;
                image.height = height;
            }
            NSString *url_path = [NSString pargramText:[imageInfo valueForKey:@"url_path"]];
            image.image_pic = url_path;
            [imageList addObject:image];
        }
        model.imageList = imageList;
        //纬度
        model.latitude = [[activityInfo valueForKey:@"latitude"] doubleValue];
        //经度
        model.longitude = [[activityInfo valueForKey:@"longitude"] doubleValue];
        //用户昵称
        model.nick_name = [NSString pargramText:[userInfo valueForKey:@"nick_name"]];
        //限制参加人数-1不限制
        model.people_number = [[activityInfo valueForKey:@"people_number"] intValue];
        //评论人数
        model.pinglun = [[activityInfo valueForKey:@"pinglun"] intValue];
        //收藏人数
        model.praise = [[activityInfo valueForKey:@"praise"] intValue];
        //阅读人数
        model.read_num = [[activityInfo valueForKey:@"read_num"] intValue];
        //是否实名认证参加
        model.renzheng = [[activityInfo valueForKey:@"renzheng"] integerValue];
        //用户性别
        
        if ([@"男" isEqualToString:[activityInfo valueForKey:@"sex"]])
        {
            model.sex = 0;
        }
        else if ([@"女" isEqualToString:[activityInfo valueForKey:@"sex"]])
        {
            model.sex = 1;
        }
        else
        {
            model.sex = [[activityInfo valueForKey:@"sex"] integerValue];
        }
        //发起者是否实名认证
        model.status = [[activityInfo valueForKey:@"status"] integerValue];
        //活动状态
        model.status2 = [[activityInfo valueForKey:@"status2"] integerValue];
        //活动标题
        model.title = [NSString pargramText:[activityInfo valueForKey:@"title"]];
        //类型图标
        model.title_pic = [NSString pargramText:[activityInfo valueForKey:@"title_pic"]];
        //类型名称
        model.type_title = [NSString pargramText:[activityInfo valueForKey:@"type_title"]];
        
        [activityResult addObject:model];
    }
    return activityResult;
}
@end
