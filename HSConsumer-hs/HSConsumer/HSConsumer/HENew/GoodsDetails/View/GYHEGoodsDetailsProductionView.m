//
//  GYHEGoodsImageTextDetailsView.m
//  HSConsumer
//
//  Created by lizp on 16/9/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEGoodsDetailsProductionView.h"
#import "YYKit.h"
#import "GYHEGoodsDetailsProductionCell.h"

@interface GYHEGoodsDetailsProductionView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIView *productView;//产品参数
@property (nonatomic,strong) UILabel *productLabel;//产品参数文字内容
@property (nonatomic,strong) UIControl *productControl;//产品参数按钮

@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) NSMutableArray *titleHeight;//产品参数 左边说明的高度
@property (nonatomic,strong) NSMutableArray *detailHeitht;//产品参数 右边说明的高度

@end

@implementation GYHEGoodsDetailsProductionView


-(instancetype)initWithFrame:(CGRect)frame {

    if(self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}


-(void)setUp {

    self.userInteractionEnabled = YES;
    //产品参数
    self.productView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 32)];
    self.productView.layer.borderWidth = 1;
    self.productView.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
    self.productView.backgroundColor   = UIColorFromRGB(0xffffff);
    [self addSubview:self.productView];
    
    self.productLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, kScreenWidth - 12 -100 , self.productView.height)];
    self.productLabel.textColor = UIColorFromRGB(0x666666);
    self.productLabel.textAlignment = NSTextAlignmentLeft;
    self.productLabel.font = [UIFont systemFontOfSize:12];
    [self.productView addSubview:self.productLabel];
   
    
    self.productControl = [[UIControl alloc] initWithFrame:CGRectMake(kScreenWidth - 90 , 0, 78, self.productView.height)];
    self.productControl.backgroundColor = [UIColor clearColor];
    [self.productView addSubview:self.productControl];
    [self.productControl addTarget:self action:@selector(productControlClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, self.productView.height)];
    rightLabel.text = kLocalized(@"GYHE_Good_Product_Paramters");
    rightLabel.textColor = UIColorFromRGB(0x666666);
    rightLabel.textAlignment = NSTextAlignmentLeft;
    rightLabel.font = [UIFont systemFontOfSize:12];
    [self.productControl addSubview:rightLabel];
    
    self.productButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.productButton.frame = CGRectMake(rightLabel.right, 8, 16, 16);
    [self.productButton setBackgroundImage:[UIImage imageNamed:@"gy_he_up_arrow"] forState:UIControlStateNormal];
    [self.productButton setBackgroundImage:[UIImage imageNamed:@"gy_he_down_arrow"] forState:UIControlStateSelected];
    [self.productControl addSubview:self.productButton];
    

}


//产品参数点击事件
-(void)productControlClick {
    
    [self.tableView reloadData];
    if(self.delegate && [self.delegate respondsToSelector:@selector(checkProductionDetail)]) {
        [self.delegate checkProductionDetail];
    }
    
}

//尾部
-(UIView *)addFooterView {

    self.footerControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 24)];
    self.footerControl.backgroundColor  = [UIColor clearColor];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-8, 8, 16, 16)];
    arrowImageView.image = [UIImage imageNamed:@"gy_he_down_arrow"];
    [self.footerControl addSubview:arrowImageView];
    
    self.footerControl.userInteractionEnabled = YES;
    [self.footerControl addTarget:self action:@selector(footerClick) forControlEvents:UIControlEventTouchUpInside];
    
    return self.footerControl;
}

//产品参数下拉 收回
-(void)footerClick {

    if(self.delegate && [self.delegate respondsToSelector:@selector(productionBack)]) {
        [self.delegate productionBack];
    }
}

#pragma mark - tableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    GYHEGoodsDetailsProductionCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEGoodsImageTextDetailsCellIdentifier];
    if(!cell) {
        cell = [[GYHEGoodsDetailsProductionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHEGoodsImageTextDetailsCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell refreshTitle:self.data[indexPath.row][@"title"] detail:self.data[indexPath.row][@"detail"] titleHeight:[self.titleHeight[indexPath.row][@"height"] floatValue] detailHeight:[self.detailHeitht[indexPath.row][@"height"] floatValue]];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return  [self.titleHeight[indexPath.row][@"height"] floatValue] > [self.detailHeitht[indexPath.row][@"height"]  floatValue] ? [self.titleHeight[indexPath.row][@"height"] floatValue] + 22 : [self.detailHeitht[indexPath.row][@"height"] floatValue] +22;
    
}


#pragma mark - set or get 
-(UITableView *)tableView {

    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.overlayView.height -133) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.userInteractionEnabled = YES;
        [_tableView registerClass:[GYHEGoodsDetailsProductionCell class] forCellReuseIdentifier:kGYHEGoodsImageTextDetailsCellIdentifier];
        _tableView.tableFooterView = [self addFooterView];
        [self.overlayView addSubview:_tableView];
    }
    return _tableView;
}

-(UIView *)overlayView {

    if (!_overlayView) {
        _overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, self.productView.bottom, kScreenWidth, kScreenHeight - 32 -49 -64)];
        _overlayView.hidden = YES;
        _overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _overlayView.userInteractionEnabled = YES;
        [self addSubview:_overlayView];
    }
    return _overlayView;
}

-(NSMutableArray *)data {

    if(!_data) {
        _data = [[NSMutableArray alloc] init];
    }
    return _data;
}

-(void)setModel:(GYHEGoodsDetailsModel *)model {
    
    self.productLabel.text = model.name;

    for (NSDictionary *dic  in model.props) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:kSaftToNSString(dic[@"propKey"]) forKey:@"title"];
        [dict setObject:kSaftToNSString(dic[@"propValue"]) forKey:@"detail"];
        [self.data addObject:dict];
    }
    
    self.titleHeight = [[NSMutableArray alloc] init];
    self.detailHeitht = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in self.data) {

        CGSize  title = [GYUtils sizeForString:dic[@"title"] font:[UIFont systemFontOfSize:12] width:121-22-10];
        CGSize detail = [GYUtils sizeForString:dic[@"detail"] font:[UIFont systemFontOfSize:12] width:kScreenWidth -121-22];
        NSDictionary *titleDic = @{@"width":@(title.width),
                                   @"height":@(title.height)
                                   };
        NSDictionary *detailDic = @{@"width":@(detail.width),
                                    @"height":@(detail.height)
                                    };
        [self.titleHeight addObject:titleDic];
        [self.detailHeitht addObject:detailDic];
        
    }
    
    [self.tableView reloadData];
}

@end
