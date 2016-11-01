//
//  GYHDInputTextView.m
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/12.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDInputTextView.h"
#import "GYHDUtils.h"


@interface GYHDInputTextView()
@property(nonatomic, strong)UILabel  *placeholderLabel;
@property(nonatomic, assign)CGFloat maxFloat;
@property(nonatomic, assign)CGFloat minFloat;
@end

@implementation GYHDInputTextView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont systemFontOfSize:16];
        self.returnKeyType = UIReturnKeySend;
        self.placeholderLabel = [[UILabel alloc] init];
        self.placeholderLabel.text = kLocalized(@"GYHD_Please_Input_Chat_Content");
        self.placeholderLabel.font = [UIFont systemFontOfSize:16.0f];
        self.placeholderLabel.textColor = [UIColor colorWithHex:0xcccccc];
        [self addSubview:self.placeholderLabel];
        

        @weakify(self);
        [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(3);
        }];
        [self addObserver:self forKeyPath:@"attributedText" options:NSKeyValueObservingOptionNew context:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editChange:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.maxFloat) {
        self.maxFloat = self.numberOfLines   * self.font.lineHeight ;
        self.minFloat = self.bounds.size.height;
    }
    
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:)) {
        return YES;
    }
    else {
        return [super canPerformAction:action withSender:sender];
    }
}


- (void)paste:(id)sender
{
    NSRange range = self.selectedRange;
    UIPasteboard* board = [UIPasteboard generalPasteboard];
    if (board.string) {
        NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
         NSAttributedString *insertAttString = [GYHDUtils EmojiAttributedStringFromString:board.string];
        [attString insertAttributedString:insertAttString atIndex:self.selectedRange.location];
        self.attributedText = attString;
        self.selectedRange = NSMakeRange(range.location + insertAttString.length, 0);
    }
}
//***富文本监听*/
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    
    if ([keyPath isEqualToString:@"attributedText"]) {
        [self setupFrame];
    }

}
/**文字输入监听*/
- (void)editChange:(NSNotification *)noti {
    [self setupFrame];

}
- (void)setupFrame {
    self.font = self.placeholderLabel.font;
    if (!self.attributedText.length) {
        if (self.placeholderLabel.hidden) {
            self.placeholderLabel.hidden = NO;
        }
    }else {
        if (!self.placeholderLabel.hidden) {
            self.placeholderLabel.hidden = YES;
        }
    }
    [self scrollRangeToVisible:NSMakeRange(self.attributedText.length, 1)];
    CGFloat height = [GYHDUtils heightForAttString:self.attributedText widht:self.frame.size.width];
    if (height >= self.maxFloat) {
        height = self.maxFloat;
    } else if (height < self.minFloat) {
        height = self.minFloat;
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];

}
- (void)dealloc {
    [self removeObserver:self forKeyPath:@"attributedText"];
}

