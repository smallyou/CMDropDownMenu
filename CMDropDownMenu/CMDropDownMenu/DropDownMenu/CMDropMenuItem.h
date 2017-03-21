//
//  CMDropMenuItem.h
//  CMDropDownMenu
//
//  Created by 23 on 2017/3/17.
//  Copyright © 2017年 23. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMDropMenuItem : NSObject

/**父级菜单*/
@property(nonatomic,weak) CMDropMenuItem *superItem;

/**当前菜单Id*/
@property(nonatomic,assign) NSInteger Id;

/**当前菜单title*/
@property(nonatomic,copy) NSString *title;

/**子菜单*/
@property(nonatomic,strong) NSArray<CMDropMenuItem *> *subItems;


#pragma mark - flag
/**是否选中标识*/
@property(nonatomic,assign) BOOL isSelected;

/**设置是否为默认选项 -- 如果是，当用户点击当前子菜单后，菜单栏上不会消失对应子菜单的title*/
@property(nonatomic,assign) BOOL isDefaultItem;



+ (instancetype)itemWithSuperItem:(CMDropMenuItem *)superItem Id:(NSInteger)Id title:(NSString *)title subItems:(NSArray <CMDropMenuItem *> *)subItems;


@end
