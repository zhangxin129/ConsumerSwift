//
//  GYHSPostscriptCertificationCell.h
//  HSConsumer
//
//  Created by xiaoxh on 16/8/16.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHSPostscriptCertificationCellDelegate <NSObject>


- (void)inputPostscriptValue:(NSString*)value;

@end

@interface GYHSPostscriptCertificationCell : UITableViewCell
@property (nonatomic, weak) id<GYHSPostscriptCertificationCellDelegate> postscriptDelegate;
-(void)postscriptlbText:(NSString*)postscriptlb
      placeholderlbText:(NSString*)placeholderlb
         tfTextViewText:(NSString*)tfTextView
       ;
@end
