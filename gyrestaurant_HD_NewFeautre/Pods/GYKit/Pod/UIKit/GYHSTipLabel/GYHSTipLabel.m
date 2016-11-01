//
//  GYHSTipLabel.m
//  Pods
//
//  Created by sqm on 16/6/16.
//
//

#import "GYHSTipLabel.h"

@implementation GYHSTipLabel
- (void)setTextMsgs:(NSArray *)textMsgs
{
    _textMsgs = textMsgs;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]init];
    {
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"温馨提示"];
        one.font = [UIFont boldSystemFontOfSize:14];
        one.color = [UIColor grayColor];
        [text appendAttributedString:one];
          [text appendAttributedString:[self padding]];
        
    }
    for (NSString *msg in textMsgs) {
        {
            NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"■"];
            one.font = [UIFont boldSystemFontOfSize:14];
            one.color = [UIColor redColor];
            [text appendAttributedString:one];
         
        }
        
        {
            NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:msg];
            one.font = [UIFont boldSystemFontOfSize:15];
            one.color = [UIColor grayColor];
            [text appendAttributedString:one];
            [text appendAttributedString:[self padding]];
        }
        
    }
    self.attributedText = text;
    
}

- (NSAttributedString *)padding {
    NSMutableAttributedString *pad = [[NSMutableAttributedString alloc] initWithString:@""];
    pad.font = [UIFont systemFontOfSize:4];
    return pad;
}


@end
