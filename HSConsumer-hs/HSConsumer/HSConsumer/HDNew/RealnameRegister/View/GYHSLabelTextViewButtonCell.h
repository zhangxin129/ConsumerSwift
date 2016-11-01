//
//  GYHSLabelTextViewButtonCell.h
//  HSConsumer
//
//  Created by xiaoxh on 16/8/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHSRealNameRegistrationCellDelegate <NSObject>

@optional

- (void)chooseSelectButton:(NSIndexPath*)indexPath;

- (void)inputRealNameValue:(NSString*)value indexPath:(NSIndexPath*)indexPath;

- (void)textViewDidBeginindexPath:(NSIndexPath*)indexPath;

-(void)emptyStarText:(NSIndexPath*)indexPath textView:(UITextView *)textView;;//置空带*文本
@end

@interface GYHSLabelTextViewButtonCell : UITableViewCell
@property (nonatomic, weak) id<GYHSRealNameRegistrationCellDelegate> realNameDelegate;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
-(void)LbLeftlabel:(NSString*)LbLeftlabeltext
       tfTextView:(NSString*)TextViewText
       Lbplaceholder:(NSString*)LbplaceholderText
       setBackgroundImageSelectButton:(NSString*)imageName
       tag:(NSIndexPath*)indexPath
       showSelectButton:(BOOL)showSelectButton
       textViewClick:(BOOL)textViewClick;

-(void)LicenceLbLeftlabel:(NSString*)LbLeftlabeltext
        tfTextView:(NSString*)TextViewText
     Lbplaceholder:(NSString*)LbplaceholderText
setBackgroundImageSelectButton:(NSString*)imageName
               tag:(NSIndexPath*)indexPath
  showSelectButton:(BOOL)showSelectButton
     textViewClick:(BOOL)textViewClick;
@end
