//
//  GYHDEmojiView.h
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//  表情选择

#import <UIKit/UIKit.h>

@class GYHDEmojiChooseView;
@protocol GYHDEmojiChooseViewDelegate <NSObject>
- (void)GYHDEmojiView:(GYHDEmojiChooseView*)emojiView selectEmojiName:(NSString*)emojiName;
@end

@interface GYHDEmojiChooseView : UIView
@property(nonatomic, weak)id<GYHDEmojiChooseViewDelegate> delegate;
@property(nonatomic,assign)BOOL isCompany;//是否为企业操作员界面
- (instancetype)initWithFrame:(CGRect)frame isCompany:(BOOL)isCompany ;
@end
