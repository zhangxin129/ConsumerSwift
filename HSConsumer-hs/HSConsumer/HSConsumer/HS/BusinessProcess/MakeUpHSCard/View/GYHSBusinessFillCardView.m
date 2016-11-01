//
//  GYHSBusinessFillCardView.m
//  HSConsumer
//
//  Created by lizp on 16/8/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kTextFont [UIFont systemFontOfSize:18]
#define kTextMarginLeft 15.0f
#define kTextMarginRight 15.0f
#define kTextMarginTop 15.0f


#import "GYHSBusinessFillCardView.h"
#import "GYUtils+HSConsumer.h"

@interface GYHSBusinessFillCardView()

@property (nonatomic,strong) YYLabel *nameLabel;
@property (nonatomic,strong) YYLabel *phoneLabel;
@property (nonatomic,strong) YYLabel *addressLabel;
@property (nonatomic,strong) UIView *addressInfoView;
@end


@implementation GYHSBusinessFillCardView


-(instancetype)init {
    if(self = [super init]) {
        [self setUp];
    }
    return self;
}

-(void)setUp  {
    
    self.backgroundColor = kDefaultVCBackgroundColor;

    //互生号行
    UIView *hsNumberView = [[UIView alloc] initWithFrame:CGRectMake(0, kTextMarginTop, kScreenWidth, 50)];
    hsNumberView.backgroundColor  = [UIColor whiteColor];
    [self addSubview:hsNumberView];
    hsNumberView.layer.borderWidth = 1.0f;
    hsNumberView.layer.borderColor = kDefaultViewBorderColor.CGColor;
    
    YYLabel *hsNumberTitleLabel = [[YYLabel alloc] initWithFrame:CGRectMake(kTextMarginLeft, 0, 100, hsNumberView.height)];
    hsNumberTitleLabel.backgroundColor = [UIColor clearColor];
    hsNumberTitleLabel.text = kLocalized(@"GYHS_BP_HS_Number");
    hsNumberTitleLabel.font = kTextFont;
    hsNumberTitleLabel.textColor = kCellItemTitleColor;
    [hsNumberView addSubview:hsNumberTitleLabel];
    
    YYLabel *hsNumberLabel = [[YYLabel alloc] initWithFrame:CGRectMake(kScreenWidth-200-kTextMarginRight, 0, 200, hsNumberView.height)];
    hsNumberLabel.backgroundColor = [UIColor clearColor];
    hsNumberLabel.textColor = [UIColor redColor];
    hsNumberLabel.textAlignment =  NSTextAlignmentRight;
    hsNumberLabel.text = [GYUtils formatCardNo:globalData.loginModel.resNo];
    [hsNumberView addSubview:hsNumberLabel];
    
    //补办原因
    YYLabel *reasonLabel = [[YYLabel alloc] initWithFrame:CGRectMake(kTextMarginLeft, hsNumberView.bottom, kScreenWidth-kTextMarginLeft, 50)];
    reasonLabel.text = kLocalized(@"GYHS_BP_Rehandle_Reason");
    reasonLabel.backgroundColor = kDefaultVCBackgroundColor;
    reasonLabel.font = kTextFont;
    reasonLabel.textColor = kCellItemTitleColor;
    [self addSubview:reasonLabel];
    
    self.reasonTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, reasonLabel.bottom, kScreenWidth, 130)];
    [self addSubview:self.reasonTextView];
    self.reasonTextView.font = kTextFont;
    self.reasonTextView.layer.borderWidth = 1.0f;
    self.reasonTextView.layer.borderColor = kDefaultViewBorderColor.CGColor;
    self.reasonTextView.text = kLocalized(@"GYHS_BP_Input_Rehandle_Reason");
    self.reasonTextView.textColor = [UIColor lightGrayColor];
    
    //联系信息
    self.addressInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, self.reasonTextView.bottom +kTextMarginTop, kScreenWidth, 0.1)];
    self.addressInfoView.backgroundColor = kDefaultVCBackgroundColor;
    [self addSubview:self.addressInfoView];
    
    //联系人
    self.nameLabel = [[YYLabel alloc] init];
