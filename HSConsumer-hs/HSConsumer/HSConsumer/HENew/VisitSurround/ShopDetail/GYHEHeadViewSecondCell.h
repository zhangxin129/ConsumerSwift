//
//  GYHEHeadViewSecondCell.h
//  HSConsumer
//
//  Created by 吴文超 on 16/10/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHEHeadViewSecondCell;
//代理方法 clickServiceOrder
@protocol GYHEHeadViewSecondCellDelegate <NSObject>
//刷新表
- (void)reloadData:(NSInteger)num;
@end






@interface GYHEHeadViewSecondCell : UITableViewCell

@property (nonatomic, weak) id<GYHEHeadViewSecondCellDelegate> delegate;
//描述文字
@property (weak, nonatomic) IBOutlet UILabel *titleLabelFirst;
//开关控件
@property (weak, nonatomic) IBOutlet UISwitch *switchSecond;




@end
