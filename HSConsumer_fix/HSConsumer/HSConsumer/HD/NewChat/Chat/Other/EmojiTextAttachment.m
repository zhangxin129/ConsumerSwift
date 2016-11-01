//
//  EmojiTextAttachment.m
//  HSConsumer
//
//  Created by shiang on 16/6/15.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "EmojiTextAttachment.h"

@implementation EmojiTextAttachment

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer*)textContainer
                      proposedLineFragment:(CGRect)lineFrag
                             glyphPosition:(CGPoint)position
                            characterIndex:(NSUInteger)charIndex
{
    // return CGRectMake(0, 0, _emojiSize.width, _emojiSize.height);
    return CGRectMake(0, 0, lineFrag.size.height, lineFrag.size.height);
}
@end
