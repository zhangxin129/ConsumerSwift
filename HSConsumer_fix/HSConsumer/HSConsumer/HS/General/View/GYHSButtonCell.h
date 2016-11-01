//
//  GYHSButtonCell.h
//  GYHSConsumer_MyHS
//
//  Created by ios007 on 16/3/21.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GYHSButtonCellDelegate <NSObject>
- (void)nextBtn;
@end

@interface GYHSButtonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton* btnTitle;
@property (weak, nonatomic) id<GYHSButtonCellDelegate> btnDelegate;
@end
