//
//  ActivitySimpleModel.h
//  dahuozu
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "BaseDataModel.h"

@interface ActivitySimpleModel : BaseDataModel
//用户ID
@property(nonatomic,strong)NSString *user_id;
//活动描述
@property(nonatomic,strong)NSString *activity_content;
//活动ID
@property(nonatomic,strong)NSString *activity_id;
//目的地详情
@property(nonatomic,strong)NSString *address_describe;
//开始时间2016-01-20 16:04
@property(nonatomic,strong)NSString *b_time;
//参加人数
@property(nonatomic,assign)int canjia_count;
//出发城市
@property(nonatomic,strong)NSString *chufa_city;
//目的城市
@property(nonatomic,strong)NSString *city;
//创建时间2016-01-20 16:01:25
@property(nonatomic,strong)NSString *create_time;
//结束时间
@property(nonatomic,strong)NSString *end_time;
//与活动之间的关系
@property(nonatomic,assign)NSInteger func_type;
//发起人头像
@property(nonatomic,strong)NSString *head_pic;
//图片列表
@property(nonatomic,strong)NSArray *imageList;
//纬度
@property(nonatomic,assign)CLLocationDegrees latitude;
//经度
@property(nonatomic,assign)CLLocationDegrees longitude;
//用户昵称
@property(nonatomic,strong)NSString *nick_name;
//限制参加人数-1不限制
@property(nonatomic,assign)int people_number;
//评论人数
@property(nonatomic,assign)int pinglun;
//收藏人数
@property(nonatomic,assign)int praise;
//阅读人数
@property(nonatomic,assign)int read_num;
//是否实名认证参加
@property(nonatomic,assign)NSInteger renzheng;
//用户性别
@property(nonatomic,assign)NSInteger sex;
//发起者是否实名认证
@property(nonatomic,assign)NSInteger status;
//活动状态
@property(nonatomic,assign)NSInteger status2;
//活动标题
@property(nonatomic,strong)NSString *title;
//类型图标
@property(nonatomic,strong)NSString *title_pic;
//类型名称
@property(nonatomic,strong)NSString *type_title;
@end
