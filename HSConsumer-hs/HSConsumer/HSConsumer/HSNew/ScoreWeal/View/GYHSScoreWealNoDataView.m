//
//  GYHSScoreWealNoDataView.m
//  HSConsumer
//
//  Created by lizp on 16/9/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSScoreWealNoDataView.h"
#import "YYKit.h"
#import "GYHSTools.h"


@implementation GYHSScoreWealNoDataView

-(instancetype)initWithFrame:(CGRect)frame {

    if(self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}


-(void)setUp {
    
    UIImageView *noDataImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-24, 87, 48, 48)];
    noDataImageView.image = [UIImage imageNamed:@"gycommon_search_norecord"];
    [self addSubview:noDataImageView];
    
    UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, noDataImageView.bottom + 10, self.bounds.size.width, 20)];
    noDataLabel.text = kLocalized(@"GYHS_Weal_NoRecord");
    noDataLabel.textColor  = UIColorFromRGB(0x666666);
    noDataLabel.font = kScoreWealNoDataFont;
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:noDataLabel];
}

@end
