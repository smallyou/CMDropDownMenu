//
//  CMButton.m
//  CMDropDownMenu
//
//  Created by 23 on 2017/3/20.
//  Copyright © 2017年 23. All rights reserved.
//

#import "CMButton.h"

@interface CMButton ()




@end


@implementation CMButton

+ (UIImage *)cm_imageWithColor:(UIColor *)color
{
    //开启上线
    UIGraphicsBeginImageContext(CGSizeMake(100, 100));
    
    //画图
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 100, 100)];
    [color setFill];
    [path fill];
    
    //获取图片
    return UIGraphicsGetImageFromCurrentImageContext();
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(self.imageView.frame.origin.x, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    self.imageView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height);
    
}




- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundImage:[CMButton cm_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self setBackgroundImage:[CMButton cm_imageWithColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]] forState:UIControlStateSelected];
        
        //设置Label的属性
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.titleLabel.numberOfLines = 1;
        
    }
    return self;
}


@end
