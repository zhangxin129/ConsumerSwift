//
//  GYHEMapSelectAddressHeaderView.h
//  HSConsumer
//
//  Created by zhengcx on 16/10/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHEMapSelectAddressHeaderViewDelegate<NSObject>

@optional

- (void)searchLocalClickDelegate;

@end

@interface GYHEMapSelectAddressHeaderView : UIView

@property (strong, nonatomic) IBOutlet UIView *textFieldBackView;

@property (strong, nonatomic) IBOutlet UITextField *searchLocalTextField;

@property (nonatomic, weak) id<GYHEMapSelectAddressHeaderViewDelegate> delegate;

@end


