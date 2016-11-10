//
//  GYHEEBMainCollectionViewCell.swift
//  HSConsumer
//
//  Created by apple on 2016/11/9.
//  Copyright © 2016年 ZX. All rights reserved.
//

import UIKit

class GYHEEBMainCollectionViewCell: UICollectionViewCell {
    
    var imgView : UIImageView?
    
    var label : UILabel?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imgView = UIImageView(frame : CGRectMake(10, 10, 30, 30))
        
        self.contentView .addSubview(self.imgView!)
    
        self.label = UILabel(frame:  CGRectMake(10, CGRectGetMaxY(self.imgView!.frame)+5, 40, 30))
        
        self.label?.textColor = UIColor .blackColor()
        
        self.label?.font = UIFont .systemFontOfSize(12.0)
        
        self.contentView.addSubview(self.label!)
        
//        var _model : catogray?
//        
//        var model : catogray {
//        
//            set{
//            
//                _model = newValue
//                
//                self.imgView?.image = UIImage (named: model.icon!)
//                
//                self.label?.text = model.title
//                
//            }
//            
//            get{
//
//                return _model!
//            }
//        }
    }
    
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

    }
    
}
