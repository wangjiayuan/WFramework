//
//  DeviceControl.m
//  dahuozu
//
//  Created by apple on 16/1/20.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "DeviceControl.h"
#import "NetWorkManager.h"

#define DEVICE_LOCATION_RESULT (@"DEVICE_LOCATION_RESULT")

typedef NS_ENUM(NSInteger, DeviceControlFunctionType)
{
    DeviceControlFunctionTypeGetLocation = 0,
    DeviceControlFunctionTypeGetAddressInfo = 1,
};


@implementation NSObject (DeviceControlResponse)

-(void)listenLocationResult:(BOOL)listen
{
    if (listen)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:DEVICE_LOCATION_RESULT object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationResult:) name:DEVICE_LOCATION_RESULT object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:DEVICE_LOCATION_RESULT object:nil];
    }
}

-(void)locationResult:(NSNotification*)noti
{
    NSNumber *number = [noti object];
    NSInteger type = [number integerValue];
    switch (type)
    {
        case DeviceControlFunctionTypeGetAddressInfo:
        {
            CLLocation *location = [[noti userInfo] valueForKey:@"location"];
            NSDictionary *result = [[noti userInfo] valueForKey:@"result"];
            [self getAddressInfo:result location:location.coordinate];
        }
            break;
        case DeviceControlFunctionTypeGetLocation:
        {
            CLLocation *location = [[noti userInfo] valueForKey:@"location"];
            if (location==nil)
            {
                [self getUserLocation:kCLLocationCoordinate2DInvalid];
            }
            else
            {
                [self getUserLocation:location.coordinate];
            }
        }
            break;
        default:
            break;
    }
}

-(void)getUserLocation:(CLLocationCoordinate2D)coord
{
    
}
-(void)getAddressInfo:(NSDictionary *)addressInfo location:(CLLocationCoordinate2D)coord
{
    
}
@end


@implementation BaiduAddress

#pragma mark 大牛写的获取基本类型数据的宏定义（第一个是参数类型，第二个为参数类型名称：用作区分函数）使用方式类似为：GET_IVAR_OF_TYPE_DEFININTION(int,GetIntFunction）

