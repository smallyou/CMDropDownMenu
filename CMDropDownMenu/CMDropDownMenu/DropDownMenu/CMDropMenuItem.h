//
//  CMDropMenuItem.h
//  CMDropDownMenu
//
//  Created by 23 on 2017/3/17.
//  Copyright © 2017年 23. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CMDropMenuItem;

@interface CMDropMenuItem : NSObject

/**父级菜单*/
@property(nonatomic,weak) CMDropMenuItem *superItem;

/**当前菜单Id*/
@property(nonatomic,assign) NSInteger Id;

/**当前菜单title*/
@property(nonatomic,copy) NSString *title;

/**子菜单*/
@property(nonatomic,strong) NSArray<CMDropMenuItem *> *subItems;

@property(nonatomic,strong) CMDropMenuItem *test;

#pragma mark - flag
/**是否选中标识*/
@property(nonatomic,assign) BOOL isSelected;

/**设置是否为默认选项 -- 如果是，当用户点击当前子菜单后，菜单栏上不会消失对应子菜单的title*/
@property(nonatomic,assign) BOOL isDefaultItem;


/**快速创建菜单项*/
+ (instancetype)itemWithSuperItem:(CMDropMenuItem *)superItem Id:(NSInteger)Id title:(NSString *)title subItems:(NSArray <CMDropMenuItem *> *)subItems;

/**快速创建菜单项--忽略superItem，程序自动识别*/
+ (instancetype)itemWithId:(NSInteger)Id title:(NSString *)title subItems:(NSArray<CMDropMenuItem *> *)subItems;

/**通过字典创建模型*/
+ (instancetype)itemWithKeyValue:(NSDictionary *)dictionary;

/**通过字典数组创建菜单*/
+ (NSArray<CMDropMenuItem *> *)itemsWithKeyValueArray:(NSArray<NSDictionary *> *)array;

/**通过plist文件创建菜单*/
+ (NSArray<CMDropMenuItem *> *)itemsWithContentsOfFile:(NSString *)path;





#pragma mark - 工具方法
/**
    当字典中的key和模型中的不一致的时候，用来标明
    字典格式: 字典中的key:模型的key   eg   @{ @"subItem":@"subItems"}
 */
+ (void)cm_setupReplacedKeyFromPropertyName:(NSDictionary *)dictionary;

/**
 当模型中有个数组属性，数组中又包含其他的模型的时候
 字典格式： 模型中数组的名称:对应的模型的类型    eg @{@"subItems":@"CMDropMenuItem"}
 */
+ (void)cm_setupObjectClassInArray:(NSDictionary *)dictionary;


#pragma mark - 私有工具
/**获取当前类的属性名称数组*/
- (NSArray *)cm_allPropertyNames;

/**设置属性*/
- (void)cm_setValue:(id)value forKey:(NSString *)key;

@end
