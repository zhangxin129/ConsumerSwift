//
//  MessageMainTableViewCell.swift
//  HSConsumer
//
//  Created by apple on 2016/11/1.
//  Copyright © 2016年 ZX. All rights reserved.
//

import UIKit



class MessageMainTableViewCell: UITableViewCell {

    var iconImg :UIImageView?
    
    var nameLabel : UILabel?
    
    var contentLabel : UILabel?
    
    var timeLabel : UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor .whiteColor()
        self .setup()
        
    }
    
    func setup() -> Void {
        
        self.iconImg = UIImageView(frame : CGRectMake(10, 10, 66, 66))
        
        self.contentView .addSubview(self.iconImg!)
        
        self.nameLabel = UILabel(frame : CGRectMake(CGRectGetMaxX(self.iconImg!.frame)+10,10,150,30))
        
        self.nameLabel?.font = UIFont .systemFontOfSize(15.0)
        
        self.contentView .addSubview(self.nameLabel!)


        self.timeLabel = UILabel(frame : CGRectMake(CGRectGetMaxX(self.nameLabel!.frame)+10,10,200,30))
        
         self.timeLabel?.font = UIFont .systemFontOfSize(13.0)
        
        self.contentView .addSubview(self.timeLabel!)
        
        self.contentLabel = UILabel(frame : CGRectMake(CGRectGetMaxX(self.iconImg!.frame)+10,CGRectGetMaxY(self.nameLabel!.frame)+10,200,20))
        
         self.contentLabel?.font = UIFont .systemFontOfSize(13.0)
        
        self.contentView .addSubview(self.contentLabel!)
        
    }
    
    var _mes :message?
    
    var mes : message {
        
        set{
            _mes = newValue
            
            self.iconImg!.image = UIImage (named: self.mes.icon!)
        
            self.nameLabel?.text = self.mes.name
            
            self.contentLabel?.text = self.mes.content
            
            self.timeLabel!.text = self.mes.time
        }
        
        get{
            
            return _mes!
        }
    
    }
    

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
    }
    
}
