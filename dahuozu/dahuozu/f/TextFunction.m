//
//  TextFunction.m
//  项目的基本元素
//
//  Created by wjymac on 14-9-26.
//  Copyright (c) 2014年 wjymac. All rights reserved.
//

#import "TextFunction.h"

@implementation StringPredicate

+(BOOL)PredicateString:(NSString *)str WithBds:(NSString *)pre
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",pre];
    return [predicate evaluateWithObject:str];
}
+(BOOL)isPhoneNummber:(NSString*)string
{
    BOOL bool_1 = [StringPredicate YanZhengCanUse:string];
    BOOL bool_2 = [StringPredicate PredicateString:string WithBds:@"^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\\d{8}$"];
    return bool_1&&bool_2;
}
+(BOOL)isIDCardNummber:(NSString*)string
{
    BOOL bool_1 = [StringPredicate YanZhengCanUse:string];
    BOOL bool_2 = [StringPredicate PredicateString:string WithBds:@"^([0-9]){17,18}(x|X)?$"];
    return bool_1&&bool_2;
}
+(BOOL)isURLPath:(NSString *)string
{
    NSString *bds = @"((http|https|ftp):\\/\\/((\\w)+[.]){1,}(net|com|cn|org|cc|tv|[0-9]{1,3})(((\\/[\\~]*|\\[\\~]*)(\\w)+)|[.](\\w)+)*(((([?](\\w)+){1}[=]*))*((\\w)+){1}([\\&](\\w)+[\\=](\\w)+)*)*)";
    BOOL bool_1 = [StringPredicate YanZhengCanUse:string];
    BOOL bool_2 = [StringPredicate PredicateString:string WithBds:bds];
    return bool_1&&bool_2;
}

+(BOOL)YanZhengIsWhiteString:(NSString *)string
{
    return [StringPredicate PredicateString:string WithBds:@"\\s*|\\(null\\)|<null>"];
}
+(BOOL)isPassWord:(NSString*)string BetweenRange:(NSRange)range
{
    BOOL result = [StringPredicate PredicateString:string WithBds:@"^(?!_)(?!.*?_$)[a-zA-Z0-9_]+$"];
    NSInteger max = range.location+range.length+1;
    NSInteger min = range.location;
    result = result&&(string.length>=min)&&(string.length<=max);
    return result;
}
+(BOOL)YanZhengCanUse:(id)string
{
    if (![string isKindOfClass:[NSString class]])
    {
        string = [string description];
    }
    BOOL result = ((string!=nil)&&![string isKindOfClass:[NSNull class]]&&![StringPredicate YanZhengIsWhiteString:string]);
    return result;
}

