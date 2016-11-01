//
//  GYHSPurchaseAddressCell.h
//  HSCompanyPad
//
//  Created by apple on 16/8/16.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYHSAddressListModel;
@protocol GYHSOperateAddressDelegate <NSObject>

- (void)deleteAction:(GYHSAddressListModel *)model;
- (void)changeAction:(GYHSAddressListModel *)model;

@end


@interface GYHSPurchaseAddressCell : UITableViewCell

@property (nonatomic, strong) GYHSAddressListModel *model;
@property (nonatomic, weak) id<GYHSOperateAddressDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end
