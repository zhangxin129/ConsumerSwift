//
//  GYHSBankAccountCell.h
//  HSCompanyPad
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHSEdgeLabel.h"
static NSString * bankAccountCell = @"bankAccountCell";
@interface GYHSBankAccountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet GYHSEdgeLabel *bankLeftLabel;
@property (weak, nonatomic) IBOutlet GYHSEdgeLabel *bankRightLabel;

@end
