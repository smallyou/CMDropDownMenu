//
//  CMDropDownMenu.h
//  CMDropDownMenu
//
//  Created by 23 on 2017/3/17.
//  Copyright © 2017年 23. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CMDropMenuItem,CMDropDownMenu;

@protocol CMDropDownMenuDelegate <NSObject>

/**当最后一级菜单被点击后的回调*/
- (void)dropDownMenu:(CMDropDownMenu *)dropDownMenu didChildItemSelected:(CMDropMenuItem *)item;

@end


@interface CMDropDownMenu : UIView

/**数据源*/
@property(nonatomic,strong) NSArray<CMDropMenuItem *> *titleDatas;

/**代理*/
@property(nonatomic,weak) id<CMDropDownMenuDelegate> delegate;

@end
