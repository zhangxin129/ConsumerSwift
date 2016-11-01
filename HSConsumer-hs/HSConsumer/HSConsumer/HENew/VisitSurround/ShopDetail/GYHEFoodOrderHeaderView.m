//
//  GYHEFoodOrderHeaderView.m
//  HSConsumer
//
//  Created by 吴文超 on 16/10/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEFoodOrderHeaderView.h"
#import "Masonry.h"
//
#import "GYHEHeadViewFifthCell.h"
#import "GYHEHeadViewThirdCell.h"
#import "GYHEHeadViewFirstCell.h"
#import "GYHEHeadViewSixthCell.h"
#import "GYHEHeadViewSeventhCell.h"
//
#import "GYHEHeadViewFourthCell.h"
@interface GYHEFoodOrderHeaderView() <UITableViewDataSource,UITableViewDelegate,GYHEHeadViewSeventhCellDelegate>
@property (nonatomic ,strong)UITableView *tabView;
@property(nonatomic , assign) NSInteger tableViewCount;
@end

#define kGYHEHeadViewFifthCell @"GYHEHeadViewFifthCell"
#define kGYHEHeadViewThirdCell @"GYHEHeadViewThirdCell"
#define kGYHEHeadViewFirstCell @"GYHEHeadViewFirstCell"
#define kGYHEHeadViewSixthCell @"GYHEHeadViewSixthCell"
#define kGYHEHeadViewSeventhCell @"GYHEHeadViewSeventhCell"

#define kGYHEHeadViewFourthCell @"GYHEHeadViewFourthCell"
@implementation GYHEFoodOrderHeaderView
-(void)initView{
self.tableViewCount = 4;
    self.frame = [self setSelfFram];
    
    
    //开始一个小图片
    UIImageView* imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"gyhe_servicelist_roseline"];
    [self addSubview:imageView];
    
    WS(weakSelf);
    [imageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.mas_equalTo(2.5);
        make.width.mas_equalTo(kScreenWidth);
        make.top.equalTo(weakSelf).offset(7.5);
        make.left.equalTo(weakSelf);
    }];
    
    //后面的表视图
    
    _tabView = [[UITableView alloc] init];
    _tabView.delegate = self;
    _tabView.dataSource = self;
    [_tabView setScrollEnabled:NO];
    _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addSubview:_tabView];
    [_tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(imageView.mas_bottom);
        
    }];
    
    //表视图需要的单元
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEHeadViewFifthCell class]) bundle:nil] forCellReuseIdentifier:kGYHEHeadViewFifthCell]; //申请赠送互生卡
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEHeadViewThirdCell class]) bundle:nil] forCellReuseIdentifier:kGYHEHeadViewThirdCell]; //添加收货地址  //要把文字改成 添加上门收货地址
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEHeadViewFourthCell class]) bundle:nil] forCellReuseIdentifier:kGYHEHeadViewFourthCell];
    
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEHeadViewFirstCell class]) bundle:nil] forCellReuseIdentifier:kGYHEHeadViewFirstCell]; //送达时间 送出时间
    
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEHeadViewSixthCell class]) bundle:nil] forCellReuseIdentifier:kGYHEHeadViewSixthCell]; //两边纯文本 支付方式 在线支付
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEHeadViewSeventhCell class]) bundle:nil] forCellReuseIdentifier:kGYHEHeadViewSeventhCell]; //一边文本 支付方式 一边滑块选择
    
    
}

#pragma mark-----表视图的代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableViewCount;//
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    switch (indexPath.row) {
        case 0:{
            
            //有值的时候分两种情况 看联系人信息
            if (!self.hasValidAddress) {
                GYHEHeadViewThirdCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHEHeadViewThirdCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.titleLabelFirst.text = kLocalized(@"添加收货地址");
                
                return cell;
            }
            else
            {//有联系人信息
                GYHEHeadViewFourthCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHEHeadViewFourthCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.nameLabel.text = @"肖海东";
                cell.telephoneLabel.text = @"13845454545";
                //地址长度应该要有所限制
                cell.addressLabel.text = @"地址:深圳市福田区福中路深圳市勘察研究院7栋深圳市归一科技研发有限公司";
                return cell;
                
            }

        }
            
            break;
            
        case 1:
        {
            GYHEHeadViewFirstCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHEHeadViewFirstCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabelFirst.text = kLocalized(@"送达时间");
            cell.timeLabelSecond.text = @"立即送出";
            return cell;
        }
            break;
            
        case 2:
        {//支付方式 滑块 或 仅仅文字
            if (self.isOnlyPayOnline) {//仅仅显示 支付方式
                GYHEHeadViewSixthCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHEHeadViewSixthCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else
            {//滑块 两种情况的处理
                GYHEHeadViewSeventhCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHEHeadViewSeventhCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
                return cell;
            }
            
        }
            break;
            
        case 3:
        {//申请赠送互生卡
            GYHEHeadViewFifthCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHEHeadViewFifthCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.hasAbilityTakeHSCard == NO) {
                cell.showHasHscardLabel.hidden = YES;
                cell.wantOrNotNeedHSCard.hidden = YES;
            }
            
            return cell;
        }
            break;

            
        default:
            break;
    }
    
    
    return nil;
}
#pragma mark-----设置表视图的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.hasAbilityTakeHSCard == NO && indexPath.row == 3) {
        return 0;
    }
    if(indexPath.row == 0 && self.hasValidAddress){
        return 80;
    }
    else
    {
        return 46;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && !self.hasValidAddress) {
        NSLog(@"打印信息添加收货地址");
    }
}





//设置自身尺寸  //注意要清晰什么时候变更最上面的尺寸 后面的位置要跟着移动
-(CGRect)setSelfFram{
    CGFloat hightw = self.tableViewCount * 46 + 11;
    hightw = self.hasAbilityTakeHSCard == NO ? hightw -46 :hightw;
    hightw = self.hasValidAddress ? hightw +34 :hightw;
    return  CGRectMake(0, 0,kScreenWidth , hightw);
}

#pragma mark - 第七个cell的代理
-(void)transmitPayType:(PaymentType)payType{
//这里要传递 支付方式 还要继续往前面传值
    NSLog(@"所传递状态的状态码是:%ld",payType);
}


@end
