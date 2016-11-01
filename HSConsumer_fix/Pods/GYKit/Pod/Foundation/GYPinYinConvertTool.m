//
//  PinYinForObjc.m
//  Search
//
//  Created by LYZ on 14-1-24.
//  Copyright (c) 2014年 LYZ. All rights reserved.
//

#import "GYPinYinConvertTool.h"

@implementation GYPinYinConvertTool

+ (NSString*)chineseConvertToPinYin:(NSString*)chinese
{
    NSString* sourceText = chinese;
    HanyuPinyinOutputFormat* outputFormat = [[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    NSString* outputPinyin = [PinyinHelper toHanyuPinyinStringWithNSString:sourceText withHanyuPinyinOutputFormat:outputFormat withNSString:@""];

    return outputPinyin;
}

+ (NSString*)chineseConvertToPinYinHead:(NSString*)chinese
{
    HanyuPinyinOutputFormat* outputFormat = [[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    NSMutableString* outputPinyin = [[NSMutableString alloc] init];
    for (int i = 0; i < chinese.length; i++) {
        NSString* mainPinyinStrOfChar = [PinyinHelper getFirstHanyuPinyinStringWithChar:[chinese characterAtIndex:i] withHanyuPinyinOutputFormat:outputFormat];
        if (nil != mainPinyinStrOfChar) {
            [outputPinyin appendString:[mainPinyinStrOfChar substringToIndex:1]];
        }
        else {
            break;
        }
    }
    return outputPinyin;
}

+ (BOOL)isIncludeChineseInString:(NSString*)str
{
    for (int i = 0; i < str.length; i++) {
        unichar ch = [str characterAtIndex:i];
        if (0x4e00 < ch && ch < 0x9fff) {
            return true;
        }
    }
    return false;
}
@end
