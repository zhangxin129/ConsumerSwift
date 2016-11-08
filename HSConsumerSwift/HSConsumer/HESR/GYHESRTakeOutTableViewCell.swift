//
//  GYHESRTakeOutTableViewCell.swift
//  HSConsumer
//
//  Created by apple on 2016/11/8.
//  Copyright © 2016年 ZX. All rights reserved.
//

import UIKit

class GYHESRTakeOutTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self .setup()
        
    }
    
    
    func setup() -> Void {
        
        let takeOutView :UIView = UIView(frame : CGRectMake(0,0,UIScreen .mainScreen().bounds.size.width,50))
        
        takeOutView.backgroundColor = UIColor .lightGrayColor()

        takeOutView.userInteractionEnabled = true
        
        self.contentView .addSubview(takeOutView)
        
        let takeOutBtn : UIButton = UIButton(frame : (frame : CGRectMake(10,10,UIScreen .mainScreen().bounds.size.width-30,30)))

        takeOutBtn .setTitle( "外卖上门频道", forState: UIControlState.Normal)
        
        takeOutBtn .setTitleColor(UIColor .blueColor(), forState: UIControlState.Normal)
        
        takeOutBtn .setImage(UIImage (named: "gy_he_back_arrow"), forState: UIControlState.Normal)
        
        takeOutBtn .imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -takeOutBtn.frame.size.width+100)
        
        takeOutBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -takeOutBtn.frame.size.width+100, 0, 0)
        
        takeOutView .addSubview(takeOutBtn)
        
        let distance_x : CGFloat  = (takeOutView.frame.size.width - 180)/4
        
         let titleArr : Array<String> = ["周边","外卖(送货)","上门(到家)"]
        
        for i in 0...2 {
            
            let imgView : UIImageView = UIImageView(frame :CGRectMake(distance_x + (distance_x + 60)*CGFloat(i), CGRectGetMaxY(takeOutView.frame) + 20, 60, 60))
        
            imgView.tag = i + 1
            
            imgView.layer.cornerRadius = 30
            
            imgView.layer.masksToBounds = true
            
            let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(GYHESRTakeOutTableViewCell.imgTap(_:)))
            
            imgView.userInteractionEnabled = true
            
            imgView .addGestureRecognizer(tap)
            
            imgView.backgroundColor = UIColor .redColor()
            
            self.contentView .addSubview(imgView)

            let titleLabel : UILabel = UILabel(frame : CGRectMake(imgView.frame.origin.x , CGRectGetMaxY(imgView.frame) , 60, 30))
            
            titleLabel.text = titleArr[i]
            
            titleLabel.font = UIFont .systemFontOfSize(12)
            
            titleLabel.textAlignment = NSTextAlignment.Center
            
            self.contentView.addSubview(titleLabel)
        }
        
        
    }
    
    func imgTap(sender:UITapGestureRecognizer) {
        
        print(sender.view?.tag)
        
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