@end
//    if ([keyPath isEqualToString:@"attributedText"]) {
////        DDLogInfo(@"observeValueForKeyPath = %@ %ld",keyPath, self.attributedText.length);
//        if ([self.delegate respondsToSelector:@selector(GYHDInputTextView:textLength:)]) {
//            [self.delegate GYHDInputTextView:self textLength:self.attributedText.length];
//        }
//    }
//    if (self.contentSize.height < 70) {
//        if (self.scrollEnabled) {
//            self.scrollEnabled = NO;
//        }
//    }else {
//        if (!self.scrollEnabled) {
//            self.scrollEnabled = YES;
//        }
//    }
//    if (self.attributedText.length) {
//        if (self.placeholderLabel.hidden) {
//            self.placeholderLabel.hidden = NO;
//        }
//    }else {
//        if (!self.placeholderLabel.hidden) {
//            self.placeholderLabel.hidden = YES;
//        }
//    }
//    DDLogInfo(@"");
//    DDLogInfo(@"editChange = %@ %ld",@"xxx", self.attributedText.length);
//    if ([self.delegate respondsToSelector:@selector(GYHDInputTextView:textLength:)]) {
//        [self.delegate GYHDInputTextView:self textLength:self.attributedText.length];
//    }
//    if (self.contentSize.height < 70) {
//        if (self.scrollEnabled) {
//            self.scrollEnabled = NO;
//        }
//    }else {
//        if (!self.scrollEnabled) {
//            self.scrollEnabled = YES;
//        }
//    }
//    if (self.attributedText.length) {
//        if (self.placeholderLabel.hidden) {
//            self.placeholderLabel.hidden = NO;
//        }
//    }else {
//        if (!self.placeholderLabel.hidden) {
//            self.placeholderLabel.hidden = YES;
//        }
//    }

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    self.hdInputTextView.font = [UIFont systemFontOfSize:16.0f];
//    self.hdInputTextView.textColor = [UIColor redColor];
//    if ([text isEqualToString:@""]) {   // 删除
//        if (self.hdInputTextView.contentSize.height < 70) {
//            if (self.hdInputTextView.scrollEnabled) {
//                self.hdInputTextView.scrollEnabled = NO;
//                @weakify(self);
//                [self.hdInputTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                    @strongify(self);
//                    make.bottom.equalTo(self.moreView.mas_top).offset(-16);
//                    make.left.equalTo(self.replyButton.mas_right).offset(25);
//                    make.right.equalTo(self.sendButton.mas_left).offset(-25);
//                    make.top.mas_equalTo(16);
//                }];
//                
//            }
//        }
//        if (self.hdInputTextView.text.length == 1) {
//            self.placeholderLabel.hidden = NO;
//        }else {
//            self.placeholderLabel.hidden = YES;
//        }
//    }else {
//        self.placeholderLabel.hidden = YES;
//    }
//    [self.hdInputTextView scrollRangeToVisible:NSMakeRange(self.hdInputTextView.text.length, 1)];
//    return YES;
//}
//- (void)textDidEdit:(NSNotification *)noti {
//    DDLogInfo(@"%@, %@, %@",NSStringFromCGSize(self.hdInputTextView.contentSize),NSStringFromCGPoint(self.hdInputTextView.contentOffset),NSStringFromCGPoint(self.hdInputTextView.center));
//    if (self.hdInputTextView.contentSize.height  > 60) {
//        self.hdInputTextView.scrollEnabled = YES;
//    }else {
//        if (self.hdInputTextView.scrollEnabled) {
//            self.hdInputTextView.scrollEnabled = NO;
//            @weakify(self);
//            [self.hdInputTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                @strongify(self);
//                make.bottom.equalTo(self.moreView.mas_top).offset(-16);
//                make.left.equalTo(self.replyButton.mas_right).offset(25);
//                make.right.equalTo(self.sendButton.mas_left).offset(-25);
//                make.top.mas_equalTo(16);
//            }];
//            
//        }
//        
//    }
//    if (self.hdInputTextView.text.length == 0) {
//        self.placeholderLabel.hidden = NO;
//        self.hdInputTextView.scrollEnabled = NO;
//        @weakify(self);
//        [self.hdInputTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            @strongify(self);
//            make.bottom.equalTo(self.moreView.mas_top).offset(-16);
//            make.left.equalTo(self.replyButton.mas_right).offset(25);
//            make.right.equalTo(self.sendButton.mas_left).offset(-25);
//            make.top.mas_equalTo(16);
//        }];
//        
//    }else {
//        self.placeholderLabel.hidden = YES;
//    }
//    [self.hdInputTextView scrollRangeToVisible:NSMakeRange(self.hdInputTextView.text.length, 1)];
//}
//- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
//{
//    if ([keyPath isEqualToString:@"contentSize"] ||
//        [keyPath isEqualToString:@"attributedText"]) {
//        if (self.hdInputTextView.contentSize.height  > 60) {
//            self.hdInputTextView.scrollEnabled = YES;
//        }else {
//            if (self.hdInputTextView.scrollEnabled) {
//                @weakify(self);
//                [self.hdInputTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                    @strongify(self);
//                    make.bottom.equalTo(self.moreView.mas_top).offset(-16);
//                    make.left.equalTo(self.replyButton.mas_right).offset(25);
//                    make.right.equalTo(self.sendButton.mas_left).offset(-25);
//                    make.top.mas_equalTo(16);
//                }];
//                self.hdInputTextView.scrollEnabled = NO;
//            }
//        }
//        if (self.hdInputTextView.text.length == 0) {
//            self.placeholderLabel.hidden = NO;
//            @weakify(self);
//            [self.hdInputTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                @strongify(self);
//                make.bottom.equalTo(self.moreView.mas_top).offset(-16);
//                make.left.equalTo(self.replyButton.mas_right).offset(25);
//                make.right.equalTo(self.sendButton.mas_left).offset(-25);
//                make.top.mas_equalTo(16);
//            }];
//        }else {
//            self.placeholderLabel.hidden = YES;
//        }
//        [self.hdInputTextView scrollRangeToVisible:NSMakeRange(self.hdInputTextView.text.length, 1)];
//    }
//}

