//
//  GYForgetPassView.h
//  HSCompanyPad
//
//  Created by User on 16/8/2.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYPassKindView.h"
#import "GYPassPhoneView.h"
#import "GYPassMailView.h"
#import "GYPassQuestionView.h"
#import "GYPassResetView.h"
#import "GYSuccessView.h"

@interface GYForgetPassView : UIView<UITextFieldDelegate,UIScrollViewDelegate>


+(void)show;

@property (weak, nonatomic) IBOutlet UILabel *rateLabelOne;

@property (weak, nonatomic) IBOutlet UILabel *rateLabelTwo;

@property (weak, nonatomic) IBOutlet UILabel *rateLabelThree;

@property (weak, nonatomic) IBOutlet UILabel *rateLabelFour;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (nonatomic,assign) NSInteger step;//步骤数,默认为0
@property (weak, nonatomic) IBOutlet UIScrollView *bodyScrollView;


@property (nonatomic,strong) GYPassKindView *kindView;

@property (nonatomic,strong) GYPassPhoneView *phoneView;

@property (nonatomic,strong) GYPassMailView *mailView;

@property (nonatomic,strong) GYPassQuestionView *questionView;

@property (nonatomic,strong) GYPassResetView *resetView;

@property (nonatomic,strong) GYSuccessView *successView;

@end
