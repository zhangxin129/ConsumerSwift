//
//  GYHSStaffManagerTableViewCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSStaffManagerTableViewCell.h"
#import "UILabel+Category.h"
#import "GYHSStaffManModel.h"

#define kMax(a,b) (a>b ? a : b)
#define kState0(string) [string isEqualToString:@"0"]
#define kState1(string) [string isEqualToString:@"1"]
#define kState(string) [string isEqualToString:@"-1"]
#define kState2(string) [string isEqualToString:@"2"]

static NSString* const GYTableViewCellID = @"GYStaffTableViewCell";

@interface GYHSStaffManagerTableViewCell()

@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UILabel *stateLable;
@property (nonatomic, strong) UILabel *userNameLable;
@property (nonatomic, strong) UILabel *actorLable;
@property (nonatomic, strong) UILabel *roleLable;

@property (nonatomic, strong) UIButton *roleButton;
@property (nonatomic, strong) UILabel *shopNameLable;
@property (nonatomic, strong) UIButton *shopNameButton;
@property (nonatomic, strong) UILabel *HSCardBlindingLable;
@property (nonatomic, strong) UIButton *HSCardBlindingButton;
@property (nonatomic, strong) UISwitch *CusSerSwitch;
@property (nonatomic, strong) UIButton *changeBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) NSMutableArray* roleNameArr;
@property (nonatomic, strong) NSMutableArray* relateShopNameArr;
@property (nonatomic, strong) NSMutableArray* HSCardBlindingArr;
@property (nonatomic, copy) NSString *staStr;
@property (nonatomic, assign) float cellH;
@property (nonatomic , strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UITapGestureRecognizer *shopNameTap;
@property (nonatomic, strong) UITapGestureRecognizer *HSCardTap;
@property (nonatomic, strong) NSMutableArray *roleArr;

@end

@implementation GYHSStaffManagerTableViewCell

/**
 *  自定义Cell
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        float nameLableW = 87;
        float stateLableW = 96;
        float userNameLableW = 119;
        float actorLableW = 118;
        float roleLableW = 127;
        float roleButtonW = 10;
        float HSCardBlindingLableW = 136;
        float HSCardBlindingButtonW = 10;
        float cusSerSwitchW = 104;
        float changeBtnW = 40;
        float deleteBtnW = 40;
        float btnH = 10;
        
        self.nameLable = [[UILabel alloc] init];
        [self addSubview:self.nameLable];
        
        self.stateLable = [[UILabel alloc] init];
        
        [self addSubview:self.stateLable];
        
        self.userNameLable = [[UILabel alloc] init];
        
        [self addSubview:self.userNameLable];
        
        self.actorLable = [[UILabel alloc] init];
        
        [self addSubview:self.actorLable];
        
        self.roleLable = [[UILabel alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self.roleLable addGestureRecognizer:tap];
        self.tap = tap;
        self.roleLable.userInteractionEnabled = YES;
        [self addSubview:self.roleLable];
        
        self.roleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.roleButton setBackgroundImage:[UIImage imageNamed:@"btn_arrow_right"] forState:UIControlStateNormal];
        [self.roleButton addTarget:self action:@selector(roleButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.roleButton];
        
        
        self.HSCardBlindingLable = [[UILabel alloc] init];
        UITapGestureRecognizer *HSCardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self.HSCardBlindingLable addGestureRecognizer:HSCardTap];
        self.HSCardTap = HSCardTap;
        self.HSCardBlindingLable.userInteractionEnabled = YES;
        [self addSubview:self.HSCardBlindingLable];
        self.HSCardBlindingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.HSCardBlindingButton setBackgroundImage:[UIImage imageNamed:@"btn_arrow_right"] forState:UIControlStateNormal];
        [self.HSCardBlindingButton addTarget:self action:@selector(blindingAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.HSCardBlindingButton];
        
        self.CusSerSwitch = [[UISwitch alloc] init];
        [self.CusSerSwitch addTarget:self action:@selector(cusSerSwitchAction:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.CusSerSwitch];
        
        self.changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.changeBtn setTitle:kLocalized(@"GYHS_StaffManager_Change") forState:UIControlStateNormal];
        [self.changeBtn setTitleColor:kBlue0A59C2 forState:UIControlStateNormal];
        [self.changeBtn addTarget:self action:@selector(changeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.changeBtn];
        
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteBtn setTitle:kLocalized(@"GYHS_StaffManager_Delete") forState:UIControlStateNormal];
        [self.deleteBtn setTitleColor:kBlue0A59C2 forState:UIControlStateNormal];
        [self.deleteBtn addTarget:self action:@selector(deleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.deleteBtn];
        
        [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(6);
            make.left.equalTo(self.mas_left).offset(0);
            make.width.equalTo(@(kDeviceProportion(nameLableW)));
            make.bottom.mas_equalTo(-5);
        }];
        
        self.nameLable.textAlignment =NSTextAlignmentCenter;
        
        [self.stateLable mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(6);
            make.left.equalTo(self.nameLable.mas_left).offset(nameLableW);
            make.width.equalTo(@(kDeviceProportion(stateLableW)));
            make.bottom.mas_equalTo(-5);
        }];
        
        [self.userNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(6);
            make.left.equalTo(self.stateLable.mas_left).offset(stateLableW);
            make.width.equalTo(@(kDeviceProportion(userNameLableW)));
            make.bottom.mas_equalTo(-5);
        }];
        
        [self.actorLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(6);
            make.left.equalTo(self.userNameLable.mas_left).offset(userNameLableW);
            make.width.equalTo(@(kDeviceProportion(actorLableW)));
            make.bottom.mas_equalTo(-5);
        }];
        
        [self.roleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(6);
            make.left.equalTo(self.actorLable.mas_left).offset(actorLableW);
            make.width.equalTo(@(kDeviceProportion(roleLableW)));
            make.bottom.mas_equalTo(-5);
            
        }];
        
        [self.roleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.roleLable.mas_left).offset(roleLableW);
            make.width.equalTo(@(kDeviceProportion(roleButtonW)));
            make.height.equalTo(@(kDeviceProportion(btnH)));
            
        }];
        
        
        [self.HSCardBlindingLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(6);
            make.left.equalTo(self.roleButton.mas_left).offset(roleButtonW);
            make.width.equalTo(@(kDeviceProportion(HSCardBlindingLableW)));
            make.bottom.mas_equalTo(-5);
        }];
        
        [self.HSCardBlindingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.HSCardBlindingLable.mas_left).offset(HSCardBlindingLableW);
            make.width.equalTo(@(kDeviceProportion(HSCardBlindingButtonW)));
            make.height.equalTo(@(kDeviceProportion(btnH)));
        }];
        
        self.CusSerSwitch.onTintColor = kBlue0A59C2;
        [self.CusSerSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.HSCardBlindingButton.mas_left).offset(HSCardBlindingButtonW + 60);
            make.width.equalTo(@(kDeviceProportion(cusSerSwitchW)));
            make.height.equalTo(@(kDeviceProportion(30)));
        }];
        
        [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(6);
            make.left.equalTo(self.CusSerSwitch.mas_left).offset(cusSerSwitchW);
            make.width.equalTo(@(kDeviceProportion(changeBtnW)));
            make.bottom.mas_equalTo(-5);
        }];
        
        
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(6);
            make.left.equalTo(self.changeBtn.mas_left).offset(changeBtnW + 10);
            make.width.equalTo(@(kDeviceProportion(deleteBtnW)));
            make.bottom.mas_equalTo(-5);
        }];

    }
    
    return self;
}

#pragma mark - 懒加载
/**
 *  赋值
 */
- (void)setModel:(GYHSStaffManModel *)model{
    _model = model;
    _roleNameArr = [[NSMutableArray alloc] init];
    if (model.roleList.count > 0) {
        for (GYRoleListModel* tempModel in model.roleList) {
            [_roleNameArr addObject:tempModel.roleName];
        }
    }
    _roleArr = [[NSMutableArray alloc] init];
    if (model.roleList.count > 0) {
        for (GYRoleListModel* tempModel in model.roleList) {
            [_roleArr addObject:tempModel.roleId];
        }

    }
    
    _relateShopNameArr = [[NSMutableArray alloc] init];
    if (model.relationShops.count > 0) {
        for (GYRelationShopsModel* tempModel in model.relationShops) {
            [_relateShopNameArr addObject:tempModel.shopName];
        }
    }
    _HSCardBlindingArr = [[NSMutableArray alloc] init];
    if (kState0(model.bindResNoStatus)) {
        [_HSCardBlindingArr addObject:kLocalized(@"GYHS_StaffManager_NotBinding")];
    }else if (kState1(model.bindResNoStatus)) {
        [_HSCardBlindingArr addObject:model.operResNo];
    }else if (kState(model.bindResNoStatus)) {
        [_HSCardBlindingArr addObject:model.operResNo];
        [_HSCardBlindingArr addObject:kLocalized(@"GYHS_StaffManager_(UnSure)")];
    }

    if (kState0(model.accountStatus)) {
        _staStr = kLocalized(@"GYHS_StaffManager_AlreadyEnable");
    }else if (kState1(model.accountStatus)){
        _staStr = kLocalized(@"GYHS_StaffManager_AlreadyDisable");
    }else if (kState2(model.accountStatus)){
        _staStr = kLocalized(@"GYHS_StaffManager_AlreadyDeleted");
    }

    if ([model.userName isEqualToString:@"0000"]) {
        self.changeBtn.hidden = YES;
        self.deleteBtn.hidden = YES;
        self.roleLable.userInteractionEnabled = NO;
        self.roleButton.userInteractionEnabled = NO;
    }else{
        self.changeBtn.hidden = NO;
        self.deleteBtn.hidden = NO;
        self.roleLable.userInteractionEnabled = YES;
        self.roleButton.userInteractionEnabled = YES;

    }
    
    [self.nameLable initWithText:model.realName TextColor:kGray333333 Font:kFont24 TextAlignment:1];
    [self.stateLable initWithText:_staStr TextColor:kGray333333 Font:kFont24 TextAlignment:1];
    [self.userNameLable initWithText:_model.userName TextColor:kGray333333 Font:kFont24 TextAlignment:1];
     [self.actorLable initWithText:_model.operDuty TextColor:kGray333333 Font:[UIFont systemFontOfSize:13] TextAlignment:1];
    self.roleLable.font = kFont24;
    self.roleLable.textAlignment = NSTextAlignmentCenter;
    self.roleLable.numberOfLines = 0;
    self.roleLable.textColor = kBlue0C69E9;
    NSString *rolenameStr = [self.roleNameArr componentsJoinedByString:@","];
    self.roleLable.text = [rolenameStr stringByReplacingOccurrencesOfString:@"," withString:@"\n"];

    self.HSCardBlindingLable.font = [UIFont systemFontOfSize:13];
    self.HSCardBlindingLable.textAlignment = NSTextAlignmentCenter;
    self.HSCardBlindingLable.numberOfLines = 0;
    self.HSCardBlindingLable.textColor = kBlue0C69E9;
    NSString *cardStr = [self.HSCardBlindingArr componentsJoinedByString:@","];
    self.HSCardBlindingLable.text = [cardStr stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
    
    if (_model.roleList.count <= 1 && _model.relationShops.count <= 1 && ([_model.bindResNoStatus isEqualToString:@"0"] || [_model.bindResNoStatus isEqualToString:@"1"])) {
        _cellH = 40;
    }else if (_model.roleList.count <= 1 && _model.relationShops.count <= 1 && [_model.bindResNoStatus isEqualToString:@"-1"]){
        _cellH =  40 * 2;
    }else if (kMax(_model.roleList.count,_model.relationShops.count) == _model.roleList.count){
        _cellH = _model.roleList.count * 40;
    }else{
        _cellH = _model.relationShops.count * 40;
    }

    if ([model.operType isEqualToString:@"1"]) {
        [_CusSerSwitch setOn:YES];
    }else{
        [_CusSerSwitch setOn:NO];
    }
}

/**
 *  按钮的事件
 */

- (void)changeBtnAction{
    if ([self.delegate respondsToSelector:@selector(changeAction:)]) {
        [self.delegate changeAction:_model];
    }

}

- (void)deleteBtnAction{
    if ([self.delegate respondsToSelector:@selector(deleteAction:)]) {
        [self.delegate deleteAction:_model];
    }

}

- (void)cusSerSwitchAction:(UISwitch *)cusSwitch{
    if ([self.delegate respondsToSelector:@selector(switchAction:switch:)]) {
        [self.delegate switchAction:_model switch:cusSwitch];
    }

}

- (void)blindingAction{
    if ([self.delegate respondsToSelector:@selector(blingingCardAction:)]) {
        [self.delegate blingingCardAction:_model];
    }

}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    if (tap == self.tap) {
        [self roleButtonAction];
    }else if (tap == self.HSCardTap){
        [self blindingAction];
    }
    
}

- (void)roleButtonAction{
    
    if ([self.delegate respondsToSelector:@selector(postAction:roleArr:)]) {
        [self.delegate postAction:_model roleArr:_roleArr];
    }
}

@end
