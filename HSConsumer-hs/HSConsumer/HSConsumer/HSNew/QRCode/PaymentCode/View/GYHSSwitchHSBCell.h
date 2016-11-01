//
//  GYHSSwitchHSBCell.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHSSwitchHSBDelegate <NSObject>
@optional

-(void)hsbSwitch:(UISwitch*)hsbswitch indextPath:(NSIndexPath*)indexPath;
- (void)switchtextField:(NSString*)string indextPath:(NSIndexPath*)indexPath;
@end
@interface GYHSSwitchHSBCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *HSBSwitch;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (nonatomic, strong) NSIndexPath* indexpath;
@property(nonatomic,weak)id<GYHSSwitchHSBDelegate> switchHSBDelegate;
@property (nonatomic,assign)NSInteger textFiledlength;
@end
