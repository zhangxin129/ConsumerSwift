//
//  GYHSLableTextFileTableViewCell.h
//  GYHSConsumer_MyHS
//
//  Created by ios007 on 16/3/21.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GYHSLableTextFileTableViewCellDeleget <NSObject>
@optional
- (void)textField:(NSString*)string indextPath:(NSIndexPath*)indexPath;
@end

@interface GYHSLableTextFileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* titlelabelWith;
@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet UITextField* textField;
@property (weak, nonatomic) id<GYHSLableTextFileTableViewCellDeleget> textFiledDegelte;
@property (nonatomic, strong) NSIndexPath* indexpath;
@property (weak, nonatomic) IBOutlet UILabel *toplinelb;
@property (weak, nonatomic) IBOutlet UILabel *bottomlb;
@property (nonatomic,assign)NSInteger textFiledlength;

@end
