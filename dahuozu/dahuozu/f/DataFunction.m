//
//  DataFunction.m
//  yueyishenghuo
//
//  Created by t on 15-3-13.
//  Copyright (c) 2015年 t. All rights reserved.
//

#import "DataFunction.h"

@implementation OnlyMarkObject

+(OnlyMarkObject*)onlyMark:(NSString*)markStr
{
    NSArray *array = [[NSString pargramText:markStr] componentsSeparatedByString:@"_$+"];
    if ([array count]==4)
    {
        NSString *mark = [array objectAtIndex:1];
        NSInteger type = [[array objectAtIndex:2] integerValue];
        NSInteger index = [[array objectAtIndex:3] integerValue];
        OnlyMarkObject *object = [[OnlyMarkObject alloc]initWithMark:mark type:type index:index markDescription:markStr];
        return object;
    }
    else
    {
        return nil;
    }
}
+(OnlyMarkObject*)onlyMarkWithMark:(NSString*)mark type:(NSInteger)type index:(NSInteger)index
{
    OnlyMarkObject *object = [[OnlyMarkObject alloc] initWithMark:mark type:type index:index];
    return object;
}
-(instancetype)initWithMark:(NSString*)mark type:(NSInteger)type index:(NSInteger)index
{
    self = [self init];
    if (self)
    {
        _mark = [NSString pargramText:[mark copy]];
        _type = type;
        _index = index;
        _markDescription = [NSString stringWithFormat:@"M_$+%@_$+%ld_$+%ld",_mark,(long)_type,(long)_index];
    }
    return self;
}
-(instancetype)initWithMark:(NSString*)mark type:(NSInteger)type index:(NSInteger)index markDescription:(NSString*)markDescription
{
    self = [self init];
    if (self)
    {
        _mark = [NSString pargramText:[mark copy]];
        _type = type;
        _index = index;
        _markDescription = [NSString pargramText:[markDescription copy]];
    }
    return self;
}
@end



@implementation DataFunction
#define FULL_IMAGE_DATE_FILE ([NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/FullPictures"])
#define DECODED_IMAGE_DATE_FILE ([NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/DecodedPictures"])
#define PHOTO_IMAGE_DATA_FILE ([NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Photos"])

