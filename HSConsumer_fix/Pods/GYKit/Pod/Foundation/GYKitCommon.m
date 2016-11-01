//
//  GYKitCommon.m
//  Pods
//
//  Created by sqm on 16/6/15.
//
//

#import "GYKitCommon.h"

@implementation GYKitCommon



+ (NSString *)localizedStringForKey:(NSString *)key withDefault:(NSString *)defaultString
{
    static NSBundle *bundle = nil;
    if (bundle == nil)
    {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"GYFoundation" ofType:@"bundle"];
            bundle = [NSBundle bundleWithPath:bundlePath];
            NSString *language = [[NSLocale preferredLanguages] count]? [NSLocale preferredLanguages][0]: @"en";
            if (![[bundle localizations] containsObject:language])
            {
                language = [language componentsSeparatedByString:@"-"][0];
            }
            if ([[bundle localizations] containsObject:language])
            {
                bundlePath = [bundle pathForResource:language ofType:@"lproj"];
            }
      
        bundle = [NSBundle bundleWithPath:bundlePath] ?: [NSBundle mainBundle];
    }
    defaultString = [bundle localizedStringForKey:key value:defaultString table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:defaultString table:nil];
}


@end
