//
//  GYHSGeneralButtonCell.h
//  HSConsumer
//
//  Created by lizp on 16/7/4.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHSGeneralButtonCellDelegate <NSObject>

- (void)nextBtn;

@end

@interface GYHSGeneralButtonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton* loginoutBtn;
@property (nonatomic, weak) id<GYHSGeneralButtonCellDelegate> delegate;

@end
