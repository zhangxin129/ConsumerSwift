//
//  GYHDEditReplyView.m
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDEditReplyView.h"
#import "GYHDNetWorkTool.h"

@interface GYHDEditReplyView ()
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UITextView *titleTextView;
@property(nonatomic, strong)UILabel  *titleCountLabel;
@property(nonatomic, strong)UILabel *detailLabel;
@property(nonatomic, strong)UITextView *detailTextView;
@property(nonatomic, strong)UILabel  *detailCountLabel;
@property(nonatomic, strong)UIButton *saveButton;
@property(nonatomic, strong)UIButton *cancelButton;
@property(nonatomic, strong)GYHDReplyModel *model;
@end

@implementation GYHDEditReplyView

- (instancetype)initWithModel:(GYHDReplyModel *)model{
    if (self = [super init]) {
        _model = model;
        self.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        self.titleLabel.textColor = [UIColor colorWithHex:0x999999];
        self.titleLabel.text = kLocalized(@"GYHD_Title");
        [self addSubview:self.titleLabel];
        
        self.titleTextView = [[UITextView alloc] init];
        self.titleTextView.textContainerInset = UIEdgeInsetsMake(0,20, 0, 0);
        self.titleTextView.font = [UIFont systemFontOfSize:16.0f];
        self.titleTextView.textColor = [UIColor colorWithHex:0x333333];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editChange:) name:UITextViewTextDidChangeNotification object:nil];
        [self addSubview:self.titleTextView];

        
        self.detailLabel = [[UILabel alloc] init];
        self.detailLabel.font = [UIFont systemFontOfSize:16.0f];
        self.detailLabel.textColor = [UIColor colorWithHex:0x999999];
        self.detailLabel.text = kLocalized(@"GYHD_Reply_Content");
        [self addSubview:self.detailLabel];
        
        self.detailTextView = [[UITextView alloc] init];
        self.detailTextView.textContainerInset = UIEdgeInsetsMake(0,20, 0, 0);
        self.detailTextView.font = [UIFont systemFontOfSize:16.0f];
        self.detailTextView.textColor = [UIColor colorWithHex:0x333333];
        [self addSubview:self.detailTextView];
        
        self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.saveButton.layer.masksToBounds = YES;
        self.saveButton.layer.cornerRadius = 3.0f;
        self.saveButton.backgroundColor = [UIColor colorWithHex:0x3e8ffa];
        self.saveButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.saveButton addTarget:self action:@selector(btnClcik:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.saveButton];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.layer.masksToBounds = YES;
        self.cancelButton.layer.cornerRadius = 3.0f;
        self.cancelButton.backgroundColor = [UIColor colorWithHex:0xb8b8cc];
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.cancelButton addTarget:self action:@selector(btnClcik:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelButton];
        
        self.titleCountLabel = [[UILabel alloc] init];
        self.titleCountLabel.font = [UIFont systemFontOfSize:12.0f];
        self.titleCountLabel.textColor = [UIColor colorWithHex:0x999999];
        [self addSubview:self.titleCountLabel];
        
        self.detailCountLabel = [[UILabel alloc] init];
        self.detailCountLabel.font = [UIFont systemFontOfSize:12.0f];
        self.detailCountLabel.textColor = [UIColor colorWithHex:0x999999];
        [self addSubview:self.detailCountLabel];
        @weakify(self);
        [self.detailTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(177);
            make.height.mas_equalTo(110);
        }];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.detailTextView).offset(20);
            make.bottom.equalTo(self.detailTextView.mas_top).offset(-10);
        }];
        
        [self.detailCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.equalTo(self.detailTextView).offset(-10);
            make.bottom.equalTo(self.detailTextView).offset(-10);
        }];
        [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.detailTextView.mas_bottom).offset(25);
            make.size.mas_equalTo(CGSizeMake(70, 33));
            make.right.mas_equalTo(self.mas_centerX).offset(-20);
            
        }];
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.detailTextView.mas_bottom).offset(25);
            make.size.mas_equalTo(CGSizeMake(70, 33));
            make.left.mas_equalTo(self.mas_centerX).offset(20);
        }];
        
        [self.titleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(self.detailTextView.mas_top).offset(-34);
            make.height.mas_equalTo(44);
        }];
        
        [self.titleCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.equalTo(self.titleTextView).offset(-10);
            make.bottom.equalTo(self.titleTextView).offset(-10);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.titleTextView).offset(20);
            make.bottom.equalTo(self.titleTextView.mas_top).offset(-10);
        }];
        self.detailTextView.text = model.contentString;
        self.titleTextView.text = model.titleString;
        self.detailCountLabel.text =[NSString stringWithFormat:@"%ld",100- model.contentString.length];
        self.titleCountLabel.text = [NSString stringWithFormat:@"%ld",6 - model.titleString.length];

        [self.saveButton setTitle:kLocalized(@"GYHD_Save") forState:UIControlStateNormal];
        [self.cancelButton setTitle:kLocalized(@"GYHD_Cancel") forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editChange:) name:UITextViewTextDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endChange:) name:UITextViewTextDidEndEditingNotification object:nil];


    }
    return self;
}


- (void)endChange:(NSNotification *)noti {
    
    if (self.detailTextView.text.length > 100) {
        self.detailTextView.text = [self.detailTextView.text substringToIndex:100];
    }
    if (self.titleTextView.text.length > 6) {
        self.titleTextView.text = [self.titleTextView.text substringToIndex:6];
    }
}

- (void)editChange:(NSNotification *)noti {

    if ( self.detailTextView.text.length <=100) {
        
        self.detailCountLabel.text= [NSString stringWithFormat:@"%ld", 100 - self.detailTextView.text.length];
    }else{
        [self.detailTextView resignFirstResponder];
    }
    if (self.titleTextView.text.length <=6) {
       
        self.titleCountLabel.text = [NSString stringWithFormat:@"%ld",6 - self.titleTextView.text.length];
    }else{
        
        [self.titleTextView resignFirstResponder];
    }

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)btnClcik:(UIButton *)btn {
    if ([btn isEqual:self.saveButton]) {
        DDLogInfo(@"保存");
        if (self.model) {
            if ([self.delegate respondsToSelector:@selector(GYHDEditReplyViewDidUpdate:)]) {
                self.model.titleString = self.titleTextView.text;
                self.model.contentString = self.detailTextView.text;
                [self.delegate GYHDEditReplyViewDidUpdate:self.model];
            }
        }else {
            if ([self.delegate respondsToSelector:@selector(GYHDEditReplyViewDidSave:)]) {
                GYHDReplyModel *model = [[GYHDReplyModel alloc] init];
                model.titleString = self.titleTextView.text;
                model.contentString = self.detailTextView.text;
                model.entCustID = globalData.loginModel.entCustId;
                model.isDefault = @"1";
                model.messageID = @"";
                [self.delegate GYHDEditReplyViewDidSave:model];
            }
        }
    [self removeFromSuperview];
    }else if ([btn isEqual:self.cancelButton]){
        DDLogInfo(@"取消");
        @weakify(self);
        [GYAlertView alertWithTitle:kLocalized(@"GYHD_Tip") Message:kLocalized(@"GYHD_Are_You_Sure_Cancel_Update_Content") topColor:TopColorRed comfirmBlock:^{
            @strongify(self);
            [self removeFromSuperview];
        }];
    }
    
}
@end
