//
//  CMDropMenuItem.m
//  CMDropDownMenu
//
//  Created by 23 on 2017/3/17.
//  Copyright © 2017年 23. All rights reserved.
//

#import "CMDropMenuItem.h"
#import <objc/runtime.h>

@implementation CMDropMenuItem

#pragma mark - 私有变量
/**替换字典的key*/
NSDictionary *_replacedKey;

/**数组中的模型*/
NSDictionary *_objectClassInArrayDict;

#pragma mark - API
/**快速创建Item*/
+ (instancetype)itemWithSuperItem:(CMDropMenuItem *)superItem Id:(NSInteger)Id title:(NSString *)title subItems:(NSArray <CMDropMenuItem *> *)subItems
{
    CMDropMenuItem *item = [[self alloc]init];
    item.superItem = superItem;
    item.Id = Id;
    item.title = title;
    item.subItems = subItems;
    return item;
}

+ (instancetype)itemWithId:(NSInteger)Id title:(NSString *)title subItems:(NSArray<CMDropMenuItem *> *)subItems
{
    CMDropMenuItem *item = [[self alloc]init];
    item.Id = Id;
    item.title = title;
    item.subItems = subItems;
    return item;
}

/**通过字典创建模型 -- 指定标准格式的字典，类似于例子中的menu1.plist所匹配的字典*/
+ (instancetype)itemWithStandardFormatKeyValue:(NSDictionary *)dictionary
{
    //创建模型
    CMDropMenuItem *item = [[self alloc]init];
    
    //获取模型当中的所有属性列表
    NSArray *propertys = [item cm_allPropertyNames];
    
    //准备待替换的key -- 字典中需要被替换的(与模型中对应的)key
    NSArray *allKeys = _replacedKey.allKeys;
    
    // 遍历字典
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *keyNew = (NSString *)key;
        
        //--1 判断当前的key是否需要被替换
        if (allKeys.count && [allKeys containsObject:key]) {
            keyNew = [_replacedKey valueForKey:key];
        }
        
        //--2 判断当前字典的key是否在模型中存在对应的同名属性
        if ([propertys containsObject:keyNew]) {
         
            //赋值
            [item cm_setValue:obj forKey:keyNew];
            
        }
        
    }];
    
    return item;
}

/**通过字典创建模型 -- 指定简单格式的字典，类似于例子中的menu2.plist所匹配的字典 -- 是否是默认的Item*/
+ (instancetype)itemWithSampleFormatKeyValue:(NSDictionary *)dictionary isDefaultItem:(BOOL)isDefaulItem
{
    
    //创建模型
    CMDropMenuItem *item = [[self alloc]init];
    
    //判断字典格式是否错误
    NSArray *allKey = [dictionary allKeys];
    if (allKey.count == 0) {
        //如果字典为空，直接返回一个空的item
        return item;
    }
    //取出第一个key,其他的key直接忽略,判断当前对应的value是否为数组，如果不是，直接返回，报错
    NSString *key = allKey.firstObject;
    id value = [dictionary valueForKey:key];
    if (![value isKindOfClass:[NSArray class]]) {
        NSLog(@"=============字典格式错误=============\n");
        NSLog(@"简单格式的字典，key的value不是数组\n");
        NSLog(@"====================================\n");
        return item;
    }
    
    //模型开始赋值
    item.Id = 0;
    item.title = key;
    NSArray *subs = (NSArray *)value;
    item.isDefaultItem = NO;
    
    //遍历数组
    int i = 0;
    NSMutableArray *subsM = [NSMutableArray array];
    for (id sub in subs) {
        
        //如果是字符串的话
        if ([sub isKindOfClass:[NSString class]]) {
            
            //创建模型
            CMDropMenuItem *subItem = [[self alloc]init];
            subItem.Id = 0;
            subItem.title = (NSString *)sub;
            subItem.isDefaultItem = (isDefaulItem && i == 0);
            subItem.superItem = item;
    
            
            [subsM addObject:subItem];
            
        }
        //如果是字典
        else if([sub isKindOfClass:[NSDictionary class]])
        {
            
            //创建模型
            CMDropMenuItem *item = [self itemWithSampleFormatKeyValue:(NSDictionary *)sub isDefaultItem:NO];
            
            //添加到数组
            [subsM addObject:item];
            
        }
        i++;
        
    }
    item.subItems = subsM;
    
    return item;
}



/**通过字典数组创建菜单  --  指定标准格式的字典数组,类似于例子中的menu1.plist所匹配的字典数组*/
+ (NSArray<CMDropMenuItem *> *)itemsWithStandardFormatKeyValueArray:(NSArray<NSDictionary *> *)array
{
    // 创建可变数组
    NSMutableArray<CMDropMenuItem *> *menuItemsM = [NSMutableArray array];
    
    // 遍历数组
    for (NSDictionary *menuDict in array) {
        
        if (![menuDict isKindOfClass:[NSDictionary class]]) {
            NSLog(@"============数据源获取失败==========");
            NSLog(@"\nitemsWithContentofFile failed -------> plist格式不一致\n");
            NSLog(@"=================================");
            return nil;
        }
        
        CMDropMenuItem *item = [self itemWithStandardFormatKeyValue:menuDict];
        
        [menuItemsM addObject:item];
        
        
    }
    return menuItemsM;
}

