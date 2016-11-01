//
//  GYNetView.h
//  HSCompanyPad
//
//  Created by User on 16/8/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, kMaskViewType) {
    kMaskViewType_None = 0, //
    //
    //
    kMaskViewType_Deault
};

@interface GYNetView : UIView

@property (nonatomic,assign) kMaskViewType maskType;

-(instancetype)initWithMaskType:(kMaskViewType)type;

@property (nonatomic,strong)UIImageView *noConnectImageView;

@property (nonatomic,strong) UIButton *reloadBtn;

@end