+(NSString*)ChinaNummberFromInt:(int)nummber
{
    NSString *Falsestring = [StringPredicate FalseNummberStringFromInt:nummber];
    NSArray *array = [Falsestring componentsSeparatedByString:@"_"];
    if ([array count]<1)
    {
        return @"零";
    }
    else if ([array count]==1)
    {
        return Falsestring;
    }
    else if ([array count]==2)
    {
        NSMutableString *result = [NSMutableString stringWithFormat:@"%@十%@",[array objectAtIndex:0],[array objectAtIndex:1]];
        [result replaceOccurrencesOfString:@"一十" withString:@"十" options:NSNumericSearch range:NSMakeRange(0, result.length)];
        if ([[result substringWithRange:NSMakeRange(result.length-1, 1)]isEqualToString:@"零"])
        {
            [result deleteCharactersInRange:NSMakeRange(result.length-1, 1)];
        }
        return result;
    }
    else if ([array count]==3)
    {
        NSMutableString *result = [NSMutableString stringWithFormat:@"%@百%@十%@",[array objectAtIndex:0],[array objectAtIndex:1],[array objectAtIndex:2]];
        [result replaceOccurrencesOfString:@"零十" withString:@"零" options:NSNumericSearch range:NSMakeRange(0, result.length)];
        [result replaceOccurrencesOfString:@"零零" withString:@"" options:NSNumericSearch range:NSMakeRange(0, result.length)];
        if ([[result substringWithRange:NSMakeRange(result.length-1, 1)]isEqualToString:@"零"])
        {
            [result deleteCharactersInRange:NSMakeRange(result.length-1, 1)];
        }
        return result;
    }
    return @"一千多";
}
+(NSString*)FalseNummberStringFromInt:(int)nummber
{
    NSArray *chinaArray = [NSArray arrayWithObjects:@"零",@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",nil];
    int num = nummber/10;
    NSMutableString *string = [NSMutableString stringWithString:@""];
    if (num==0)
    {
        return [chinaArray objectAtIndex:nummber%10];
    }
    else
    {
        [string appendFormat:@"%@_%@",[StringPredicate ChinaNummberFromInt:(nummber/10)],[chinaArray objectAtIndex:nummber%10]];
        return string;
    }
    return @"零";
}

+(NSString*)distantTimeForm:(NSString*)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    if ([[string componentsSeparatedByString:@"."] count]>1)
    {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    }
    else
    {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSDate *date = [formatter dateFromString:string];
    int distant = (int)[[NSDate new] timeIntervalSinceDate:date];
    long second = 60;
    long halfhour = 30*second;
    long hour = 2*halfhour;
    long halfday = 12*hour;
    long day = 2*halfday;
    long halfmonth  = 15*day;
    long month = 2*halfmonth;
    long halfyear = 6*month;
    long year = 2*halfyear;
    long tenyear = 10*year;
    long nummber[10] = {second,halfhour,hour,halfday,day,halfmonth,month,halfyear,year,tenyear};
    int count = INT_MAX;
    for (int i=0; i<10;i++)
    {
        count = distant/nummber[i];
        if (count<=0)
        {
            switch (i)
            {
                case 0://////小于一分钟
                {
                    return @"刚刚";
                }
                    break;
                case 1://////小于半个小时
                {
                    count = distant/nummber[i-1];
                    if (count>=29)
                    {
                        return @"半个小时前";
                    }
                    return [NSString stringWithFormat:@"%@分钟前",[StringPredicate ChinaNummberFromInt:count]];
                }
                    break;
                case 2://////小于一个小时
                {
                    count = distant/nummber[i-2];
                    if (count>=31)
                    {
                        return [NSString stringWithFormat:@"%@分钟前",[StringPredicate ChinaNummberFromInt:count]];
                    }
                    return @"半个小时前";
                }
                    break;
                case 3://////小于半天
                {
                    count = distant/nummber[i-1];
                    return [NSString stringWithFormat:@"%@小时前",[StringPredicate ChinaNummberFromInt:count]];
                }
                    break;
                case 4://////小于一天
                {
                    count = distant/nummber[i-2];
                    if (count==4)
                    {
                        return @"半天前";
                    }
                    return [NSString stringWithFormat:@"%@小时前",[StringPredicate ChinaNummberFromInt:count]];
                }
                    break;
                case 5://////小于半个月
                {
                    count = distant/nummber[i-1];
                    return [NSString stringWithFormat:@"%@天前",[StringPredicate ChinaNummberFromInt:count]];
                }
                    break;
                case 6://////小于一个月
                {
                    count = distant/nummber[i-2];
                    if (count==15)
                    {
                        return @"半月前";
                    }
                    return [NSString stringWithFormat:@"%@天前",[StringPredicate ChinaNummberFromInt:count]];
                }
                    break;
                case 7://////小于半年
                {
                    count = distant/nummber[i-1];
                    return [NSString stringWithFormat:@"%@月前",[StringPredicate ChinaNummberFromInt:count]];
                }
                    break;
                case 8://////小于一年
                {
                    count = distant/nummber[i-2];
                    if (count==6)
                    {
                        return @"半年前";
                    }
                    return [NSString stringWithFormat:@"%@月前",[StringPredicate ChinaNummberFromInt:count]];
                }
                    break;
                case 9://////小于十年
                {
                    count = distant/nummber[i-1];
                    return [NSString stringWithFormat:@"%@年前",[StringPredicate ChinaNummberFromInt:count]];
                }
                    break;
                default:
                    break;
            }
        }
    }
    count = distant/nummber[9];
    return [NSString stringWithFormat:@"%@十年前",[StringPredicate ChinaNummberFromInt:count]];
}

@end



@implementation NSString (Encrypt)


//空字符串
#define     LocalStr_None           @""

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

+ (NSString *)base64StringFromText:(NSString *)text
{
    if (text && ![text isEqualToString:LocalStr_None]) {
        //取项目的bundleIdentifier作为KEY  改动了此处
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        //IOS 自带DES加密 Begin  改动了此处
        //data = [self DESEncrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [self base64EncodedStringFrom:data];
    }
    else {
        return LocalStr_None;
    }
}

+ (NSString *)textFromBase64String:(NSString *)base64
{
    if (base64 && ![base64 isEqualToString:LocalStr_None]) {
        //取项目的bundleIdentifier作为KEY   改动了此处
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [self dataWithBase64EncodedString:base64];
        //IOS 自带DES解密 Begin    改动了此处
        //data = [self DESDecrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else {
        return LocalStr_None;
    }
}

/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES加密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES解密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

/******************************************************************************
 函数名称 : + (NSData *)dataWithBase64EncodedString:(NSString *)string
 函数描述 : base64格式字符串转换为文本数据
 输入参数 : (NSString *)string
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 :
 ******************************************************************************/
+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    if (string==nil)
    {
        return nil;
    }
    
    if ([string length] == 0)
    {
        return [NSData data];
    }
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

/******************************************************************************
 函数名称 : + (NSString *)base64EncodedStringFrom:(NSData *)data
 函数描述 : 文本数据转换为base64格式字符串
 输入参数 : (NSData *)data
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 ******************************************************************************/
+ (NSString *)base64EncodedStringFrom:(NSData *)data
{
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}
+ (NSString*)pargramText:(id)value
{

    if([StringPredicate YanZhengCanUse:value])
    {
        if ([value isKindOfClass:[NSString class]])
        {
            return value;
        }
        else
        {
            return [value description];
        }
    }
    else
    {
        return @"";
    }
}
+ (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    if (unicodeStr==nil)
    {
        return @"";
    }
    if ([StringPredicate YanZhengIsWhiteString:unicodeStr])
    {
        return unicodeStr;
    }
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    //?NSString?*tempStr1 = [unicodeStr?stringByReplacingOccurrencesOfString:@"%u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
    
}
- (NSString*)md5EncodeString
{
    const char* str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}
+(NSString *)encodeURL:(NSString *)str
{
    NSString *escapedUrlString= [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];;
    return escapedUrlString;
}

- (NSString*) sha1EncodeString
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

//获取时间戳
+ (NSString*) gettimeSp:(NSDate*)datenow
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *myDate = [formatter stringFromDate:datenow];
    
    NSArray *ymdhms = [myDate componentsSeparatedByString:@" "];
    
    NSArray *ymd = [ymdhms[0] componentsSeparatedByString:@"-"];
    
    NSArray *hms = [ymdhms[1] componentsSeparatedByString:@":"];
    
    NSString *timeSp = [NSString stringWithFormat:@"%@%@%@%@%@%@",ymd[0], ymd[1],ymd[2],hms[0],hms[1],hms[2]];
    
    return timeSp;
    
}
/*
 * @DO 获取指定日期的农历日期
 * @param date [指定日期]
 * @return (NSString)[指定日期的农历字符串]
 */
