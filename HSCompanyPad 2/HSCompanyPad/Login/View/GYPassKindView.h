//
//  GYPassKindView.h
//  HSCompanyPad
//
//  Created by User on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ForgetPassType) {
    kForgetPassType_Phone = 0, //手机号
    kForgetPassType_Mail ,    //邮箱
    kForgetPassType_Question,    //密保问题找回
  
};

@protocol PassKindDelegate <NSObject>

-(void)didSelectPassKind:(ForgetPassType)type;


@end

@interface GYPassKindView : UIView
@property (weak, nonatomic) IBOutlet UIView *phoneBackView;

@property (weak, nonatomic) IBOutlet UIView *mailBackView;

@property (weak, nonatomic) IBOutlet UIView *questionBackView;

@property (weak, nonatomic) IBOutlet UIImageView *phoneImageView;

@property (weak, nonatomic) IBOutlet UIImageView *mailImageView;

@property (weak, nonatomic) IBOutlet UIImageView *questionImageView;

@property (weak, nonatomic) IBOutlet UIButton *phoneSelectBtn;

@property (weak, nonatomic) IBOutlet UIButton *mailBtn;

@property (weak, nonatomic) IBOutlet UIButton *questionBtn;

@property (nonatomic,assign) ForgetPassType selectType;

@property (nonatomic,weak) id<PassKindDelegate> delegate;

@end
