//
//  GYHDInputView.m
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDInputView.h"
#import "GYHDReplyChooseView.h"
#import "GYHDMoreChooseView.h"
#import "GYHDEmojiChooseView.h"
#import "GYHDAudioChooseView.h"
#import "GYHDInputTextView.h"
#import "GYHDUtils.h"
//#import "GYHDReplyChooseModel.h"
#import "GYHDReplyModel.h"
#import "GYHDNetWorkTool.h"

@interface GYHDInputView ()<UITextViewDelegate,GYHDMoreChooseViewDelegate,GYHDEmojiChooseViewDelegate,GYHDAudioChooseViewDelegate,GYHDReplyChooseViewDelegate>
@property(nonatomic, strong)UIButton *moreButton;
@property(nonatomic, strong)UIButton *audioButton;
@property(nonatomic, strong)UIButton *emojiButton;
@property(nonatomic, strong)UIButton *replyButton;
@property(nonatomic, weak)  UIButton *selectButton;
@property(nonatomic, strong)GYHDInputTextView *hdInputTextView;
@property(nonatomic, strong)GYHDMoreChooseView  *moreView;
@property(nonatomic, strong)GYHDAudioChooseView *audioView;
@property(nonatomic, strong)GYHDEmojiChooseView *emojiView;
@property(nonatomic, strong)GYHDReplyChooseView *replyView;
@property(nonatomic, assign)BOOL hidenKeyBoard;
@property(nonatomic, strong)UIButton *sendButton;
@end

@implementation GYHDInputView

- (instancetype)initWithFrame:(CGRect)frame isCompany:(BOOL)isCompany{
    if (self = [super initWithFrame:frame]) {
        self.isCompany=isCompany;
        [self setup];
        [self setupAuto];
    }
    return self;
}
- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.moreButton setBackgroundImage:[UIImage imageNamed:@"gyhd_chat_more_choose_btn_normal"] forState:UIControlStateNormal];
    [self.moreButton setBackgroundImage:[UIImage imageNamed:@"gyhd_chat_more_choose_btn_select"] forState:UIControlStateSelected];
    [self.moreButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.moreButton];
    
    self.audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.audioButton setBackgroundImage:[UIImage imageNamed:@"gyhd_chat_audio_choose_btn_normal"] forState:UIControlStateNormal];
    [self.audioButton setBackgroundImage:[UIImage imageNamed:@"gyhd_chat_audio_choose_btn_select"] forState:UIControlStateSelected];
    [self.audioButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.audioButton];
    
    self.emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.emojiButton setBackgroundImage:[UIImage imageNamed:@"gyhd_chat_emoji_choose_btn_normal"] forState:UIControlStateNormal];
    [self.emojiButton setBackgroundImage:[UIImage imageNamed:@"gyhd_chat_emoji_choose_btn_select"] forState:UIControlStateSelected];
    [self.emojiButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.emojiButton];
    
    self.replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.replyButton setBackgroundImage:[UIImage imageNamed:@"gyhd_chat_reply_choose_btn_normal"] forState:UIControlStateNormal];
    [self.replyButton setBackgroundImage:[UIImage imageNamed:@"gyhd_chat_reply_choose_btn_select"] forState:UIControlStateSelected];
    [self.replyButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.replyButton];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setBackgroundImage:[UIImage imageNamed:@"gyhd_send_btn_normal"] forState:UIControlStateNormal];
    [self.sendButton setBackgroundImage:[UIImage imageNamed:@"gyhd_send_btn_highlighted"] forState:UIControlStateHighlighted];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sendButton];
    

    self.hdInputTextView = [[GYHDInputTextView alloc] init];
    self.hdInputTextView.delegate = self;
    self.hdInputTextView.numberOfLines = 3;
    [self addSubview:self.hdInputTextView];
    
    self.moreView = [[GYHDMoreChooseView alloc] init];
    self.moreView.backgroundColor = [UIColor whiteColor];
    self.moreView.delegage=self;
    [self addSubview:self.moreView];
    
    self.audioView = [[GYHDAudioChooseView alloc] init];
    self.audioView.delegate = self;
    self.audioView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.audioView];
    
    self.emojiView = [[GYHDEmojiChooseView alloc] initWithFrame:self.bounds isCompany:self.isCompany];
    self.emojiView.backgroundColor = [UIColor whiteColor];
    self.emojiView.delegate = self;
    [self addSubview:self.emojiView];
    self.replyView = [[GYHDReplyChooseView alloc] init];
    self.replyView.delegate = self;
    self.replyView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.replyView];
    

    self.hidenKeyBoard = YES;


}
- (void)setupAuto {
    @weakify(self);
    [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(260);
    }];
    [self.audioView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(260);
    }];
    [self.emojiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(260);
    }];
    [self.replyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(260);
    }];

    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.moreView.mas_top).offset(-16);
        make.left.mas_equalTo(25);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    [self.audioButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.moreView.mas_top).offset(-16);
        make.left.equalTo(self.moreButton.mas_right).offset(25);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.emojiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.moreView.mas_top).offset(-16);
        make.left.equalTo(self.audioButton.mas_right).offset(25);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
