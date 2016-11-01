//
//  GYHDCompanyPersonInfoCell.h
//  GYRestaurant
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GYHDCompanyPersonInfoCellDelegate<NSObject>

-(void)getRowName:(NSString*)rowName TFtext:(NSString*)tfStr;

@end
@interface GYHDCompanyPersonInfoCell : UITableViewCell
@property(nonatomic,strong)UILabel*rowNameLabel;
@property(nonatomic,strong)UITextField* rowTF;
@property(nonatomic,weak)id<GYHDCompanyPersonInfoCellDelegate> delegate;
-(void)refreshWithDict:(NSDictionary*)dict;
@end
