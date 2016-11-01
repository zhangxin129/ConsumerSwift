//
//  GYHSBankAccountInputCell.h
//  HSCompanyPad
//
//  Created by 梁晓辉 on 16/8/14.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHSCunsumeTextField.h"
#import "GYHSEdgeLabel.h"
@class GYCityAddressModel,BankModel,GYHSBankAccountInputCell;
@protocol GYHSBankAccountDelegate <NSObject>
@optional
- (void)bankDefault:(NSString *)isdefault;
- (void)clickWithCell:(GYHSBankAccountInputCell *)cell textField:(UITextField *)textField tag:(NSInteger)tag;
@end
@interface GYHSBankAccountInputCell : UITableViewCell
@property (weak, nonatomic) IBOutlet GYHSCunsumeTextField *secondTextField;
@property (weak, nonatomic) IBOutlet GYHSCunsumeTextField *thirdRightField;

@property (nonatomic,weak) id<GYHSBankAccountDelegate> delegate;

+ (instancetype)tableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath dataArray:(NSMutableArray *)dataArray placeholderArray:(NSArray *)placeholderArray;

@end
