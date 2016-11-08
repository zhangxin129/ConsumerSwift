//
//  GYHESRMainTableViewCell.swift
//  HSConsumer
//
//  Created by apple on 2016/11/8.
//  Copyright © 2016年 ZX. All rights reserved.
//

import UIKit

class GYHESRMainTableViewCell: UITableViewCell {
    
    var timer : NSTimer?

    var scrollView : UIScrollView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self .setup()
        
    }
    
    func setup() -> Void {
        
        self.scrollView = UIScrollView(frame : CGRectMake(0,0,UIScreen.mainScreen().bounds.size.width,100))
        
        self.scrollView!.contentSize = CGSizeMake(self.scrollView!.bounds.size.width * 2, 0)
        
        self.contentView .addSubview(self.scrollView!)
        
        for i in 0...1 {
            
            let imgView :UIImageView = UIImageView(frame : CGRectMake((self.scrollView!.frame.size.width) * CGFloat(i), 0, (self.scrollView!.frame.size.width), (self.scrollView!.frame.size.height)))

            imgView.image = UIImage (named: "ad\(i+1).jpg")

            imgView.userInteractionEnabled = true
            
            imgView.tag = i + 100
            
            self.scrollView!.addSubview(imgView)
            
        }
        
        
        self.timer = NSTimer .scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(GYHESRMainTableViewCell.imgAction), userInfo: nil, repeats: true)
        
        
    }
    
    func imgAction() -> Void {
        
        var  point : CGPoint = self.scrollView!.contentOffset;
        if point.x >= self.scrollView?.frame.size.width {
            point.x = 0;
        }
        else {
            point.x = (self.scrollView?.frame.size.width)!;
        }
        
        self.scrollView!.setContentOffset(CGPointMake(point.x, 0), animated: true)

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
