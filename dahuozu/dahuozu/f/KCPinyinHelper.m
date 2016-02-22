//
//  POAPinyin.m
//  POA
//
//  Created by haung he on 11-7-18.
//  Copyright 2011年 huanghe. All rights reserved.
//

#import "KCPinyinHelper.h"
@implementation KCPinyinHelper

#define UnicodeChineseTableName (@"unicodeTable")

static DBWorker *chineseDB;

+(void)initialize
{
    [super initialize];
    if (chineseDB==nil)
    {
        chineseDB = [[DBWorker alloc] initWithDBPath:[[NSBundle mainBundle] pathForResource:@"Chinese.db" ofType:@""]];
    }
}

+ (NSString *)quickConvert:(NSString *)hzString
{
    NSArray *results = [chineseDB searchBase:UnicodeChineseTableName where:@{@"text":[NSString pargramText:hzString]} orderBy:nil desc:NO offset:0 count:INT16_MAX];
    if ([results count]>0)
    {
        NSDictionary *result = [results firstObject];
        NSString *pinyin = [NSString pargramText:[result valueForKey:@"pinyin"]];
        NSString *firstChar = @"";
        if ([pinyin length]>0)
        {
            firstChar = [pinyin substringWithRange:NSMakeRange(0, 1)];
        }
        return firstChar;
    }
    return @"";
}


+ (NSString *)pinyinFromChiniseString:(NSString *)string
{
    NSArray *results = [chineseDB searchBase:UnicodeChineseTableName where:@{@"text":[NSString pargramText:string]} orderBy:nil desc:NO offset:0 count:INT16_MAX];
    if ([results count]>0)
    {
        NSDictionary *result = [results firstObject];
        NSString *pinyin = [NSString pargramText:[result valueForKey:@"pinyin"]];
        return pinyin;
    }
    return @"";
}

@end

char pinyinFirstLetter(NSString *hanzi)
{
    NSArray *results = [chineseDB searchBase:UnicodeChineseTableName where:@{@"text":[NSString pargramText:hanzi]} orderBy:nil desc:NO offset:0 count:INT16_MAX];
    if ([results count]>0)
    {
        NSDictionary *result = [results firstObject];
        NSString *pinyin = [NSString pargramText:[result valueForKey:@"pinyin"]];
        if ([pinyin length]>0)
        {
            NSString *firstChar = [pinyin substringWithRange:NSMakeRange(0, 1)];
            return [firstChar characterAtIndex:0];
        }
        
    }
    return ' ';
}

