//
//  GYNetView.m
//  HSCompanyPad
//
//  Created by User on 16/8/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYNetView.h"

@implementation GYNetView

#define kNetErrImageWidth 122
#define kNetMargin 30
#define kNetLabelHeight 30
-(instancetype)initWithMaskType:(kMaskViewType)type{


    self = [super init];
    
    if (self) {
        
        self.backgroundColor = kRGBA(240, 240, 240, 1);
        
        switch (type) {
            case kMaskViewType_Deault:{
            
                self.noConnectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100,64, 122, 122)];
                
                 self.noConnectImageView.userInteractionEnabled = YES;
                
                UIImage *image = [UIImage imageNamed:@"gy_net_error"];
              
                self.noConnectImageView.image = image;
             
                [self addSubview:self.noConnectImageView];
             
                @weakify(self);
                
                [self.noConnectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    @strongify(self);
                    
                    make.center.equalTo(self);
                    make.width.height.mas_equalTo(kNetErrImageWidth);
                }];
                
                
                UILabel *tintLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.noConnectImageView.frame.origin.x - 30, CGRectGetMaxY(self.noConnectImageView.frame) + 5, self.noConnectImageView.frame.size.width + 60, 15)];
                
                tintLabel.text = kLocalized(@"网络请求失败");
                
                tintLabel.textAlignment = NSTextAlignmentCenter;
                tintLabel.textColor =  kGray666666;
                
                tintLabel.numberOfLines = 0;
                tintLabel.font = [UIFont systemFontOfSize:24];
                
                [self addSubview:tintLabel];
                
                UILabel *subTintLabel =[[UILabel alloc]initWithFrame:tintLabel.frame];
                
                subTintLabel.text = kLocalized(@"请检查您的网络");

                
                subTintLabel.textAlignment = NSTextAlignmentCenter;
                subTintLabel.textColor =  kGray666666;
                
                subTintLabel.numberOfLines = 0;
                subTintLabel.font = [UIFont systemFontOfSize:24];
               
                [self addSubview:subTintLabel];

                
                [tintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                   
                    @strongify(self);

                    make.left.equalTo(self.noConnectImageView).offset(-kNetMargin);
                    make.right.equalTo(self.noConnectImageView).offset(kNetMargin);
                    make.top.equalTo(self.noConnectImageView.mas_bottom).offset(kNetMargin);
                    make.height.greaterThanOrEqualTo(@30);
                    
                }];
                
                [subTintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.right.width.equalTo(tintLabel);
                    
                    make.top.equalTo(tintLabel.mas_bottom).offset(5);
                    make.height.greaterThanOrEqualTo(@30);
                    
                }];
                
                self.reloadBtn =[UIButton buttonWithType:UIButtonTypeSystem];
                [self.reloadBtn setFrame:CGRectMake(self.noConnectImageView.frame.origin.x, CGRectGetMaxY(tintLabel.frame) + 9, self.noConnectImageView.frame.size.width, 12)];
                
                
                [self.reloadBtn setTitle:kLocalized(@"重新加载") forState:UIControlStateNormal];
                
                self.reloadBtn.titleLabel.textAlignment= NSTextAlignmentCenter;
                
                [self.reloadBtn setTitleColor:kGray666666 forState:UIControlStateNormal];
                
                self.reloadBtn.titleLabel.font =[UIFont systemFontOfSize:21];
             
                self.reloadBtn.layer.borderColor = kGrayCCCCCC.CGColor;
                self.reloadBtn.layer.borderWidth = 1;
                self.reloadBtn.layer.cornerRadius =6;
                
                
                [self addSubview:self.reloadBtn];
                
                [self.reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                   
                    make.left.width.equalTo(subTintLabel);
                    make.height.mas_equalTo(50);
                    make.top.equalTo(subTintLabel.mas_bottom).offset(40);
                }];
                
                
            } break;
            case kMaskViewType_None:{
            
                
            }
            default:
                break;
        }
    }
    
    [self layoutIfNeeded];
    
    return self;
    
}

#pragma mark -uitap method
-(void)reloadRequest{

    
}
@end
