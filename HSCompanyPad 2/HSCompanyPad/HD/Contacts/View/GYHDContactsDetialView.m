//
//  GYHDContactsDetialView.m
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDContactsDetialView.h"
@interface GYHDContactsDetialView ()

@property(nonatomic, strong)UIImageView *iconImageView;

@property(nonatomic, strong)UILabel     *titleLabel;
@property(nonatomic, strong)UILabel     *detailLabel;
@property(nonatomic, strong)UIButton    *sendButton;
@property(nonatomic, strong)UIView      *contactsView;
@property(nonatomic, strong)UIView      *contactsBaseView;
@property(nonatomic, strong)UIImageView *sexImgView;

@property(nonatomic, strong)UIView      *centerView;
@property(nonatomic, strong)UIView      *bottomView;
@property(nonatomic, strong)UILabel     *salesPointsDetailLabel;
@property(nonatomic, strong)UILabel     *occupationDetailLabel;
@property(nonatomic, strong)UILabel     *charactertsDetailLabel;
@property(nonatomic, strong)UILabel     *customerServiceDetailLabel;
@property(nonatomic, strong)UILabel     *nikeNameDetailLabel;
@property(nonatomic, strong)UILabel     *ageDetailLabel;
@property(nonatomic, strong)UILabel     *sexDetailLabel;
@property(nonatomic, strong)UILabel     *addressDetailLabel;
@property(nonatomic, strong)UILabel     *hobbyDetailLabel;
@property(nonatomic, strong)UILabel     *signatureDetailLabel;

@end

@implementation GYHDContactsDetialView

