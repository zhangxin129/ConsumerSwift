//
//  EmojiTextAttachment.h
//  HSConsumer
//
//  Created by shiang on 16/6/15.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmojiTextAttachment : NSTextAttachment
@property (strong, nonatomic) NSString* emojiTag;
@property (strong, nonatomic) NSString* emojiName;

@property (assign, nonatomic) CGSize emojiSize; // For emoji image size
@end