//    企业进入屏蔽快捷回复
    if (self.isCompany) {
        
        [self.replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.bottom.equalTo(self.moreView.mas_top).offset(-16);
            make.left.equalTo(self.emojiButton.mas_right).offset(25);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        
    }else{

        [self.replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.bottom.equalTo(self.moreView.mas_top).offset(-16);
            make.left.equalTo(self.emojiButton.mas_right).offset(25);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
    }

    
    [self.hdInputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.moreView.mas_top).offset(-16);
        make.left.equalTo(self.replyButton.mas_right).offset(25);
        make.right.equalTo(self.sendButton.mas_left).offset(-25);
        make.height.mas_equalTo(36);
        make.top.mas_equalTo(16);
    }];

    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.replyButton);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(70, 33));
    }];
}
- (void)btnClick:(UIButton *)btn {
    btn.selected = !btn.selected;

    if (![btn isEqual:self.selectButton]) {
        self.selectButton.selected = NO;
        self.selectButton =btn;
        if ([btn isEqual:self.moreButton]) {//更多（视频、图片……）
            [self bringSubviewToFront:self.moreView];
        }else if ([btn isEqual:self.audioButton]) {//音频
            
            [self bringSubviewToFront:self.audioView];
        }else if ([btn isEqual:self.emojiButton]) {//表情
            
            [self bringSubviewToFront:self.emojiView];
        }else if ([btn isEqual:self.replyButton]) {//快捷回复
            
//            NSArray *arry = [[GYHDDataBaseCenter sharedInstance] selectAllQuickReply];
//            NSMutableArray *riArray = [NSMutableArray array];
//            for (NSDictionary *replyDict in arry) {
//                GYHDReplyChooseModel *model = [[GYHDReplyChooseModel alloc] init];
//                model.titleString = replyDict[GYHDDataBaseCenterQuickReplyTitle];
//                model.detailString = replyDict[GYHDDataBaseCenterQuickReplyContent] ;
//                [riArray addObject:model];
//            }
//            self.replyView.dataArray = riArray;
            
            @weakify(self);
            [[GYHDNetWorkTool sharedInstance] queryQuickReplyMsgByCustIdWithDict:nil RequetResult:^(NSArray *resultArry) {
                @strongify(self);
                DDLogInfo(@"%@",resultArry);
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *replyDict in resultArry) {
                    GYHDReplyModel *model = [[GYHDReplyModel alloc] init];
                    model.titleString =  replyDict[GYHDDataBaseCenterQuickReplyTitle];
                    model.createTimeString = replyDict[GYHDDataBaseCenterQuickReplyCreateTimeStr];
                    model.updateTimeString =  replyDict[GYHDDataBaseCenterQuickReplyUpdateTimeStr];
                    model.contentString =  replyDict[GYHDDataBaseCenterQuickReplyContent];
                    model.messageID =  replyDict[GYHDDataBaseCenterQuickReplyMsgId];
                    model.isDefault =  replyDict[GYHDDataBaseCenterQuickReplyIsDefault];
                    model.entCustID =  replyDict[GYHDDataBaseCenterQuickReplyCustId];
                    [array addObject:model];
                }
                self.replyView.dataArray  = array;
                [self bringSubviewToFront:self.replyView];
            }];
            
        }
    }
    if (btn.selected) {
        self.hidenKeyBoard = NO;
        [self.hdInputTextView endEditing:YES];
        [self show];
    }else {
        [self disMiss];
    }
    self.hidenKeyBoard = YES;
}

