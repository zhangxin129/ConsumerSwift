//
//  GYCustomerSerViceDetailView.h
//  HSCompanyPad
//
//  Created by apple on 16/10/12.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDManagementViewController.h"
#import "GYHDCustomerViewController.h"
@protocol GYCustomerSerViceDetailViewDelegate <NSObject>

- (void)hidenGYCustomerSerViceDetailView;

@end

@interface GYCustomerSerViceDetailView : UIView
@property(nonatomic,copy)NSString*sessionId;//会话id
@property(nonatomic,weak)id <GYCustomerSerViceDetailViewDelegate> delegate;
@property(nonatomic,strong) GYHDManagementViewController * managementVc;
@property(nonatomic,strong) GYHDCustomerViewController *customerVc;
@end
