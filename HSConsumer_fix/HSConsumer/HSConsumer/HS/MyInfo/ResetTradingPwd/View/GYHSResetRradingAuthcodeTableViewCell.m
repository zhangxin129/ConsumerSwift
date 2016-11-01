//
//  GYHSResetRradingAutoCodeTableViewCell.m
//  HSConsumer
//
//  Created by lizp on 16/8/15.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSResetRradingAuthcodeTableViewCell.h"
#import "YYKit.h"
#import "GYAuthcodeView.h"

@interface GYHSResetRradingAuthcodeTableViewCell()

@property (nonatomic,weak) GYAuthcodeView *authcode;

@end

@implementation GYHSResetRradingAuthcodeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

-(void)setUp {
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0,120 ,50 )];
    self.title.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.title];
    
    self.value = [[UITextField alloc] initWithFrame:CGRectMake(140, 0, kScreenWidth -60-60-140, 50)];
    self.value.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.value];
    
    
    
    
    UIView *fuzzyView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth -120, 0, 120, 50)];
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    [fuzzyView addGestureRecognizer:tap];
    fuzzyView.userInteractionEnabled = YES;
    [self addSubview:fuzzyView];
    
    GYAuthcodeView *authcode = [[GYAuthcodeView alloc] init];
    authcode.userInteractionEnabled = NO;
    authcode.frame = CGRectMake(0, 10, 60, 30);
    [fuzzyView addSubview:authcode];
    self.authcode = authcode;
    self.authcodeStr = authcode.authCodeStr;
    
    UILabel *fuzzyLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 60, 30)];
    fuzzyLabel.text = kLocalized(@"GYHS_Pwd_Canot_See_Purging");
    fuzzyLabel.numberOfLines = 2;
    fuzzyLabel.textAlignment = NSTextAlignmentCenter;
    fuzzyLabel.font = [UIFont systemFontOfSize:12];
    fuzzyLabel.textColor = [UIColor lightGrayColor];
    [fuzzyView addSubview:fuzzyLabel];
    
}

-(void)tapGesture {
    
    [self.authcode changeAuthcodeView];
    self.authcodeStr = self.authcode.authCodeStr;
}

-(void)refreshDataWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder {
    
    self.title.text = title;
    self.value.placeholder = placeHolder;
    
}

@end
