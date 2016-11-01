//
//  GYTicketAccountCell.h
//  HSConsumer
//
//  Created by xiongyn on 16/9/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYTicketAccountCell;

@protocol GYTicketAccountCellDelegate <NSObject>

- (void)showDidUseTicket:(GYTicketAccountCell *)cell;

@end

@interface GYTicketAccountCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ticketTypeTextLab;
@property (weak, nonatomic) IBOutlet UILabel *ticketValueTextLab;
@property (weak, nonatomic) IBOutlet UILabel *canUseTextLab;
@property (weak, nonatomic) IBOutlet UILabel *didUseTextLab;
@property (weak, nonatomic) IBOutlet UILabel *timeTextLab;

@property (nonatomic, weak) id<GYTicketAccountCellDelegate> delegate;

@end
