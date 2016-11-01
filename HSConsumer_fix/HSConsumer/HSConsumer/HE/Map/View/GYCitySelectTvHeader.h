//
//  GYCitySelectTvHeader.h
//  HSConsumer
//
//  Created by apple on 15-5-5.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYCitySelectTvHeader : UIView
//__weak IBOutlet UILabel *lbHotCity;//热门城市
//
//__weak IBOutlet UIButton *btn1;//城市
//
//__weak IBOutlet UIButton *Btn2;//城市
//
//__weak IBOutlet UIButton *Btn3;//城市
//
//__weak IBOutlet UIButton *Btn4;//城市
//
//__weak IBOutlet UIButton *Btn5;//城市
//
//__weak IBOutlet UIButton *Btn6;//城市
//
//__weak IBOutlet UIButton *Btn7;//城市
//
//__weak IBOutlet UIButton *Btn8;//城市
//
//__weak IBOutlet UIButton *Btn9;//城市
//
//__weak IBOutlet UILabel *lbAllCity;//全部城市
//
//__weak IBOutlet UILabel *lbLocationCity;//定位城市
//
//__weak IBOutlet UIButton *BtnLocationCity;//定位城市

@property (weak, nonatomic) IBOutlet UILabel* lbLocationCity;
@property (weak, nonatomic) IBOutlet UIButton* BtnLocationCity;
@property (weak, nonatomic) IBOutlet UILabel* lbAllCity;
@property (weak, nonatomic) IBOutlet UILabel* lbHotCity;
@property (weak, nonatomic) IBOutlet UILabel* lbseachCity;
@property (weak, nonatomic) IBOutlet UIButton* btn1;
@property (weak, nonatomic) IBOutlet UIButton* Btn2;
@property (weak, nonatomic) IBOutlet UIButton* Btn3;
@property (weak, nonatomic) IBOutlet UIButton* Btn4;
@property (weak, nonatomic) IBOutlet UIButton* Btn5;
@property (weak, nonatomic) IBOutlet UIButton* Btn6;
@property (weak, nonatomic) IBOutlet UIButton* Btn7;
@property (weak, nonatomic) IBOutlet UIButton* Btn8;
@property (weak, nonatomic) IBOutlet UIButton* Btn9;

@property (weak, nonatomic) IBOutlet UIButton* Btn10;
@property (weak, nonatomic) IBOutlet UIButton* Btn11;
@property (weak, nonatomic) IBOutlet UIButton* Btn12;
@property (weak, nonatomic) IBOutlet UIButton* Btn13;
@property (weak, nonatomic) IBOutlet UIButton* Btn14;

@property (nonatomic, strong) NSArray *histyArry;
+ (id)headerView;
- (void)setLocationBtn:(NSString *)cityTitle;

@end