#pragma mark 保存图片完整路径
+(NSString*)fullFilePath:(NSString*)path
{
    NSString *fullFilePath = [FULL_IMAGE_DATE_FILE stringByAppendingPathComponent:[[NSString pargramText:path] md5EncodeString]];
    return fullFilePath;
}
#pragma mark 保存图片压缩路径
+(NSString*)decodedFilePath:(NSString*)path
{
    NSString *decodedFilePath = [DECODED_IMAGE_DATE_FILE stringByAppendingPathComponent:[[NSString pargramText:path] md5EncodeString]];
    return decodedFilePath;
}
#pragma mark 保存二进制文件路径
+(NSString*)filePathForNSData:(NSURL*)dataURL
{
    NSString *fileName = [self fileNameForNSData:dataURL];
    NSString *photoFilePath = [PHOTO_IMAGE_DATA_FILE stringByAppendingPathComponent:[NSString pargramText:fileName]];
    return photoFilePath;
}
#pragma mark 保存二进制文件名
+(NSString*)fileNameForNSData:(NSURL*)dataURL
{
    NSString *urlPath = [NSString pargramText:[dataURL absoluteString]];
    NSString *fileName = [NSString stringWithFormat:@"data%@",[urlPath md5EncodeString]];
    return fileName;
}
#pragma mark 保存一张新照片
+(NSString*)filePathForJPGPhoto
{
    NSString *fileName = [self fileNameForJPGPhoto];
    NSString *photoFilePath = [PHOTO_IMAGE_DATA_FILE stringByAppendingPathComponent:[NSString pargramText:fileName]];
    return photoFilePath;
}
#pragma mark 保存照片文件名
+(NSString*)fileNameForJPGPhoto
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"photo%.0f%04i.jpg",time,(arc4random()%1024)];
    return fileName;
}
#pragma mark 是否存在文件
+(BOOL)haveFileAtPath:(NSString*)path
{
    NSFileManager *manage = [NSFileManager defaultManager];
    if ([manage fileExistsAtPath:path])
    {
        return YES;
    }
    return NO;
}
#pragma mark 是否已保存图片
+(BOOL)haveSaveImage:(NSString*)key
{
    NSFileManager *manage = [NSFileManager defaultManager];
    NSString *urlPath = [NSString pargramText:key];
    NSString *fullFilePath = [self fullFilePath:urlPath];
    NSString *decodedFilePath = [self decodedFilePath:urlPath];
    if ([manage fileExistsAtPath:fullFilePath]&&[manage fileExistsAtPath:decodedFilePath])
    {
        return YES;
    }
    return NO;
}
#pragma mark 保存网络图片
+(UIImage*)saveImageDataFile:(NSData*)data key:(NSString *)key
{
    NSString *urlPath = [NSString pargramText:key];
    if ([urlPath length]>0)
    {
        NSString *fullFilePath = [self fullFilePath:urlPath];
        [data writeToFile:fullFilePath atomically:YES];
        NSString *decodedFilePath = [self decodedFilePath:urlPath];
        
        if ([self haveSaveImage:key])
        {
            return [self getCacheImageFile:key];
        }
        
        
        UIImage *decodedImage = nil;
        
        @autoreleasepool
        {
            decodedImage = [ImageFunction decodedImageWithImage:[ImageFunction imageWithData:data]];
            
            if ([ImageFunction watchIsGIF:data])
            {
                [data writeToFile:decodedFilePath atomically:YES];
            }
            else
            {
                NSData *decodeData = UIImageJPEGRepresentation(decodedImage,1.0f);
                [decodeData writeToFile:decodedFilePath atomically:YES];
            }
        }
        return decodedImage;
    }
    return nil;
}
#pragma mark 获取网络图片压缩
+(UIImage*)getCacheImageFile:(NSString*)key
{
    NSString *urlPath = [NSString pargramText:key];
    NSString *decodedFilePath = [self decodedFilePath:urlPath];
    NSFileManager *manage= [NSFileManager defaultManager];
    if ([manage fileExistsAtPath:decodedFilePath])
    {
        NSData *imageData = [NSData dataWithContentsOfFile:decodedFilePath];
        if ([ImageFunction watchIsGIF:imageData])
        {
            UIImage *decodedImage = [ImageFunction decodedImageWithImage:[ImageFunction imageWithData:imageData]];
            
            return decodedImage;
        }
        UIImage *resultImage = [ImageFunction imageWithData:imageData];
        return resultImage;
    }
    return nil;
}
#pragma mark 获取网络图片原图
+(UIImage*)getCacheFullImageFile:(NSString*)key
{
    NSString *urlPath = [NSString pargramText:key];
    NSString *fullFilePath = [self fullFilePath:urlPath];
    NSFileManager *manage= [NSFileManager defaultManager];
    if ([manage fileExistsAtPath:fullFilePath])
    {
        NSData *imageData = [NSData dataWithContentsOfFile:fullFilePath];
        UIImage *resultImage = [ImageFunction imageWithData:imageData];
        return resultImage;
    }
    return nil;
}
+(const NSDateFormatter*)formatter_yyyy_MM_dd__HH_mm_ss
{
    static const NSDateFormatter *formatter;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return formatter;
}
#pragma mark 标示类型标号组成的字符串
+(NSString*)onlyMark:(NSString*)mark type:(int)type index:(NSInteger)index
{
    NSString *result = [NSString stringWithFormat:@"%@$%i$%ld",[NSString pargramText:mark],type,(long)index];
    return result;
}
#pragma mark 保存数据
+(void)saveDefaultsData:(NSDictionary*)datas
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    for (NSString *key in datas.allKeys)
    {
        id object = [datas objectForKey:key];
        [userDefaults setObject:object forKey:key];
    }
    [userDefaults synchronize];
}
#pragma mark 取得数据
+(id)getDefaultsData:(NSString*)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}
#pragma mark 图片缓存
+(NSCache*)imageData
{
    static NSCache *IMData;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        IMData = [[NSCache alloc]init];
        NSFileManager *manage = [NSFileManager defaultManager];
        if (![manage fileExistsAtPath:FULL_IMAGE_DATE_FILE])
        {
            [manage createDirectoryAtPath:FULL_IMAGE_DATE_FILE withIntermediateDirectories:YES attributes:nil error:nil];
        }
        if (![manage fileExistsAtPath:DECODED_IMAGE_DATE_FILE])
        {
            [manage createDirectoryAtPath:DECODED_IMAGE_DATE_FILE withIntermediateDirectories:YES attributes:nil error:nil];
        }
        if (![manage fileExistsAtPath:PHOTO_IMAGE_DATA_FILE])
        {
            [manage createDirectoryAtPath:PHOTO_IMAGE_DATA_FILE withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
    return IMData;
}

const double pi = 3.14159265358979324;
const double a = 6378245.0;
const double ee = 0.00669342162296594323;
const  double x_pi = 3.14159265358979324 * 3000.0 / 180.0;

bool outOfChina(double lat, double lon)
{
    if (lon < 72.004 || lon > 137.8347)
        return true;
    if (lat < 0.8293 || lat > 55.8271)
        return true;
    return false;
}

double transformLat(double x, double y)
{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs((int)x));
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return ret;
}

double transformLon(double x, double y)
{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs((int)x));
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return ret;
}

