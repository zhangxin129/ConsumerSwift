//
//  GYPassQuestionView.h
//  HSCompanyPad
//
//  Created by User on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYSelectedButton.h"

@interface GYPassQuestionView : UIView

@property (weak, nonatomic) IBOutlet GYSelectedButton *questionBtn;
@property (weak, nonatomic) IBOutlet UITextField *answerTF;

@property (weak, nonatomic) IBOutlet UIImageView *questionImageView;
@property (weak, nonatomic) IBOutlet UIImageView *answerImageView;

@property (weak, nonatomic) IBOutlet UIView *questionBackView;

@property (weak, nonatomic) IBOutlet UIView *answerBackView;

@end