- (void)sendBtnClick {
    if (self.hdInputTextView.attributedText.length ) {
        if ([self.delegate respondsToSelector:@selector(GYHDInputView:sendModel:SendType:)]) {
            GYHDSendModel *model = [[GYHDSendModel alloc] init];
            model.sendAttString = self.hdInputTextView.attributedText;
            [self.delegate GYHDInputView:self sendModel:model SendType:GYHDInputeViewSendText];
        }
        self.hdInputTextView.attributedText = nil;
    }
}

- (void)show {
    DDLogInfo(@"显示1");
    [UIView animateWithDuration:0.25f animations:^{
        if (![self.selectButton isEqual:self.moreButton]) {
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
            }];
        }else {
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(100);
            }];
        }
        [self layoutIfNeeded];

    }];
    if ([self.delegate respondsToSelector:@selector(GYHDInputViewFrameDidChange:)]) {
        [self.delegate GYHDInputViewFrameDidChange:self];
    }


}
- (void)disMiss {
//    DDLogInfo(@"隐藏1");

    if (self.hidenKeyBoard) {
        self.selectButton.selected = NO;
        self.selectButton = nil;
        [self.hdInputTextView endEditing:YES];
        [UIView animateWithDuration:0.25f animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(260);
            }];
            [self layoutIfNeeded];
        }];
        
        if ([self.delegate respondsToSelector:@selector(GYHDInputViewFrameDidChange:)]) {
            [self.delegate GYHDInputViewFrameDidChange:self];
        }
    }
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView {    //有
    self.selectButton.selected = NO;
    self.selectButton = nil;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self sendBtnClick];
        return NO;
    }
    return YES;
}

#pragma mark - GYHDMoreChooseViewDelegate
-(void)GYHDMoreChooseViewSendMessageWith:(GYHDInputeViewSendType)type{
    if ([self.delegate respondsToSelector:@selector(GYHDInputView:sendModel:SendType:)]) {
        [self.delegate GYHDInputView:self sendModel:nil SendType:type];
    }
    
}
- (void)GYHDEmojiView:(GYHDEmojiChooseView*)emojiView selectEmojiName:(NSString*)emojiName {
    UIImage* image = [UIImage imageNamed:emojiName];
    if ([emojiName isEqualToString:@"078"] || [emojiName isEqualToString:@"088"]) {
        
    }else{
    
        if (!image && [emojiName integerValue] > 60)
            return;
    
    }
    NSMutableAttributedString* attr = [[NSMutableAttributedString alloc] initWithAttributedString:self.hdInputTextView.attributedText];
    NSRange selectRange = self.hdInputTextView.selectedRange;
    if ([emojiName isEqualToString:@"044"] ||
        [emojiName isEqualToString:@"088"] ||
        [emojiName isEqualToString:@"078"]) {
        if (!selectRange.location)
            return;
        CGFloat location = selectRange.location - 1;
        [attr deleteCharactersInRange:NSMakeRange(location, 1)];
        selectRange = NSMakeRange(selectRange.location - 1, selectRange.length);
    }
    else {
        selectRange = NSMakeRange(selectRange.location + 1, selectRange.length);
        NSAttributedString *imageAttr = [GYHDUtils EmojiAttributedStringFromString:[NSString stringWithFormat:@"[%@]", emojiName]];
        [attr insertAttributedString:imageAttr
                             atIndex:self.hdInputTextView.selectedRange.location];

    }
    self.hdInputTextView.attributedText = attr;
    self.hdInputTextView.selectedRange = selectRange;
}
- (void)GYHDAudioChooseView:(GYHDAudioChooseView *)audioChooseView sendModel:(GYHDSendModel *)model {
    if ([self.delegate respondsToSelector:@selector(GYHDInputView:sendModel:SendType:)]) {
        [self.delegate GYHDInputView:self sendModel:model SendType:GYHDInputeViewSendAudio];
    }
}
- (void)GYHDReplyChooseView:(GYHDReplyChooseView *)view DidSelectWithString:(NSString *)string {
    self.hdInputTextView.attributedText = [[NSAttributedString alloc] initWithString:string];
}
@end
