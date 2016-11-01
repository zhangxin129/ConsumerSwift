//
//  GYLoginView.h
//  HSCompanyPad
//
//  Created by User on 16/8/1.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LoginType) {
    
    kLoginCompanyType = 1, //企业号 用户名登录
    kLoginHSCardType = 2 //绑定互生卡登录
};

@class GYLoginView;
@protocol GYLoginViewDelegate <NSObject>

@required
/**使用互生卡登录 userName为空，否则不为空*/
- (void)loginView:(GYLoginView *) loginView  resNo:(NSString*)resNo userName:(NSString*)username password:(NSString*)password;

@end

@interface GYLoginView : UIView<UITextFieldDelegate>

@property (nonatomic, weak) id<GYLoginViewDelegate> delegate;
- (void)show;
- (void)dismiss;

-(void)showWrongLabel;
-(void)hideWrongLabel;

@end