/**通过字典数组创建菜单  --  指定简单格式的字典数组,类似于例子中的menu2.plist所匹配的字典数组*/
+ (NSArray<CMDropMenuItem *> *)itemsWithSampleFormatKeyValueArray:(NSArray<NSDictionary *> *)array
{
    //创建可变数组
    NSMutableArray<CMDropMenuItem *> *menuItemM = [NSMutableArray array];
    
    //遍历数组
    for (NSDictionary *menuDict in array) {
        
        if (![menuDict isKindOfClass:[NSDictionary class]]) {
            
            NSLog(@"============数据源获取失败==========");
            NSLog(@"\nitemsWithContentofFile failed -------> plist格式不一致\n");
            NSLog(@"=================================");
            return nil;
            
        }
        
        //根据字典创建模型 -- 默认把第一个座位默认选项，点击后主菜单不显示
        CMDropMenuItem *item = [self itemWithSampleFormatKeyValue:menuDict isDefaultItem:YES];
        
        //添加模型
        [menuItemM addObject:item];
    }
    
    
    return menuItemM;
}


/**通过plist文件创建菜单 -- 指定标准格式的plist文件，如例子中的menu1.plist*/
+ (NSArray<CMDropMenuItem *> *)itemsWithContentsOfStandardFormatFile:(NSString *)path
{
    // 读取数组
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    // 直接调用通过字典数组创建
    return [self itemsWithStandardFormatKeyValueArray:array];
}

/**通过plist文件创建菜单 -- 指定简单格式的plist文件，如例子中的menu2.plist*/
+ (NSArray<CMDropMenuItem *> *)itemsWithContentsOfSampleFormatFile:(NSString *)path
{
    // 读取数组
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    // 直接调用通过字典数组创建
    return [self itemsWithSampleFormatKeyValueArray:array];
}


#pragma mark - 私有方法
/**获取当前类的属性名称数组*/
- (NSArray *)cm_allPropertyNames
{
    
    ///存储所有的属性名称
    NSMutableArray *allNames = [NSMutableArray array];
    
    ///存储属性的个数
    unsigned int propertyCount = 0;
    
    ///通过运行时获取当前类的属性
    objc_property_t *propertys = class_copyPropertyList([self class], &propertyCount);
    
    //把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
        ///取出第一个属性
        objc_property_t property = propertys[i];
        
        const char * propertyName = property_getName(property);
        
        [allNames addObject:[NSString stringWithUTF8String:propertyName]];
    }
    
    ///释放
    free(propertys);
    
    return allNames;
}

/**获取当前类的属性对应的属性类型*/
+ (NSString *)perpertyTypeWithName:(NSString *)name
{
    //运行时获取当前类的属性
    objc_property_t property = class_getProperty(self, [name UTF8String]);
    
    //获取属性类型名称
    const char *types = property_getAttributes(property);
    
    
    //返回
    return [NSString stringWithUTF8String:types];
}


/**设置属性*/
- (void)cm_setValue:(id)value forKey:(NSString *)key
{
    //判断值的类型
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        //如果是基本数据类型
        
        [self setValue:value forKey:key];
        
    }else if([value isKindOfClass:[NSArray class]]){
        //如果是数组 -- 如果数组中装的是字典，直接转变成CMDropDownItem模型，如果是其他类型，直接复制
        
        //转换
        NSArray *array = (NSArray *)value;
        
        //遍历
        NSMutableArray *arrayM = [NSMutableArray array];
        for (id sub in array) {
            if ([sub isKindOfClass:[NSDictionary class]]) {
                
                
                NSDictionary *itemDict = (NSDictionary *)sub;
                CMDropMenuItem *item = [CMDropMenuItem itemWithStandardFormatKeyValue:itemDict];
                item.superItem = self;
                
                [arrayM addObject:item];
                
            }else{
                [arrayM addObject:sub];
            }
        }
        [self setValue:arrayM forKey:key];
        
        
    }else if ([value isKindOfClass:[NSDictionary class]]){
        //如果是字典 -- 仅考虑当前字典是CMDropDownItem的情况
        
        NSDictionary *itemDict = (NSDictionary *)value;
        CMDropMenuItem *item = [CMDropMenuItem itemWithStandardFormatKeyValue:itemDict];
        item.superItem = self;

        [self setValue:item forKey:key];
    }
    
}




#pragma mark - 方法API
/**当字典中的key和模型中的不一致的时候，用来标明*/
+ (void)cm_setupReplacedKeyFromPropertyName:(NSDictionary *)dictionary
{
    _replacedKey = dictionary;
}

- (void)setSubItems:(NSArray<CMDropMenuItem *> *)subItems
{
    _subItems = subItems;
    
    //给子菜单每个item设置superItem
    for (CMDropMenuItem *item in subItems) {
        item.superItem = self;
    }
}

/**
 当模型中有个数组属性，数组中又包含其他的模型的时候
 字典格式： 模型中数组的名称:对应的模型的类型    eg @{@"subItems":@"CMDropMenuItem"}
 */
+ (void)cm_setupObjectClassInArray:(NSDictionary *)dictionary
{
    _objectClassInArrayDict = dictionary;
}





@end
