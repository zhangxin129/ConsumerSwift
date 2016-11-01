//
//  GYHSInfoNormalCell.h
//  HSConsumer
//
//  Created by zhangqy on 16/4/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHSInfoNormalCellDelegate <NSObject>

- (void)inputTextField:(NSString*)value indexPath:(NSIndexPath*)indexPath;

@end

@interface GYHSInfoNormalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet UITextField* textField;
@property (weak, nonatomic) IBOutlet UIImageView* arrowImageView;
@property (strong, nonatomic) NSIndexPath* indexPath;

@property (nonatomic, weak) id<GYHSInfoNormalCellDelegate> cellDelegate;

@end
