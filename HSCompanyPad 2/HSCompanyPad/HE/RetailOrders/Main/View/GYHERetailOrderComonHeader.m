//
//  GYHERetailOrderComonHeader.m
//  HSCompanyPad
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHERetailOrderComonHeader.h"

@interface GYHERetailOrderComonHeader ()
//组1
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
//组2
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;
//组3
@property (weak, nonatomic) IBOutlet UIView *moneyView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moneyImgView;
//组4
@property (weak, nonatomic) IBOutlet UIView *pointView;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pointImgView;
//组5
@property (weak, nonatomic) IBOutlet UILabel *payStutasLabel;
//组6
@property (weak, nonatomic) IBOutlet UILabel *orderStutasLabel;
//组7
@property (weak, nonatomic) IBOutlet UILabel *deliveryLabel;
//组8
@property (weak, nonatomic) IBOutlet UILabel *operationLabel;

@end

@implementation GYHERetailOrderComonHeader

-(void)awakeFromNib {
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //组1
    _orderNumLabel.customBorderType = UIViewCustomBorderTypeLeft|UIViewCustomBorderTypeBottom;
    _orderNumLabel.customBorderColor = kGrayCFCFDA;
    //组2
    _orderDateLabel.customBorderType = UIViewCustomBorderTypeLeft|UIViewCustomBorderTypeBottom;
    _orderDateLabel.customBorderColor = kGrayCFCFDA;
    //组3
    _moneyView.customBorderType = UIViewCustomBorderTypeLeft|UIViewCustomBorderTypeBottom;
    _moneyView.customBorderColor = kGrayCFCFDA;
    //组4
    _pointView.customBorderType = UIViewCustomBorderTypeLeft|UIViewCustomBorderTypeBottom;
    _pointView.customBorderColor = kGrayCFCFDA;
    //组5
    _payStutasLabel.customBorderType = UIViewCustomBorderTypeLeft|UIViewCustomBorderTypeBottom;
    _payStutasLabel.customBorderColor = kGrayCFCFDA;
    //组6
    _orderStutasLabel.customBorderType = UIViewCustomBorderTypeLeft|UIViewCustomBorderTypeBottom;
    _orderStutasLabel.customBorderColor = kGrayCFCFDA;
    //组7
    _deliveryLabel.customBorderType = UIViewCustomBorderTypeLeft|UIViewCustomBorderTypeBottom;
    _deliveryLabel.customBorderColor = kGrayCFCFDA;
    //组8
    _operationLabel.customBorderType = UIViewCustomBorderTypeLeft|UIViewCustomBorderTypeBottom|UIViewCustomBorderTypeRight;
    _operationLabel.customBorderColor = kGrayCFCFDA;
}

@end