#define GET_IVAR_OF_TYPE_DEFININTION(type, capitalized_type) \
typedef type (*XY ## capitalized_type ## GetVariableFunctionType)(id object, Ivar ivar); \
XY ## capitalized_type ## GetVariableFunctionType XY ## capitalized_type ## GetVariableFunction = (XY ## capitalized_type ## GetVariableFunctionType)object_getIvar;


#pragma mark 格式化对象自己
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    NSArray *propertys = [DBWorker getPropertys:[self class]];
    
    for (NSString *property in propertys)
    {
        //获取成员内容的Ivar
        Ivar iv = class_getInstanceVariable([self class],[property UTF8String]);
        //其实上面那行获取代码是为了保险起见，基本是获取不到内容的。因为成员的名称默认会在前面加"_"
        if (iv == nil)
        {
            iv = class_getInstanceVariable([self class], [[NSString stringWithFormat:@"_%@",property] UTF8String]);
        }
        
        if ([property isEqualToString:@"distance"])
        {
            [aCoder encodeDouble:self.distance forKey:property];
        }
        else if ([property isEqualToString:@"coordinate2D"])
        {
            CLLocationDegrees latitude = self.coordinate2D.latitude;
            CLLocationDegrees longitude = self.coordinate2D.longitude;
            [aCoder encodeDouble:latitude forKey:@"coordinate2D_latitude"];
            [aCoder encodeDouble:longitude forKey:@"coordinate2D_longitude"];
        }
        else
        {
            id object = object_getIvar(self, iv);
            if (object!=nil)
            {
                [aCoder encodeObject:object forKey:property];
            }
        }
    }
    
}
#pragma mark 通过格式化数据返回对象
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self)
    {
        NSArray *propertys = [DBWorker getPropertys:[self class]];
        for (NSString *property in propertys)
        {
            //获取成员内容的Ivar
            Ivar iv = class_getInstanceVariable([self class],[property UTF8String]);
            //其实上面那行获取代码是为了保险起见，基本是获取不到内容的。因为成员的名称默认会在前面加"_"
            if (iv == nil)
            {
                iv = class_getInstanceVariable([self class], [[NSString stringWithFormat:@"_%@",property] UTF8String]);
            }
            
            if ([property isEqualToString:@"distance"])
            {
                CLLocationDegrees distance =  [aDecoder decodeDoubleForKey:property];
                _distance = distance;
            }
            else if ([property isEqualToString:@"coordinate2D"])
            {
                CLLocationDegrees latitude = [aDecoder decodeDoubleForKey:@"coordinate2D_latitude"];
                CLLocationDegrees longitude = [aDecoder decodeDoubleForKey:@"coordinate2D_longitude"];
                _coordinate2D = CLLocationCoordinate2DMake(latitude, longitude);
            }
            else
            {
                id object = [aDecoder decodeObjectForKey:property];
                if (object!=nil)
                {
                    object_setIvar(self, iv, object);
                }
            }
        }
    }
    return self;
}
#pragma mark 通过百度请求获得的地址信息初始化
-(instancetype)initWithDictionary:(NSDictionary*)addressInfo
{
    self = [super init];
    if (self)
    {
        NSDictionary *addressComponent = [addressInfo valueForKey:@"addressComponent"];
        NSDictionary *location = [addressInfo valueForKey:@"location"];
        NSString *formatted_address = [NSString pargramText:[addressInfo valueForKey:@"formatted_address"]];
        double lat = [[location valueForKey:@"lat"] doubleValue];
        double lng = [[location valueForKey:@"lng"] doubleValue];
        
        //市
        _city = [NSString pargramText:[addressComponent valueForKey:@"city"]];
        //区
        _district = [NSString pargramText:[addressComponent valueForKey:@"district"]];
        //省
        _province = [NSString pargramText:[addressComponent valueForKey:@"province"]];
        //街道
        _street = [NSString pargramText:[addressComponent valueForKey:@"street"]];
        //门牌号
        _street_number = [NSString pargramText:[addressComponent valueForKey:@"street_number"]];
        //距离
        _distance = [[addressComponent valueForKey:@"distance"] doubleValue];
        //格式化地址
        _formatted_address = formatted_address;
        //经纬度
        _coordinate2D = CLLocationCoordinate2DMake(lat, lng);
        
        
    }
    return self;
}
#pragma mark 描述对象
-(NSString *)description
{
    return [NSString stringWithFormat:@"\n省：%@\n市：%@\n区：%@\n街道：%@\n门牌号：%@\n经纬度：(%f,%f)\n格式化地址：%@\n",[NSString pargramText:self.province],[NSString pargramText:self.city],[NSString pargramText:self.district],[NSString pargramText:self.street],[NSString pargramText:self.street_number],self.coordinate2D.latitude,self.coordinate2D.longitude,[NSString pargramText:self.formatted_address]];
}
#pragma mark 存储地址
-(void)saveBaiduAddressForKey:(NSString*)key
{
    if ([key isKindOfClass:[NSString class]])
    {
        NSData *addressData = [NSKeyedArchiver archivedDataWithRootObject:self];
        [DataFunction saveDefaultsData:@{key:addressData}];
    }
}
#pragma mark 提取地址
+(BaiduAddress*)getBaiduAddressForKey:(NSString*)key
{
    if ([key isKindOfClass:[NSString class]])
    {
        NSData *addressData = [DataFunction getDefaultsData:key];
        if (addressData!=nil)
        {
            BaiduAddress *address = [NSKeyedUnarchiver unarchiveObjectWithData:addressData];
            if ([address isKindOfClass:[BaiduAddress class]])
            {
                return address;
            }
        }
    }
    return nil;
}
@end


@implementation DeviceControl

+(DeviceControl *)centerController
{
    static DeviceControl *_controlCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _controlCenter = [[self alloc] init];
    });
    return _controlCenter;
}
-(instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _shouldResponseLocation = YES;
        _tryCount = 0;
        //设置定位的精度
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
        {
            [_locationManager requestAlwaysAuthorization];
        }
    }
    
    return self;
}
-(void)locationUserPoint
{
    // 开始定位
    _tryCount = 0;
    _shouldResponseLocation = YES;
    [_locationManager startUpdatingLocation];
}

#pragma mark - location delegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status!=kCLAuthorizationStatusNotDetermined&&status!=kCLAuthorizationStatusRestricted&&status!=kCLAuthorizationStatusDenied)
    {
        _tryCount = 0;
        _shouldResponseLocation = YES;
        [_locationManager startUpdatingLocation];
    }
}

