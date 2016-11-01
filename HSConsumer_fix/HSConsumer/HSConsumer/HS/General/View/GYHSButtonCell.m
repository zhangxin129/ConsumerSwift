//
//  GYHSButtonCell.m
//  GYHSConsumer_MyHS
//
//  Created by ios007 on 16/3/21.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSButtonCell.h"
#import "UIButton+GYExtension.h"
@implementation GYHSButtonCell

- (IBAction)clickBtn:(id)sender
{

    if ([_btnDelegate respondsToSelector:@selector(nextBtn)]) {
        [self.btnDelegate nextBtn];
        [sender controlTimeOut];
    }
}
@end
