//
//  DeviceControl.h
//  dahuozu
//
//  Created by apple on 16/1/20.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface NSObject (DeviceControlResponse)

-(void)listenLocationResult:(BOOL)listen;

-(void)getUserLocation:(CLLocationCoordinate2D)coord;

-(void)getAddressInfo:(NSDictionary*)addressInfo location:(CLLocationCoordinate2D)coord;

@end

#pragma mark 百度地址

@interface BaiduAddress : NSObject<NSCoding>
//市
@property(nonatomic,strong,readonly)NSString *city;
//区
@property(nonatomic,strong,readonly)NSString *district;
//省
@property(nonatomic,strong,readonly)NSString *province;
//街道
@property(nonatomic,strong,readonly)NSString *street;
//门牌号
@property(nonatomic,strong,readonly)NSString *street_number;
//距离
@property(nonatomic,assign,readonly)CLLocationDistance distance;
//格式化地址
@property(nonatomic,strong,readonly)NSString *formatted_address;
//经纬度
@property(nonatomic,assign,readonly)CLLocationCoordinate2D coordinate2D;

#pragma mark 通过百度请求获得的地址信息初始化
-(instancetype)initWithDictionary:(NSDictionary*)addressInfo;

#pragma mark 存储地址
-(void)saveBaiduAddressForKey:(NSString*)key;
#pragma mark 提取地址
+(BaiduAddress*)getBaiduAddressForKey:(NSString*)key;

@end


@interface DeviceControl : NSObject
<CLLocationManagerDelegate>
+(DeviceControl*)centerController;
@property(nonatomic,strong,readonly)CLLocationManager *locationManager;
@property(nonatomic,assign,readonly)NSInteger tryCount;
@property(nonatomic,assign,readonly)BOOL shouldResponseLocation;
#pragma mark 获取用户位置
- (void)locationUserPoint;
#pragma mark 反地理编码获取地址信息
- (void)getAddressWithLocation:(CLLocationCoordinate2D)coordinate;
#pragma mark 是否为相同版本
+(BOOL)isSameAppVersion;
+(BOOL)isSameAppVersion:(NSString*)key;
#pragma mark 获取项目版本
+(NSString*)getAppVersion;
#pragma mark 保存项目版本
+(void)saveAppVersion:(NSString *)key;
#pragma mark 获取保留的版本
+(NSString*)getSaveAppVersion:(NSString*)key;
@end
