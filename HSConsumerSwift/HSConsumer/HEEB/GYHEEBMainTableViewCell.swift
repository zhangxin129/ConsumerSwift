//
//  GYHEEBMainTableViewCell.swift
//  HSConsumer
//
//  Created by apple on 2016/11/9.
//  Copyright © 2016年 ZX. All rights reserved.
//

import UIKit

class GYHEEBMainTableViewCell: UITableViewCell {

    var imgView: UIImageView?
    
    var titleLabel : UILabel?
    
    var selectView : UIView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor .lightGrayColor()
        
        self .setup()
        
    }
    
    func setup() -> Void {
    
        self.imgView = UIImageView(frame : CGRectMake(35, 10, 30, 30))
        
        self.contentView .addSubview(self.imgView!)
        
        self.titleLabel = UILabel(frame :  CGRectMake(20, CGRectGetMaxY(self.imgView!.frame), 60, 30))
        
        self.titleLabel?.font = UIFont .systemFontOfSize(14.0)
        
        self.titleLabel?.textColor = UIColor .blackColor()
        
        self.contentView .addSubview(self.titleLabel!)
        
        self.selectView = UIView(frame : CGRectMake(20, 77,60, 2))
        
        self.selectView?.backgroundColor = UIColor .orangeColor()
        
        self.selectView?.layer.cornerRadius = 1
        
        self.selectView?.layer.masksToBounds = true
        
        self.selectView?.hidden = true
        
        self.contentView .addSubview(self.selectView!)
        
    }
    
    var _model : catogray?
    
    var model  : catogray {
    
        set{
        
            _model = newValue
        
            self.imgView?.image = UIImage (named: model.icon!)
            
            self.titleLabel?.text = model.title
            
            if (model.select == true) {
                
                self.selectView?.hidden = false
                
                self.titleLabel?.textColor = UIColor .orangeColor()
                
                self.contentView.backgroundColor = UIColor .whiteColor()
            }else{
            
                self.selectView?.hidden = true
                
                self.titleLabel?.textColor = UIColor .blackColor()
                
                self.contentView.backgroundColor = UIColor .lightGrayColor()
            
            }
        
        }
    
        get{
        
            return _model!
        
        }
    
    }
    
    
    
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