//    self.nameLabel.font = kTextFont;
    self.nameLabel.textColor = kCellItemTitleColor;
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.addressInfoView addSubview:self.nameLabel];
    
    //电话号码
    self.phoneLabel  = [[YYLabel alloc] init];
    self.phoneLabel.font = kTextFont;
    self.phoneLabel.textColor = [UIColor lightGrayColor];
    self.phoneLabel.backgroundColor = [UIColor clearColor];
    [self.addressInfoView addSubview:self.phoneLabel];
    
    //联系地址
    self.addressLabel = [[YYLabel alloc] init];
    self.addressLabel.font = kTextFont;
    self.addressLabel.numberOfLines = 0;
    self.addressLabel.textColor = [UIColor lightGrayColor];
    self.addressLabel.backgroundColor = [UIColor clearColor];
    [self.addressInfoView addSubview:self.addressLabel];
    
    //修改联系地址 按钮
    self.modifyAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.modifyAddressBtn.frame = CGRectMake(kTextMarginLeft, self.addressInfoView.bottom,120, 30);
    self.modifyAddressBtn.backgroundColor = kDefaultVCBackgroundColor;
    [self.modifyAddressBtn setTitle:kLocalized(@"GYHS_BP_Change_Shipping_Address") forState:UIControlStateNormal];
    [self.modifyAddressBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self addSubview:self.modifyAddressBtn];
    
    //下一步
    self.nextStepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextStepBtn.frame = CGRectMake(kTextMarginLeft, self.modifyAddressBtn.bottom +30, kScreenWidth -2*kTextMarginLeft, 40);
    [self.nextStepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextStepBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_btn_orange"] forState:UIControlStateNormal];
    [self.nextStepBtn setTitle:kLocalized(@"GYHS_BP_Next_Step") forState:UIControlStateNormal];
    [self addSubview:self.nextStepBtn];
    
    self.frame = CGRectMake(0, 0, kScreenWidth, self.nextStepBtn.bottom+30);
    DDLogInfo(@"###########%f",self.frame.size.height);
}


-(void)setModel:(GYHESCDefaultAddressModel *)model {
    if(model == nil) {
        self.addressInfoView.frame = CGRectMake(0, self.reasonTextView.bottom +kTextMarginTop, kScreenWidth, 0.1);
        self.nameLabel.text  = nil;
        self.phoneLabel.text = nil;
        self.addressLabel.text = nil;
    }else {
        self.nameLabel.text = model.receiver;
        self.phoneLabel.text = model.mobile;
        self.addressLabel.text = [NSString stringWithFormat:@"%@%@",kLocalized(@"GYHS_BP_Contact_Address"),model.address];

        CGSize phoneSize = [self adaptiveWithWidth:kScreenWidth andLabel:self.phoneLabel];
        CGSize nameSize = [self adaptiveWithWidth:kScreenWidth andLabel:self.nameLabel];
        CGSize addressSize = [self adaptiveWithWidth:kScreenWidth-2*kTextMarginLeft andLabel:self.addressLabel];
        if(nameSize.width + phoneSize.width + 3*kTextMarginLeft > kScreenWidth) {
            nameSize = [self adaptiveWithWidth:kScreenWidth -2*kTextMarginLeft andLabel:self.nameLabel];
            self.nameLabel.frame = CGRectMake(kTextMarginLeft, 0, nameSize.width, nameSize.height);
            self.phoneLabel.frame = CGRectMake(kTextMarginLeft, self.nameLabel.bottom+kTextMarginTop, phoneSize.width, phoneSize.height);
        }else {
            self.nameLabel.frame = CGRectMake(kTextMarginLeft, 0, nameSize.width, nameSize.height);
            self.phoneLabel.frame = CGRectMake(self.nameLabel.right+kTextMarginLeft, 0, phoneSize.width, phoneSize.height);
        }
        
        self.addressLabel.frame = CGRectMake(kTextMarginLeft, self.phoneLabel.bottom +kTextMarginTop, addressSize.width, addressSize.height);
        self.addressInfoView.frame = CGRectMake(0, self.reasonTextView.bottom +kTextMarginTop, kScreenWidth, self.addressLabel.bottom);
    }
    
    self.modifyAddressBtn.frame = CGRectMake(kTextMarginLeft, self.addressInfoView.bottom +kTextMarginTop,120, 30);
    self.nextStepBtn.frame = CGRectMake(kTextMarginLeft, self.modifyAddressBtn.bottom +30, kScreenWidth -2*kTextMarginLeft, 40);
    self.frame = CGRectMake(0, 0, kScreenWidth, self.nextStepBtn.bottom+30);
    
}

-(CGSize)adaptiveWithWidth:(CGFloat)witdh andLabel:(YYLabel *)label {
    
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return [label sizeThatFits:CGSizeMake(witdh, MAXFLOAT)];
}

@end
