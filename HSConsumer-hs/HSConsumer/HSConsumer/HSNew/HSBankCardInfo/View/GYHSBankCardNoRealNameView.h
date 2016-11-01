//
//  GYHSBankCardNoRealNameView.h
//  HSConsumer
//
//  Created by 吴文超 on 16/10/25.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GYHSBankCardNoRealNameViewDelegate<NSObject>

@optional

-(void)pushToRegistNameVC;



@end

@interface GYHSBankCardNoRealNameView : UIView
@property (nonatomic,weak) id<GYHSBankCardNoRealNameViewDelegate>delegate;
@end
