//
//  GYHEShopHeaderView.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEShopHeaderView.h"
#import "Masonry.h"
@interface GYHEShopHeaderView()

@property (weak, nonatomic) IBOutlet UILabel *shopNameLab;
@property (weak, nonatomic) IBOutlet UILabel *hsNumLab;

@property (weak, nonatomic) IBOutlet UIImageView *contactShoperImgV;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *hsCardBtn;

@property (strong ,nonatomic)UIView *hsCardAppleView;

@property (strong ,nonatomic) NSMutableArray *imgArr;

@end

@implementation GYHEShopHeaderView

- (IBAction)canGiveHsCard:(id)sender {
    
    [self performSelector:@selector(dismissView:) withObject:self.hsCardAppleView afterDelay:1.0];
}

- (void)dismissView:(UIView *)view {
    [UIView animateWithDuration:1.5 animations:^{
        view.alpha = 0;

    }];
}

- (UIView *)hsCardAppleView {
    if(!_hsCardAppleView) {
        UIView *view = [[UIView alloc] init];
        view.layer.contents = (id)[UIImage imageNamed:@"gyhe_shop_detail_could_get_hsCard"].CGImage;
        view.layer.backgroundColor = [UIColor clearColor].CGColor;
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_hsCardBtn.mas_left).with.offset(-80);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(43);
            make.bottom.equalTo(_hsCardBtn.mas_top).with.offset(5);
        }];
        UILabel *lab = [[UILabel alloc] init];
        lab.text = kLocalized(@"可申请互生卡企业");
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont systemFontOfSize:12];
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.centerY.equalTo(view).with.offset(-5);
        }];
        _hsCardAppleView = view;
    }else {
        _hsCardAppleView.alpha = 1;
    }
    return _hsCardAppleView;
}

- (void)setModel:(GYHEShopDetailModel *)model {
    _model = model;
    _shopNameLab.text = kSaftToNSString(model.vshopName);
    _hsNumLab.text = [NSString stringWithFormat:@"%@:%@",kLocalized(@"互生号"),kSaftToNSString(model.resourceNo)];
    _hsCardAppleView.hidden = !model.isCanHairpin;
    for(NSDictionary *dict in _model.vshopPics) {
        [self.imgArr addObject:kSaftToNSString(dict[@"sourceSize"])];
    }
}

- (NSMutableArray *)imgArr {
    if(!_imgArr) {
        _imgArr = [[NSMutableArray alloc] init];
    }
    return _imgArr;
}

@end