/**
 * 地球坐标转换为火星坐标
 * World Geodetic System ==> Mars Geodetic System
 *
 * @param wgLat  地球坐标
 * @param wgLon
 *
 * mglat,mglon 火星坐标
 */
CLLocationCoordinate2D transform2Mars(double wgLat, double wgLon)
{
    double mgLat = 0;
    double mgLon = 0;
    if (outOfChina(wgLat, wgLon))
    {
        mgLat  = wgLat;
        mgLon = wgLon;
        return CLLocationCoordinate2DMake(mgLat, mgLat);
    }
    double dLat = transformLat(wgLon - 105.0, wgLat - 35.0);
    double dLon = transformLon(wgLon - 105.0, wgLat - 35.0);
    double radLat = wgLat / 180.0 * pi;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
    mgLat = wgLat + dLat;
    mgLon = wgLon + dLon;
    
    return CLLocationCoordinate2DMake(mgLat, mgLon);
}

/**
 * 火星坐标转换为百度坐标
 * @param gg_lat
 * @param gg_lon
 */
CLLocationCoordinate2D bd_encrypt(double gg_lat, double gg_lon)
{
    double bd_lat = 0;
    double bd_lon = 0;
    double x = gg_lon, y = gg_lat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    bd_lon = z * cos(theta) + 0.0065;
    bd_lat = z * sin(theta) + 0.006;
    
    return CLLocationCoordinate2DMake(bd_lat, bd_lon);
}

/**
 * 百度转火星
 * @param bd_lat
 * @param bd_lon
 */
CLLocationCoordinate2D bd_decrypt(double bd_lat, double bd_lon)
{
    double gg_lat = 0;
    double gg_lon = 0;
    double x = bd_lon - 0.0065, y = bd_lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    gg_lon = z * cos(theta);
    gg_lat = z * sin(theta);
    
    return CLLocationCoordinate2DMake(gg_lat, gg_lon);
}
/*
 地球转百度
 */
CLLocationCoordinate2D eraTobd(double wgLat, double wgLon)
{
    double mgLat = 0;
    double mgLon = 0;
    if (outOfChina(wgLat, wgLon))
    {
        mgLat  = wgLat;
        mgLon = wgLon;
        return CLLocationCoordinate2DMake(mgLat, mgLat);
    }
    double dLat = transformLat(wgLon - 105.0, wgLat - 35.0);
    double dLon = transformLon(wgLon - 105.0, wgLat - 35.0);
    double radLat = wgLat / 180.0 * pi;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
    mgLat = wgLat + dLat;
    mgLon = wgLon + dLon;
    
    double bd_lat = 0;
    double bd_lon = 0;
    double x = mgLon, y = mgLat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    bd_lon = z * cos(theta) + 0.0065;
    bd_lat = z * sin(theta) + 0.006;
    
    CLLocationCoordinate2D bd = CLLocationCoordinate2DMake(bd_lat, bd_lon);
    
    return bd;
}


@end
