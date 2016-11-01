//
//  GYMoreLineTipsView1.h
//  HSCompanyPad
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYMoreLineTipsViewCell;
@interface GYMoreLineTipsView : UIView

@property (nonatomic, strong) NSArray* dataArray;

@end

@interface GYMoreLineTipsViewCell : UITableViewCell

@property (nonatomic, strong) UILabel* label;

@end