//
//  GYHSSelectCardTypeView.h
//  HSCompanyPad
//
//  Created by apple on 16/8/18.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYHSCardTypeModel;

@protocol GYHSSelectCardTypeViewDelegate <NSObject>

- (void)transSlectModel:(GYHSCardTypeModel *)model;
- (void)customizeButtonAction;

@end

@interface GYHSSelectCardTypeView : UIView

@property (nonatomic, strong) NSMutableArray *staTypeArray;
@property (nonatomic, strong) NSMutableArray *perTypeArray;
@property (nonatomic, weak) id<GYHSSelectCardTypeViewDelegate> delegate;

@end