+(NSString*)getChineseCalendarWithDate:(NSDate *)date
{
    //定义农历数据:
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅", @"丁卯", @"戊辰", @"己巳", @"庚午", @"辛未", @"壬申", @"癸酉",
                             @"甲戌", @"乙亥", @"丙子", @"丁丑", @"戊寅", @"己卯", @"庚辰", @"辛己", @"壬午", @"癸未",
                             @"甲申", @"乙酉", @"丙戌", @"丁亥", @"戊子", @"己丑", @"庚寅", @"辛卯", @"壬辰", @"癸巳",
                             @"甲午", @"乙未", @"丙申", @"丁酉", @"戊戌", @"己亥", @"庚子", @"辛丑", @"壬寅", @"癸丑",
                             @"甲辰", @"乙巳", @"丙午", @"丁未", @"戊申", @"己酉", @"庚戌", @"辛亥", @"壬子", @"癸丑",
                             @"甲寅", @"乙卯", @"丙辰", @"丁巳", @"戊午", @"己未", @"庚申", @"辛酉", @"壬戌", @"癸亥", nil];
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月",
                            @"七月", @"八月", @"九月", @"十月", @"冬月", @"腊月", nil];
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@_%@_%@",y_str,m_str,d_str];
    return chineseCal_str;
}
@end
@implementation TextFunction
+(NSString*)imagePath:(NSString*)path
{

    if ([path isKindOfClass:[NSString class]]&&path.length>4)
    {
        if ([[path substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"http"])
        {
            return path;
        }
        else if (![[path substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"/"])
        {
            return [NSString stringWithFormat:@"http://%@",path];
        }
        else
        {
            return [NSString stringWithFormat:@"%@%@",ImageServerIP,path];
        }
    }
    else
    {
        return [NSString stringWithFormat:@"%@%@",ImageServerIP,path];
    }
}
@end
@implementation NSString (textSize)

-(CGSize)sizeWithFont:(UIFont*)font InSize:(CGSize)size
{
    static UILabel *modelLabel;
    if (modelLabel==nil)
    {
        modelLabel = [UILabel new];
        [modelLabel sizeToFit];
    }
    [modelLabel setFont:font];
    CGSize resultSize = [modelLabel sizeThatFits:size];
    return resultSize;
}

@end