//
//  GYHESCChooseAreaTableViewCell.h
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/3/24.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHESCChooseAreaModel.h"

@interface GYHESCChooseAreaTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* addressLabel; //地址
@property (weak, nonatomic) IBOutlet UILabel* telphoneLabel; //号码

- (void)refreshDataWithModel:(GYHESCChooseAreaModel*)model;

@end
