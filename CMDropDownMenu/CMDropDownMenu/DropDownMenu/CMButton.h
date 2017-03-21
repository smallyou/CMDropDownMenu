//
//  CMButton.h
//  CMDropDownMenu
//
//  Created by 23 on 2017/3/20.
//  Copyright © 2017年 23. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CMDropMenuItem;
@interface CMButton : UIButton

+ (UIImage *)cm_imageWithColor:(UIColor *)color;

/**存储最终的选择路径*/
@property(nonatomic,strong) CMDropMenuItem *selectedItem;

/**记录菜单栏的标题 -- 用来恢复使用*/
@property(nonatomic,copy) NSString *menuTitle;

@end
