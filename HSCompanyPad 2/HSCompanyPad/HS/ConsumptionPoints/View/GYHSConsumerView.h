//
//  GYHSConsumerView.h
//  HSCompanyPad
//
//  Created by 梁晓辉 on 16/7/27.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYHSPointInputView;
@protocol GYHSConsumerDelegate <NSObject>

- (void)popSetPointRate;

@end
@interface GYHSConsumerView : UIView
@property (nonatomic, weak) GYHSPointInputView* consumView;
@property (nonatomic, weak) GYHSPointInputView* realView;
@property (nonatomic, weak) GYHSPointInputView* HSBView;
@property (nonatomic, weak) GYHSPointInputView* pointView;
@property (nonatomic, strong) UIButton* volumeBtn;
@property (nonatomic, copy) NSString * volumeAmount;
@property (nonatomic, copy) NSString * volumePage;
@property (nonatomic, copy) NSString* pointRate;
@property (nonatomic, copy) dispatch_block_t cleanBlock;
@property (nonatomic, weak) id<GYHSConsumerDelegate> delegate;
@end
