//
//  GYHSTipLabel.m
//  Pods
//
//  Created by sqm on 16/6/16.
//
//

#import "GYHSTipLabel.h"
#import "NSString+GYExtension.h"

@implementation GYHSTipLabel
- (void)setTextMsgs:(NSArray*)textMsgs
{
    _textMsgs = textMsgs;
    NSMutableAttributedString* text = [[NSMutableAttributedString alloc] init];
    {
        NSMutableAttributedString* one = [[NSMutableAttributedString alloc] initWithString:@"温馨提示"];
        [one appendString:@"\n"];
        one.font = [UIFont boldSystemFontOfSize:14];
        one.color = [UIColor grayColor];
        one.lineSpacing = 10;
        [text appendAttributedString:one];
        [text appendAttributedString:[self padding]];
    }
    for (NSString* msg in textMsgs) {
        
        
        {
            NSMutableAttributedString* one = [[NSMutableAttributedString alloc] initWithString:@"■"];
            one.font = [UIFont boldSystemFontOfSize:12];
            one.color = [UIColor redColor];
            [text appendAttributedString:one];
        }
        
        {
            NSMutableAttributedString* one = [[NSMutableAttributedString alloc] initWithString:msg];
            
            [one appendString:@"\n"];
            [one appendString:@"\n"];
            one.font = [UIFont systemFontOfSize:14];
            one.color = [UIColor grayColor];
            [text appendAttributedString:one];
        }
    }
    self.attributedText = text;
    self.numberOfLines = 0;
}

- (NSAttributedString*)padding
{
    NSMutableAttributedString* pad = [[NSMutableAttributedString alloc] initWithString:@""];
    pad.font = [UIFont systemFontOfSize:4];
    return pad;
}


@end
