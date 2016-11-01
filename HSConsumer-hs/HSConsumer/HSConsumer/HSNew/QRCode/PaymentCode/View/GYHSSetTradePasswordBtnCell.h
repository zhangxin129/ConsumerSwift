//
//  GYHSSetTradePasswordBtnCell.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHSImmediatelySetDelegate <NSObject>
@optional

- (void)immediatelySetButton;

@end
@interface GYHSSetTradePasswordBtnCell : UITableViewCell
@property(nonatomic,weak)id<GYHSImmediatelySetDelegate> immediatelyDelegate;
@property (weak, nonatomic) IBOutlet UILabel *tradePasswordLb;
@property (weak, nonatomic) IBOutlet UIButton *setBtn;
@end