- (void)getAddressWithLocation:(CLLocationCoordinate2D)coordinate
{
    CLLocation *location = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    NSString *urlPath = [NSString stringWithFormat:@"http://api.map.baidu.com/geocoder?location=%f,%f&coord_type=gcj02&output=json&src=dahuozu",coordinate.latitude,coordinate.longitude];
    
    [[NetWorkManager sharedClient] postRequestApi:urlPath parameters:nil finshBlock:^(id result, NSError *error) {
        if ([result isKindOfClass:[NSDictionary class]])
        {
            if ([@"OK" isEqualToString:[result valueForKey:@"status"]])
            {
                if ([result valueForKey:@"result"]!=nil)
                {
                    if ([[result valueForKey:@"result"] isKindOfClass:[NSDictionary class]])
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:DEVICE_LOCATION_RESULT object:[NSNumber numberWithInteger:DeviceControlFunctionTypeGetAddressInfo] userInfo:@{@"location":location,@"result":[result valueForKey:@"result"]}];
                        return;
                    }
                }
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DEVICE_LOCATION_RESULT object:[NSNumber numberWithInteger:DeviceControlFunctionTypeGetAddressInfo] userInfo:@{@"location":location}];
    }];
}

//6.0之后新增的位置调用方法
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    
    CLLocation *currentLocation = [locations lastObject];
    
    
    _tryCount = _tryCount + 1;
    
    //停止实时定位
    [_locationManager stopUpdatingLocation];
    
    if (_shouldResponseLocation)
    {
        [self eraToBaidu:currentLocation.coordinate];
        _shouldResponseLocation = NO;
    }
    
}

-(void)eraToBaidu:(CLLocationCoordinate2D)coordinate2D
{
    NSString *urlPath = [NSString stringWithFormat:@"http://api.map.baidu.com/geoconv/v1/?coords=%f,%f&from=1&to=5&ak=EF06cfb26173665ad80b8edf6a328192",coordinate2D.longitude,coordinate2D.latitude];
    [[NetWorkManager sharedClient] postRequestApi:urlPath parameters:nil finshBlock:^(id result, NSError *error)
     {
         if ([result isKindOfClass:[NSDictionary class]])
         {
             if ([[result valueForKey:@"status"] integerValue]==0)
             {
                 NSArray *results = [result valueForKey:@"result"];
                 if ([results count]>0)
                 {
                     NSDictionary *baiduCoord = [results objectAtIndex:0];
                     CLLocationDegrees lat = [[baiduCoord valueForKey:@"y"] doubleValue];
                     CLLocationDegrees lng = [[baiduCoord valueForKey:@"x"] doubleValue];
                     
                     CLLocation *location = [[CLLocation alloc]initWithLatitude:lat longitude:lng];
                     
                     if (location!=nil)
                     {
                         [[NSNotificationCenter defaultCenter] postNotificationName:DEVICE_LOCATION_RESULT object:[NSNumber numberWithInteger:DeviceControlFunctionTypeGetLocation] userInfo:@{@"location":location}];
                         
                         return;
                     }
                     
                 }
             }
         }
         
         CLLocationCoordinate2D baiduCord2D = eraTobd(coordinate2D.latitude,coordinate2D.longitude);
         CLLocation *baiduLocation = [[CLLocation alloc]initWithLatitude:baiduCord2D.latitude longitude:baiduCord2D.longitude];
         [[NSNotificationCenter defaultCenter] postNotificationName:DEVICE_LOCATION_RESULT object:[NSNumber numberWithInteger:DeviceControlFunctionTypeGetLocation] userInfo:@{@"location":baiduLocation}];
     }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    _tryCount = _tryCount + 1;
    
    if (_tryCount>=5)//多次尝试失败
    {
        [_locationManager stopUpdatingLocation];
        [[NSNotificationCenter defaultCenter] postNotificationName:DEVICE_LOCATION_RESULT object:[NSNumber numberWithInteger:DeviceControlFunctionTypeGetLocation] userInfo:nil];
    }
    
}
#pragma mark 是否为相同版本
+(BOOL)isSameAppVersion
{
    return [self isSameAppVersion:nil];
}
+(BOOL)isSameAppVersion:(NSString*)key
{
    return [[self getAppVersion] isEqualToString:[self getSaveAppVersion:key]];
}
#pragma mark 获取项目版本
+(NSString*)getAppVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [[NSString pargramText:[infoDictionary objectForKey:@"CFBundleShortVersionString"]] stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    
    
    return app_Version;
}
#pragma mark 保存项目版本
+(void)saveAppVersion:(NSString *)key
{
    NSString *defaultsKey = [APP_VERSION_MARK stringByAppendingString:[NSString pargramText:key]];
    NSString *appVersion = [NSString pargramText:[self getAppVersion]];
    [DataFunction saveDefaultsData:@{defaultsKey:appVersion}];
}
#pragma mark 获取保留的版本
+(NSString*)getSaveAppVersion:(NSString*)key
{
    NSString *defaultsKey = [APP_VERSION_MARK stringByAppendingString:[NSString pargramText:key]];
    return [DataFunction getDefaultsData:defaultsKey];
}
@end
