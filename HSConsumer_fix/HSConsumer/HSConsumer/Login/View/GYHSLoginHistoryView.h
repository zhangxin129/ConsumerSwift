//
//  GYHSLoginHistoryView.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHSLoginHistoryViewDelegate <NSObject>

- (void)historyViewState:(BOOL)show;

- (void)selectHSNumber:(NSString*)number;

- (void)deleteHSNumber:(NSString*)number;

@end

@interface GYHSLoginHistoryView : UIView

@property (nonatomic, weak) id<GYHSLoginHistoryViewDelegate> historyDelegate;

- (instancetype)initWithView:(UIView*)view dataArray:(NSArray*)dataArray;

- (void)show;

@end
