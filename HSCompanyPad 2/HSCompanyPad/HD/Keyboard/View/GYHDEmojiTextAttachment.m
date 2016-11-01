//
//  GYHDEmojiTextAttachment.m
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/12.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDEmojiTextAttachment.h"

@implementation GYHDEmojiTextAttachment
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer*)textContainer
                      proposedLineFragment:(CGRect)lineFrag
                             glyphPosition:(CGPoint)position
                            characterIndex:(NSUInteger)charIndex
{
    // return CGRectMake(0, 0, _emojiSize.width, _emojiSize.height);
    return CGRectMake(0, 0, lineFrag.size.height, lineFrag.size.height);
}
@end
