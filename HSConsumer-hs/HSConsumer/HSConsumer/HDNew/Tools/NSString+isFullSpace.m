//
//  NSString+isFullSpace.m
//  po
//
//  Created by Yejg on 16/10/18.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import "NSString+isFullSpace.h"

@implementation NSString (isFullSpace)

//判断内容是否全部为空格  yes 全部为空格  no 不是
- (BOOL) isFullSpace {
    
    if (self.length > 0) {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [self stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}

@end
