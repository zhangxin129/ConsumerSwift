//
//  GYHSMemberBankCell.h
//  HSCompanyPad
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHSEdgeLabel.h"
@class GYHSMemberBankCell;
@protocol GYHSBankCilckDelegate <NSObject>

- (void)selectBankClick:(UIButton *)button cell:(GYHSMemberBankCell *)cell;

@end
static NSString * memberBankCell = @"memberBankCell";
@interface GYHSMemberBankCell : UITableViewCell
@property (weak, nonatomic) IBOutlet GYHSEdgeLabel *leftLabel;
@property (weak, nonatomic) IBOutlet GYHSEdgeLabel *rightLabel;
@property (nonatomic, assign) BOOL isShowBtn;
@property (nonatomic, weak) id<GYHSBankCilckDelegate> delegate;
@end
