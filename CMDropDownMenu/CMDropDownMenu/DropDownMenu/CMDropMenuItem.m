//
//  CMDropMenuItem.m
//  CMDropDownMenu
//
//  Created by 23 on 2017/3/17.
//  Copyright © 2017年 23. All rights reserved.
//

#import "CMDropMenuItem.h"

@implementation CMDropMenuItem

+ (instancetype)itemWithSuperItem:(CMDropMenuItem *)superItem Id:(NSInteger)Id title:(NSString *)title subItems:(NSArray <CMDropMenuItem *> *)subItems
{
    CMDropMenuItem *item = [[self alloc]init];
    item.superItem = superItem;
    item.Id = Id;
    item.title = title;
    item.subItems = subItems;
    return item;
}


@end
