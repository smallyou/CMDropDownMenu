//
//  CMMenuScrollView.h
//  CMDropDownMenu
//
//  Created by 23 on 2017/3/17.
//  Copyright © 2017年 23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMButton.h"
@class CMMenuScrollView;


@protocol CMMenuScrollViewDelegate <UIScrollViewDelegate>

/**菜单栏被点击*/
- (void)menuScrollView:(CMMenuScrollView *)menuView didMenuBtnClick:(UIButton *)button;

/**菜单栏被重复点击*/
- (void)menuScrollView:(CMMenuScrollView *)menuView didMenuBtnDoubleClick:(UIButton *)button;

@end


@interface CMMenuScrollView : UIScrollView

@property(nonatomic,strong) NSArray *titles;

@property(nonatomic,weak) id<CMMenuScrollViewDelegate> delegate;

/**当前选中的菜单按钮*/
@property(nonatomic,strong, readonly) CMButton *selectedButton;


#pragma mark - 配置属性
/**菜单栏是否可以滚动 -- 是否平分宽度*/
@property(nonatomic,assign) BOOL menuBarScrollable;
/**菜单栏中的菜单文字 字体*/
@property(nonatomic,strong) UIFont *menuTitleFont;
/**菜单栏中的菜单文字 颜色*/
@property(nonatomic,strong) UIColor *menuTitleColor;



@end
