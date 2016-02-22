//
//  POAPinyin.h
//  POA
//
//  Created by haung he on 11-7-18.
//  Copyright 2011年 huanghe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCPinyinHelper : NSObject

// 传入汉字，返回拼音首字母
+ (NSString *)quickConvert:(NSString *)hzString;

// 中文转拼音，返回全拼
+ (NSString *)pinyinFromChiniseString:(NSString *)hzString;

char pinyinFirstLetter(NSString *hanzi);

@end
