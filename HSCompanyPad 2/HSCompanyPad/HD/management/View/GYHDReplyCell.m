//
//  GYHDReplyCell.m
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDReplyCell.h"
#import "GYAlertView.h"
@interface GYHDReplyCell ()
@property(nonatomic, strong)UIView *myContentView;
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *detailLabel;
@property(nonatomic, strong)UIButton *editButton;
@property(nonatomic, strong)UIButton *deleteButton;
@end

@implementation GYHDReplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
- (void)setup {
    self.myContentView = [[UIView alloc] init];
    [self.contentView addSubview:self.myContentView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    self.titleLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.myContentView addSubview:self.titleLabel];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.font = [UIFont systemFontOfSize:14.0f];
    self.detailLabel.textColor = [UIColor colorWithHex:0x333333];
    self.detailLabel.numberOfLines = 2;
    [self.myContentView addSubview:self.detailLabel];
    
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editButton setBackgroundImage:[UIImage imageNamed:@"gyhd_edit_btn_normal"] forState:UIControlStateNormal];
    [self.editButton setBackgroundImage:[UIImage imageNamed:@"gyhd_edit_btn_select"] forState:UIControlStateSelected];
    [self.editButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.myContentView addSubview:self.editButton];
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"gyhd_delete_btn_normal"] forState:UIControlStateNormal];
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"gyhd_delete_btn_select"] forState:UIControlStateSelected];
    [self.deleteButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.myContentView addSubview:self.deleteButton];
    
    @weakify(self);
    [self.myContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(15);
        make.height.mas_equalTo(75);
        make.bottom.right.mas_equalTo(-15);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.myContentView);
        make.left.mas_equalTo(22);
        make.right.equalTo(self.detailLabel.mas_left).offset(-40);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.myContentView);
        make.left.mas_equalTo(130);
        make.right.lessThanOrEqualTo(self.editButton).offset(-40);
    }];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.deleteButton.mas_left).offset(-40);
        make.centerY.equalTo(self.myContentView);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.centerY.equalTo(self.myContentView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = kDefaultVCBackgroundColor;
    self.myContentView.backgroundColor = [UIColor whiteColor];
    self.titleLabel.text = @" ";
    self.detailLabel.text = @" ";
}
- (void)setModel:(GYHDReplyModel *)model {
    _model = model;
    self.titleLabel.text = model.titleString;
    self.detailLabel.text = model.contentString;
}
- (void)btnClick:(UIButton *)btn {

    if ([btn isEqual:self.editButton]) {

        if ([self.delegate respondsToSelector:@selector(editButonClickWithCell:model:)]) {
            [self.delegate editButonClickWithCell:self model:self.model];
        }
    }else if ([btn isEqual:self.deleteButton]) {
        
          [GYAlertView alertWithTitle:kLocalized(@"GYHD_Tip") Message:kLocalized(@"GYHD_Are_You_Will_Delete_This_Reply_Message") topColor:TopColorRed comfirmBlock:^{
              
              if ([self.delegate respondsToSelector:@selector(deleteButonClickWithCell:model:)]) {
                  [self.delegate deleteButonClickWithCell:self model:self.model];
              }
              
          }];
        
    }
}


@end
