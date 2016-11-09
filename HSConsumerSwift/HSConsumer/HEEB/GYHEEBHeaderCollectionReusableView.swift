//
//  GYHEEBHeaderCollectionReusableView.swift
//  HSConsumer
//
//  Created by apple on 2016/11/9.
//  Copyright © 2016年 ZX. All rights reserved.
//

import UIKit

class GYHEEBHeaderCollectionReusableView: UICollectionReusableView {
    
    var label : UILabel?
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        let imgView : UIImageView = UIImageView(frame : CGRectMake(20,10,20,20))
        
        imgView.backgroundColor = UIColor .orangeColor()
        
        imgView.layer.cornerRadius = 10
        
        imgView.layer.masksToBounds = true
        
        self .addSubview(imgView)
        
        self.label = UILabel(frame : CGRectMake(CGRectGetMaxX(imgView.frame)+5,10,200,40))
        
        self.label?.font = UIFont .systemFontOfSize(14.0)
        self .addSubview(self.label!)
        
        let arrowImg :UIImageView = UIImageView(frame : CGRectMake(CGRectGetMaxX(self.label!.frame)+5, 10, 20, 30))
        
        arrowImg.image = UIImage (named: "gyhd_cell_arrow_right_icon")
        
        self .addSubview(arrowImg)
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        
         super.init(coder: aDecoder)!
    }
    
}
