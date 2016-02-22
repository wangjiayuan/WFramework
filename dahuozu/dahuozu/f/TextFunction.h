//
//  TextFunction.h
//  项目的基本元素
//
//  Created by wjymac on 14-9-26.
//  Copyright (c) 2014年 wjymac. All rights reserved.
//所有对文本字符串操作的函数

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>
#import "KCPinyinHelper.h"

#define ImageServerIP (@"")

//////字符串的验证和格式化等
@interface StringPredicate : NSObject
//////通过正则表达式验证字符串
+(BOOL)PredicateString:(NSString*)str WithBds:(NSString*)pre;
/////验证是否为空白字符串
+(BOOL)YanZhengIsWhiteString:(NSString*)string;

////验证是否为合格的参数字符串
+(BOOL)YanZhengCanUse:(id)string;
/////验证是否为电话号码
+(BOOL)isPhoneNummber:(NSString*)string;
/////验证是否为身份证号码
+(BOOL)isIDCardNummber:(NSString*)string;
////验证是否为URL
+(BOOL)isURLPath:(NSString*)string;
//////验证是否为合格的密码另一个参数为产犊限制
+(BOOL)isPassWord:(NSString*)string BetweenRange:(NSRange)range;

+(NSString*)distantTimeForm:(NSString*)string;

@end
//////////对字符串变形处理
@interface NSString (Encrypt)

//////将对象编程字符串参数
+ (NSString*)pargramText:(id)value;
//md5加密
- (NSString*)md5EncodeString;
//sha1加密
- (NSString*) sha1EncodeString;

////将URL编码
+(NSString *)encodeURL:(NSString *)str;
/////替换Unicode编码字符
+ (NSString *)replaceUnicode:(NSString *)unicodeStr;
/////获取农历日期
+(NSString*)getChineseCalendarWithDate:(NSDate *)date;
/******************************************************************************
 函数名称 : + (NSString *)base64StringFromText:(NSString *)text
 函数描述 : 将文本转换为base64格式字符串
 输入参数 : (NSString *)text    文本
 输出参数 : N/A
 返回参数 : (NSString *)    base64格式字符串
 备注信息 :
 ******************************************************************************/
+ (NSString *)base64StringFromText:(NSString *)text;
+ (NSString *)base64EncodedStringFrom:(NSData *)data;
/******************************************************************************
 函数名称 : + (NSString *)textFromBase64String:(NSString *)base64
 函数描述 : 将base64格式字符串转换为文本
 输入参数 : (NSString *)base64  base64格式字符串
 输出参数 : N/A
 返回参数 : (NSString *)    文本
 备注信息 :
 ******************************************************************************/
+ (NSString *)textFromBase64String:(NSString *)base64;

//获取时间戳
+ (NSString*)gettimeSp:(NSDate*)datenow;

@end
//////程序要求设置的函数
@interface TextFunction : NSObject
/////获取正确的图片地址
+(NSString*)imagePath:(NSString*)path;
@end
/////关于大小
@interface NSString (textSize)
///////获取文字所需的大小
-(CGSize)sizeWithFont:(UIFont*)font InSize:(CGSize)size;
@end
