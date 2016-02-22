//
//  SystemDefine.h
//  myapp
//
//  Created by t on 15/5/28.
//  Copyright (c) 2015年 t. All rights reserved.
//

#ifndef myapp_SystemDefine_h
#define myapp_SystemDefine_h

#import "ImageFunction.h"
#import "PureLayout.h"
#import "DeviceControl.h"
#import "AppSetting.h"
#import "RequestSender.h"
#import "AppCenterControl.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "NSDate+YYAdd.h"
#import "CellHeigthManager.h"


#define SMax_Width ([UIScreen mainScreen].bounds.size.width)
#define SMax_Height ([UIScreen mainScreen].bounds.size.height)
/////////数据结果输出的宏定义
#define HZ_WJY(x) ([NSString replaceUnicode:[x description]])
#define IsNeedDataNSLog (1)
#define MyDataLog(format, ...) if(IsNeedDataNSLog){NSLog(format, ## __VA_ARGS__);}
////////内存输出的宏定义
#define IsNeedMemoryNSLog (1)
#define MyMemoryLog(format, ...) if(IsNeedMemoryNSLog){NSLog(format, ## __VA_ARGS__);}
////////地址输出的宏定义
#define IsNeedPathNSLog (0)
#define MyPathLog(format, ...) if(IsNeedPathNSLog){NSLog(format, ## __VA_ARGS__);}
///////颜色的生成
#define ColorWithRGB(r,g,b) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0])
#define ColorWithRGBA(r,g,b,a) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])
#define ColorSystem(c) ([UIColor c])
////系统字体
#define FontSystem(f) ([UIFont systemFontOfSize:f])
#define FontBoldSystem(f) ([UIFont boldSystemFontOfSize:f])

///////十六进制颜色生成
#define ColorFromInt16(rgbValue) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])

#define BlackTextColor ([UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0])
#define GrayTextColor ([UIColor colorWithRed:113.0/255.0 green:113.0/255.0 blue:113.0/255.0 alpha:1.0])
#define RedTextColor ([UIColor colorWithRed:255.0/255.0 green:76.0/255.0 blue:91.0/255.0 alpha:1.0])
#define LightTextColor ([UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0])

////////去除方法可能不存在带来的警告ASI中常见问题
#define RemovePerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define StateBarHeight (20)
#define NavHeight (44)
#define TabBarHeight (49)
#define SN_Height (StateBarHeight+NavHeight)

#define VERSION_SUPPORT(v) (([[[UIDevice currentDevice]systemVersion]floatValue]>=v)?1:0)//用来获取手机的系统，判断系统是多少
#define extraY (VERSION_SUPPORT(7)?StateBarHeight:0)
#define CY_DATA_PAGESIZE (20)

//参数定义
#define VC(name) name##ViewController
#define NVC(name) name##NavViewController
#define LB(name) name##Label
#define BTN(name) name##Button
#define IMGV(name) name##ImageView
#define TXTV(name) name##TextView
#define TXTF(name) name##TextField;

#define Init(class) [[class alloc] init]

#define Weak__(object) typeof(object) __weak weak##object = object
#define Strong__(class,object) class * __strong strong##object = (class *)weak##object

#define UPDATE_UI_ASYNC(...) dispatch_async(dispatch_get_main_queue(), ^{\
__VA_ARGS__;\
});
#define UPDATE_UI_SYNC(...) dispatch_sync(dispatch_get_main_queue(), ^{\
__VA_ARGS__;\
});

#endif
