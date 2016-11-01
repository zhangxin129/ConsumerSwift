//
//  GYHSDocModel.m
//  HSCompanyPad
//
//  Created by sqm on 16/9/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSDocModel.h"

@implementation GYHSDocModel
- (NSURL *)docUrl
{

    return [NSURL URLWithString:GY_PICTUREAPPENDING(_fileId)];
}
- (GYHSExampleDoc)docIdentify
{
    return [self.docCode isKindOfClass:[NSString class]] ? self.docCode.integerValue : 0;
}

- (NSString *)localPath
{

    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
   return path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.doc",_fileId]];
}
@end
