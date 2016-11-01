//
//  GYHEHeadViewFifthCell.h
//  HSConsumer
//
//  Created by 吴文超 on 16/10/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHEHeadViewFifthCell : UITableViewCell
//文字 申请赠送互生卡
@property (weak, nonatomic) IBOutlet UILabel *showHasHscardLabel;

//滑块 判断是否愿意

@property (weak, nonatomic) IBOutlet UISwitch *wantOrNotNeedHSCard;


@end