- (instancetype)init {
    if (self = [super init]) {
        
        [self setUpView];
        [self setcenterView];
        [self setBottomView];

    }
    return self;
}
- (void)setUpView {
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 3.0f;
    [self addSubview:self.iconImageView];
    
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    self.titleLabel.textColor = [UIColor colorWithHex:0x333333];
    [self addSubview:self.titleLabel];
    
    self.sexImgView=[[UIImageView alloc]init];
    [self addSubview:self.sexImgView];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.font = [UIFont systemFontOfSize:14.0f];
    self.detailLabel.textColor = [UIColor colorWithHex:0x999999];
    [self addSubview:self.detailLabel];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setBackgroundImage:[UIImage imageNamed:@"gyhd_send_btn_normal"] forState:UIControlStateNormal];
    [self.sendButton setBackgroundImage:[UIImage imageNamed:@"gyhd_send_btn_highlighted"] forState:UIControlStateHighlighted];
    [self.sendButton setTitle:kLocalized(@"GYHD_SendMessage") forState:UIControlStateNormal];
    
    [self.sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.sendButton];
    
    @weakify(self);
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(46, 46));
        
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo((self.iconImageView));
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(90, 33));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).offset(8);
//        make.right.equalTo(self.sendButton.mas_left).offset(-10);
        make.height.equalTo(self.detailLabel);
        make.bottom.equalTo(self.detailLabel.mas_top);
    }];
    
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        
        make.bottom.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).offset(8);
        make.right.equalTo(self.sendButton.mas_left).offset(-10);
        make.height.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
    
    [self.sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right).offset(5);
    }];

}
- (void)setcenterView {
    self.centerView = [[UIView alloc] init];
    self.centerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.centerView];
    
    UILabel  *salesPointsTitleLabel = [[UILabel alloc] init];

    salesPointsTitleLabel.font = [UIFont systemFontOfSize:14.0];
    salesPointsTitleLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.centerView addSubview:salesPointsTitleLabel];
    
    UILabel  *occupationTitleLabel = [[UILabel alloc] init];

    occupationTitleLabel.font = [UIFont systemFontOfSize:14.0];
    occupationTitleLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.centerView addSubview:occupationTitleLabel];
    
    UILabel  *charactertsTitleLabel = [[UILabel alloc] init];

    charactertsTitleLabel.font = [UIFont systemFontOfSize:14.0];
    charactertsTitleLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.centerView addSubview:charactertsTitleLabel];
    
    UILabel  *customerServiceTitleLabel = [[UILabel alloc] init];

    customerServiceTitleLabel.font = [UIFont systemFontOfSize:14.0];
    customerServiceTitleLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.centerView addSubview:customerServiceTitleLabel];
    
    
    self.salesPointsDetailLabel = [[UILabel alloc] init];
    self.salesPointsDetailLabel.numberOfLines = 0;
    self.salesPointsDetailLabel.font = [UIFont systemFontOfSize:14.0];
    self.salesPointsDetailLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.centerView addSubview:self.salesPointsDetailLabel];
    
    self.occupationDetailLabel = [[UILabel alloc] init];
    self.occupationDetailLabel.font = [UIFont systemFontOfSize:14.0];
    self.occupationDetailLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.centerView addSubview:self.occupationDetailLabel];
    
    self.charactertsDetailLabel = [[UILabel alloc] init];
    self.charactertsDetailLabel.font = [UIFont systemFontOfSize:14.0];
    self.charactertsDetailLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.centerView addSubview:self.charactertsDetailLabel];
    
    self.customerServiceDetailLabel = [[UILabel alloc] init];
    self.customerServiceDetailLabel.font = [UIFont systemFontOfSize:14.0];
    self.customerServiceDetailLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.centerView addSubview:self.customerServiceDetailLabel];
    
    @weakify(self);
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(20);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    
    [self.salesPointsDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(18);
    }];
    
    [self.occupationDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(100);
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.salesPointsDetailLabel.mas_bottom).offset(18);
    }];
    
    [self.charactertsDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self);
        make.left.mas_equalTo(100);
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.occupationDetailLabel.mas_bottom).offset(18);
    }];
    
    [self.customerServiceDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(100);
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.charactertsDetailLabel.mas_bottom).offset(18);
    }];
    
    [salesPointsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(18);
    }];
    
    [occupationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.salesPointsDetailLabel.mas_bottom).offset(18);
    }];
    
    [charactertsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.occupationDetailLabel.mas_bottom).offset(18);
    }];
    
    [customerServiceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.charactertsDetailLabel.mas_bottom).offset(18);
        make.bottom.mas_equalTo(-18);
    }];
    salesPointsTitleLabel.text = kLocalized(@"GYHD_Operating_Point");
    occupationTitleLabel.text = kLocalized(@"GYHD_Position");
    charactertsTitleLabel.text = kLocalized(@"GYHD_Roles");
    customerServiceTitleLabel.text = kLocalized(@"GYHD_CustomerService");
    
}
- (void)setBottomView {
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bottomView];
    
    
    UILabel  *nikeNameTitleLabel = [[UILabel alloc] init];
    nikeNameTitleLabel.font = [UIFont systemFontOfSize:14.0];
    nikeNameTitleLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.bottomView addSubview:nikeNameTitleLabel];
    
    UILabel  *ageTitleLabel = [[UILabel alloc] init];
    ageTitleLabel.font = [UIFont systemFontOfSize:14.0];
    ageTitleLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.bottomView addSubview:ageTitleLabel];
    
    UILabel  *sexTitleLabel = [[UILabel alloc] init];
    sexTitleLabel.font = [UIFont systemFontOfSize:14.0];
    sexTitleLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.bottomView addSubview:sexTitleLabel];
    
    UILabel  *addressTitleLabel = [[UILabel alloc] init];
    addressTitleLabel.font = [UIFont systemFontOfSize:14.0];
    addressTitleLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.bottomView addSubview:addressTitleLabel];
    
    
    UILabel  *hobbyTitleLabel = [[UILabel alloc] init];
    hobbyTitleLabel.font = [UIFont systemFontOfSize:14.0];
    hobbyTitleLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.bottomView addSubview:hobbyTitleLabel];
    
    UILabel  *signatureTitleLabel = [[UILabel alloc] init];
    signatureTitleLabel.font = [UIFont systemFontOfSize:14.0];
    signatureTitleLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.bottomView addSubview:signatureTitleLabel];
    
    self.nikeNameDetailLabel = [[UILabel alloc] init];
    self.nikeNameDetailLabel.numberOfLines = 0;
    self.nikeNameDetailLabel.font = [UIFont systemFontOfSize:14.0];
    self.nikeNameDetailLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.bottomView addSubview:self.nikeNameDetailLabel];
    
    self.ageDetailLabel = [[UILabel alloc] init];
    self.ageDetailLabel.font = [UIFont systemFontOfSize:14.0];
    self.ageDetailLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.bottomView addSubview:self.ageDetailLabel];
    
    self.sexDetailLabel = [[UILabel alloc] init];
    self.sexDetailLabel.font = [UIFont systemFontOfSize:14.0];
    self.sexDetailLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.bottomView addSubview:self.sexDetailLabel];
    
    self.addressDetailLabel = [[UILabel alloc] init];
    self.addressDetailLabel.font = [UIFont systemFontOfSize:14.0];
    self.addressDetailLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.bottomView addSubview:self.addressDetailLabel];
    
    self.hobbyDetailLabel = [[UILabel alloc] init];
    self.hobbyDetailLabel.numberOfLines = 0;
    self.hobbyDetailLabel .font = [UIFont systemFontOfSize:14.0];
    self.hobbyDetailLabel .textColor = [UIColor colorWithHex:0x333333];
    [self.bottomView addSubview:self.hobbyDetailLabel ];
    
    self.signatureDetailLabel = [[UILabel alloc] init];
    self.signatureDetailLabel.numberOfLines = 0;
    self.signatureDetailLabel.font = [UIFont systemFontOfSize:14.0];
    self.signatureDetailLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.bottomView addSubview:self.signatureDetailLabel];
    @weakify(self);
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.centerView.mas_bottom).offset(20);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    
    [self.nikeNameDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(100);
        make.right.equalTo(self.bottomView.mas_centerX).offset(-10);
        make.top.mas_equalTo(18);
    }];
    
    [self.ageDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(100);
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.nikeNameDetailLabel.mas_bottom).offset(18);
    }];
    
    [self.sexDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self);
        make.left.mas_equalTo(100);
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.ageDetailLabel.mas_bottom).offset(18);
    }];
    
    [self.addressDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(100);
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.sexDetailLabel.mas_bottom).offset(18);
    }];
    
    [self.hobbyDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bottomView.mas_centerX).offset(100);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(18);
    }];
    
    [self.signatureDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bottomView.mas_centerX).offset(100);
        make.right.mas_equalTo(-10);
        make.top.equalTo(self.hobbyDetailLabel.mas_bottom).offset(18);
        make.bottom.mas_lessThanOrEqualTo(-18);
    }];
    
    [nikeNameTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(18);
    }];
    
    [ageTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.nikeNameDetailLabel.mas_bottom).offset(18);
    }];
    
    [sexTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.ageDetailLabel.mas_bottom).offset(18);
    }];
    
    [addressTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.sexDetailLabel.mas_bottom).offset(18);
        make.bottom.mas_equalTo(-18);
    }];
    
    [hobbyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bottomView.mas_centerX).offset(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(18);
    }];
    
    [signatureTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bottomView.mas_centerX).offset(10);
        make.right.mas_equalTo(-10);
        make.top.equalTo(self.hobbyDetailLabel.mas_bottom).offset(18);
    }];
    nikeNameTitleLabel.text = kLocalized(@"GYHD_NickName");
    ageTitleLabel.text = kLocalized(@"GYHD_Age");
    sexTitleLabel.text = kLocalized(@"GYHD_Sex");
    addressTitleLabel.text = kLocalized(@"GYHD_Area");
    hobbyTitleLabel.text = kLocalized(@"GYHD_Hobby");
    signatureTitleLabel.text = kLocalized(@"GYHD_Sign");
}

