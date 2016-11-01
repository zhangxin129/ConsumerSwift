//
//  GYHEServiceOrderHeaderView.m
//  HSConsumer
//
//  Created by 吴文超 on 16/10/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//


#import "GYHEServiceOrderHeaderView.h"
#import "Masonry.h"
#import "GYHEHeadViewFirstCell.h"
#import "GYHEHeadViewSecondCell.h"
#import "GYHEHeadViewThirdCell.h"
#import "GYHEHeadViewFourthCell.h"
#import "GYHEHeadViewFifthCell.h"
@interface GYHEServiceOrderHeaderView ()<UITableViewDataSource,UITableViewDelegate,GYHEHeadViewSecondCellDelegate>

@property (nonatomic ,strong)UITableView *tabView;
//@property (nonatomic ,strong)NSMutableArray *dataArr;




@end


#define kGYHEHeadViewFirstCell @"GYHEHeadViewFirstCell"

#define kGYHEHeadViewSecondCell @"GYHEHeadViewSecondCell"
#define kGYHEHeadViewThirdCell @"GYHEHeadViewThirdCell"
#define kGYHEHeadViewFourthCell @"GYHEHeadViewFourthCell"
#define kGYHEHeadViewFifthCell @"GYHEHeadViewFifthCell"

@implementation GYHEServiceOrderHeaderView


#pragma mark-----初始设置
-(void)initView{
    self.tableViewCount = 5;//假如一开始默认是5个
    
    
//    self.address = @"11";//测试用 假如有联系人地址信息
    
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
    
    
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEHeadViewFirstCell class]) bundle:nil] forCellReuseIdentifier:kGYHEHeadViewFirstCell];
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEHeadViewSecondCell class]) bundle:nil] forCellReuseIdentifier:kGYHEHeadViewSecondCell];
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEHeadViewThirdCell class]) bundle:nil] forCellReuseIdentifier:kGYHEHeadViewThirdCell];
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEHeadViewFourthCell class]) bundle:nil] forCellReuseIdentifier:kGYHEHeadViewFourthCell];
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEHeadViewFifthCell class]) bundle:nil] forCellReuseIdentifier:kGYHEHeadViewFifthCell]; //申请赠送互生卡

}

#pragma mark-----表视图的代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableViewCount;//
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    switch (indexPath.row) {
        case 0:{
            GYHEHeadViewFirstCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHEHeadViewFirstCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabelFirst.text = kLocalized(@"预约/预订时间");
            cell.timeLabelSecond.text = @"2016-09-09 12:00";
            return cell;
        }
            
            break;
            
        case 1:
        {
            GYHEHeadViewFirstCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHEHeadViewFirstCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabelFirst.text = kLocalized(@"到店/上门时间");
            cell.timeLabelSecond.text = @"2016-09-10 12:00";
            return cell;
        }
            break;
            
        case 2:
        {
            GYHEHeadViewSecondCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHEHeadViewSecondCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
cell.titleLabelFirst.text = kLocalized(@"是否属于上门服务业务");
           
            self.isSwitchOn = cell.switchSecond.on;
            return cell;
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
            
        case 4:
        {

            //有值的时候分两种情况 看联系人信息
            if (!self.hasValidAddress) {
                GYHEHeadViewThirdCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHEHeadViewThirdCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.titleLabelFirst.text = kLocalized(@"添加上门服务地址");
                
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
    
    if(indexPath.row == 4 && self.hasValidAddress){
        return 80;
    }
    else
    {
    return 46;
    }
    

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4 && !self.hasValidAddress) {
        NSLog(@"打印信息添加上门收货地址");
    }
}

#pragma mark - 开关控件的代理方法
-(void)reloadData:(NSInteger)num{
    self.tableViewCount = num;
    [self.tabView reloadData];
    
    self.frame = [self setSelfFram];
    
    if (_delegate && [_delegate respondsToSelector:@selector(reloadData:)]) {
        [_delegate reloadData:self];
    }
    
}
//设置自身尺寸
-(CGRect)setSelfFram{
    CGFloat hightw = self.tableViewCount * 46 + 11;
    hightw = self.hasAbilityTakeHSCard == NO ? hightw -46 :hightw;
    if (self.tableViewCount == 5) {
        hightw = self.hasValidAddress ? hightw +34 :hightw;
    }
    return  CGRectMake(0, 0,kScreenWidth , hightw);
}



@end
