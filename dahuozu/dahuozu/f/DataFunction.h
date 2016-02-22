//
//  DataFunction.h
//  yueyishenghuo
//
//  Created by t on 15-3-13.
//  Copyright (c) 2015年 t. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#define CYLB0(a) (a.length>=0)
@interface OnlyMarkObject : NSObject

@property(nonatomic,strong,readonly)NSString *mark;
@property(nonatomic,assign,readonly)NSInteger type;
@property(nonatomic,assign,readonly)NSInteger index;
@property(nonatomic,copy,readonly)NSString *markDescription;

+(OnlyMarkObject*)onlyMark:(NSString*)markStr;
+(OnlyMarkObject*)onlyMarkWithMark:(NSString*)mark type:(NSInteger)type index:(NSInteger)index;

@end

@interface DataFunction : NSObject

+(NSCache*)imageData;
#pragma mark 保存网络图片
+(UIImage*)saveImageDataFile:(NSData*)data key:(NSString*)key;
#pragma mark 获取网络图片压缩
+(UIImage*)getCacheImageFile:(NSString*)key;
#pragma mark 获取网络图片原图
+(UIImage*)getCacheFullImageFile:(NSString*)key;
#pragma mark 保存图片完整路径
+(NSString*)fullFilePath:(NSString*)path;
#pragma mark 保存图片压缩路径
+(NSString*)decodedFilePath:(NSString*)path;
#pragma mark 保存二进制文件路径
+(NSString*)filePathForNSData:(NSURL*)dataURL;
#pragma mark 保存一张新照片
+(NSString*)filePathForJPGPhoto;
#pragma mark 保存照片文件名
+(NSString*)fileNameForJPGPhoto;
#pragma mark 是否已保存图片
+(BOOL)haveSaveImage:(NSString*)key;
#pragma mark 是否存在文件
+(BOOL)haveFileAtPath:(NSString*)path;
#pragma mark 标示类型标号组成的字符串
+(NSString*)onlyMark:(NSString*)mark type:(int)type index:(NSInteger)index;
#pragma mark 保存数据
+(void)saveDefaultsData:(NSDictionary*)datas;
#pragma mark 取得数据
+(id)getDefaultsData:(NSString*)key;

+(const NSDateFormatter*)formatter_yyyy_MM_dd__HH_mm_ss;
////////////CLLocationManager获取的是地球坐标，高德谷歌使用的是火星坐标，百度坐标独有

//真实的经纬度转化为百度地图上的经纬度，便于计算百度POI

/**
 * 地球坐标转换为火星坐标
 * World Geodetic System ==> Mars Geodetic System
 *
 * @param wgLat  地球坐标
 * @param wgLon
 *
 * mglat,mglon 火星坐标
 */
CLLocationCoordinate2D transform2Mars(double wgLat, double wgLon);
/**
 * 火星坐标转换为百度坐标
 * @param gg_lat
 * @param gg_lon
 */
CLLocationCoordinate2D bd_encrypt(double gg_lat, double gg_lon);
/**
 * 百度转火星
 * @param bd_lat
 * @param bd_lon
 */
CLLocationCoordinate2D bd_decrypt(double bd_lat, double bd_lon);
/*
        地球转百度
 */
CLLocationCoordinate2D eraTobd(double wgLat, double wgLon);

@end
