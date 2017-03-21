//
//  CMDropDownMenu.h
//  CMDropDownMenu
//
//  Created by 23 on 2017/3/17.
//  Copyright © 2017年 23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMDropMenuItem.h"
#import "CMMenuScrollView.h"

@class CMDropDownMenu;

@protocol CMDropDownMenuDelegate <NSObject>

/**当最后一级菜单被点击后的回调*/
- (void)dropDownMenu:(CMDropDownMenu *)dropDownMenu didChildItemSelected:(CMDropMenuItem *)item;

@end


@interface CMDropDownMenu : UIView

/**数据源*/
@property(nonatomic,strong) NSArray<CMDropMenuItem *> *titleDatas;

/**代理*/
@property(nonatomic,weak) id<CMDropDownMenuDelegate> delegate;

/**用来配置菜单栏是否可以滚动*/
-(instancetype)initWithMenuBarScrollable:(BOOL)scrollable;

#pragma mark - 配置属性

/**菜单栏中的菜单文字 字体*/
@property(nonatomic,strong) UIFont *menuTitleFont;
/**菜单栏中的菜单文字 颜色*/
@property(nonatomic,strong) UIColor *menuTitleColor;

/**一级菜单的文字  字体*/
@property(nonatomic,strong) UIFont *firstMenuTitleFont;
/**以及菜单的文字  颜色*/
@property(nonatomic,strong) UIColor *firstMenuTitleColor;

/**二级菜单的文字  字体*/
@property(nonatomic,strong) UIFont *secondMenuTitleFont;
/**二级菜单的文字  颜色*/
@property(nonatomic,strong) UIColor *secondMenuTitleColor;


@end
