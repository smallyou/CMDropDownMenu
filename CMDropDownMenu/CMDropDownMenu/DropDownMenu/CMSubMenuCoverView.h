//
//  CMSubMenuCoverView.h
//  CMDropDownMenu
//
//  Created by 23 on 2017/3/17.
//  Copyright © 2017年 23. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CMSubMenuCoverView, CMDropMenuItem;

@protocol CMSubMenuCoverViewDelegate <NSObject>

- (void)subMenuCoverView:(CMSubMenuCoverView *)menuView didChildItemClick:(CMDropMenuItem *)item;

@end


@interface CMSubMenuCoverView : UIView

/**菜单模型数据源*/
@property(nonatomic,strong) NSArray *itemDatas;

@property(nonatomic,weak) id<CMSubMenuCoverViewDelegate> delegate;

/**上次选中的最终路径*/
@property(nonatomic,strong) CMDropMenuItem *lastSelectedItem;


#pragma mark - 配置属性

/**一级菜单的文字  字体*/
@property(nonatomic,strong) UIFont *firstMenuTitleFont;
/**以及菜单的文字  颜色*/
@property(nonatomic,strong) UIColor *firstMenuTitleColor;

/**二级菜单的文字  字体*/
@property(nonatomic,strong) UIFont *secondMenuTitleFont;
/**二级菜单的文字  颜色*/
@property(nonatomic,strong) UIColor *secondMenuTitleColor;

@end
