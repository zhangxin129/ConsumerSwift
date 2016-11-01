//
//  GYKitCommon.m
//  Pods
//
//  Created by sqm on 16/6/15.
//
//

#import "GYKitCommon.h"

@implementation GYKitCommon
+ (NSString *)localizedStringForKey:(NSString *)key{
    return [self localizedStringForKey:key withDefault:nil];
}

+ (NSString *)localizedStringForKey:(NSString *)key withDefault:(NSString *)defaultString
{
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        // 获得设备的语言
        NSString *language = [NSLocale preferredLanguages].firstObject;
        // 如果是iOS9以上，截取前面的语言标识
        if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
            NSRange range = [language rangeOfString:@"-" options:NSBackwardsSearch];
            if (range.location != NSNotFound) {
                language = [language substringToIndex:range.location];
            }
        }
        
        if (language.length == 0) {
            language = @"zh-Hans";
        }
        NSBundle *langBundle =  [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"GYRefresh" ofType:@"bundle"]];
        if ([langBundle.localizations containsObject:language]) {
            bundle = [NSBundle bundleWithPath:[langBundle pathForResource:language ofType:@"lproj"]];
        }
    }
    defaultString = [bundle localizedStringForKey:key value:defaultString table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:defaultString table:nil];
}
@end