-(void)setModel:(GYHDOpereotrListModel *)model{
    
    _model=model;

    NSDictionary*dic=model.searchUserInfo;
    
    [self.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,dic[@"headImage"]]] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];
    
    self.titleLabel.text=kSaftToNSString(dic[@"operName"]);
    
    NSString*resNoStr=kSaftToNSString(dic[@"resNo"]);
    
    if (resNoStr.length>0 ) {
    
        self.detailLabel.text=[NSString stringWithFormat:@"%@:%@/%@:%@",kLocalized(@"GYHD_Employee_Number"),kSaftToNSString(dic[@"username"]),kLocalized(@"GYHD_Alternate_Number"),resNoStr];
        
    }else{
    
        self.detailLabel.text=[NSString stringWithFormat:@"%@:%@",kLocalized(@"GYHD_Employee_Number"),kSaftToNSString(dic[@"username"])];
        
    }
    
    self.salesPointsDetailLabel.text=@" ";
    
    NSString*operDutyStr=kSaftToNSString(dic[@"operDuty"]);
    
    if (operDutyStr.length<=0) {
        
         self.occupationDetailLabel.text=@" ";
        
    }else{
        
        self.occupationDetailLabel.text=dic[@"operDuty"];
        
    }
   
    if (model.roleName.length<=0) {
         self.charactertsDetailLabel.text = @" ";
    }else{
        self.charactertsDetailLabel.text = model.roleName;
    }
   
    self.customerServiceDetailLabel.text = @" ";
    
    NSString*nickNameStr=kSaftToNSString(dic[@"nickName"]);
    if (nickNameStr.length<=0) {
         self.nikeNameDetailLabel.text =@" ";
        
    }else{
    
     self.nikeNameDetailLabel.text =nickNameStr;
        
    }
   
    NSString* ageStr=kSaftToNSString(dic[@"age"]);
    
    if (ageStr.length<=0) {
        
        self.ageDetailLabel.text =@" " ;
    }else{
    
        self.ageDetailLabel.text =ageStr ;
    }
    
    
    NSString*sexStr=kSaftToNSString(dic[@"sex"]);
    
    if ([sexStr isEqualToString:@"1"]) {
        
       self.sexDetailLabel.text =kLocalized(@"GYHD_Man");
    self.sexImgView.image=[UIImage imageNamed:@"gyhd_man_icon"];
        
    }else if ([sexStr isEqualToString:@"0"]){
        
        self.sexDetailLabel.text =kLocalized(@"GYHD_Woman");
        self.sexImgView.image=[UIImage imageNamed:@"gyhd_woman_icon"];
        
    }else{
        
        self.sexDetailLabel.text =@" ";
    }
    
    self.addressDetailLabel.text =kSaftToNSString( dic[@"area"]);
    NSString*hobbyStr=kSaftToNSString(dic[@"hobby"]);
    if (hobbyStr.length<=0) {
        
         self.hobbyDetailLabel.text =@" ";
    }else{
    
     self.hobbyDetailLabel.text = hobbyStr;
    }
   
    self.signatureDetailLabel.text =kSaftToNSString(dic[@"sign"]) ;

}
-(void)sendMessage{
    
    NSString*custId=_model.searchUserInfo[@"custId"];

    if (self.block) {
        
        self.block(custId);
    }
    
}
@end
