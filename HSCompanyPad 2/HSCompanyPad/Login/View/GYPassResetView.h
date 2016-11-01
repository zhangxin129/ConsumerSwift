//
//  GYPassResetView.h
//  HSCompanyPad
//
//  Created by User on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYPassResetView : UIView
@property (weak, nonatomic) IBOutlet UIView *passBackView;

@property (weak, nonatomic) IBOutlet UIView *passResetBackView;

@property (weak, nonatomic) IBOutlet UITextField *passNewTF;

@property (weak, nonatomic) IBOutlet UITextField *passConfirmTF;

@property (weak, nonatomic) IBOutlet UILabel *tintLabel;

@end
