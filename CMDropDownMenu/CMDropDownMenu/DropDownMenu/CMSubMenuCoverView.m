//
//  CMSubMenuCoverView.m
//  CMDropDownMenu
//
//  Created by 23 on 2017/3/17.
//  Copyright © 2017年 23. All rights reserved.
//

#import "CMSubMenuCoverView.h"
#import "CMDropMenuItem.h"
#import "CMButton.h"

@interface CMSubMenuCoverView () <UITableViewDelegate,UITableViewDataSource>
/**左边的主菜单*/
@property(nonatomic,weak) UITableView *rootTableView;

/**右边的子菜单*/
@property(nonatomic,weak) UITableView *subTableView;

/**子菜单的数据源*/
@property(nonatomic,strong) NSMutableArray *subItemDatas;



@end

@implementation CMSubMenuCoverView

#pragma mark - 懒加载
- (NSMutableArray *)subItemDatas
{
    if (_subItemDatas == nil) {
        _subItemDatas = [NSMutableArray array];
    }
    return _subItemDatas;
}


- (void)setItemDatas:(NSArray *)itemDatas
{
    _itemDatas = itemDatas;
    
    //移除
    if (self.rootTableView) {
        [self.rootTableView removeFromSuperview];
        self.rootTableView = nil;
    }
    if (self.subTableView) {
        [self.subTableView removeFromSuperview];
        self.subTableView = nil;
    }
    
    //创建主菜单
    UITableView *rootTableView = [[UITableView alloc]init];
    rootTableView.rowHeight = 44;
    rootTableView.dataSource = self;
    rootTableView.delegate = self;
    rootTableView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    rootTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    rootTableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0];
    [self addSubview:rootTableView];
    self.rootTableView = rootTableView;
    
    
    //创建子菜单
    if ([self isMoreTwoChilren:itemDatas]) {
        UITableView *subTableView = [[UITableView alloc]init];
        subTableView.rowHeight = 44;
        subTableView.dataSource = self;
        subTableView.delegate = self;
        subTableView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
        subTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        subTableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0];
        [self addSubview:subTableView];
        self.subTableView = subTableView;
        [self.subTableView reloadData];
    }
    
    
    //根据上次的选择路径确认当前的默认选项
    if (self.lastSelectedItem) {
        [self updateSelectedFlag:self.lastSelectedItem flag:YES];
        CMDropMenuItem *item = self.lastSelectedItem.superItem;
        self.subItemDatas = [NSMutableArray arrayWithArray:item.subItems];
        
        
    }else{
        if ([self isMoreTwoChilren:itemDatas]) {
            self.lastSelectedItem = [[self.itemDatas.firstObject subItems] firstObject];
        }else{
            self.lastSelectedItem = self.itemDatas.firstObject;
        }
        
        [self updateSelectedFlag:self.lastSelectedItem flag:YES];
        self.subItemDatas = [NSMutableArray arrayWithArray:[self.itemDatas.firstObject subItems]];
    }
    
    
    //菜单刷新
    [self.rootTableView reloadData];
    [self.subTableView reloadData];
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //如果有二级菜单
    if (self.subTableView) {
        
        //1 布局主菜单
        CGFloat rootTableHeight = self.rootTableView.rowHeight * self.itemDatas.count;
        if (rootTableHeight > 250) {
            rootTableHeight = 250;
        }
        self.rootTableView.frame = CGRectMake(0, 0, self.bounds.size.width / 3, rootTableHeight);
        
        //2 布局子菜单
        CGFloat subTableHeight = self.subTableView.rowHeight * self.subItemDatas.count;
        if (subTableHeight > rootTableHeight) {
            subTableHeight = rootTableHeight;
        }
        self.subTableView.frame = CGRectMake(self.bounds.size.width / 3, 0, self.bounds.size.width * 2 / 3, subTableHeight);
        
    }
    //如果没有二级菜单
    else{
        
        //布局主菜单
        CGFloat rootTableHeight = self.rootTableView.rowHeight * self.itemDatas.count;
        if (rootTableHeight > 250) {
            rootTableHeight = 250;
        }
        self.rootTableView.frame = CGRectMake(0, 0, self.bounds.size.width, rootTableHeight);

    }
}



#pragma mark - 工具方法

/**判断是否大于等于2个层级*/
- (BOOL)isMoreTwoChilren:(NSArray *)subItemDatas
{
    for (CMDropMenuItem *item in subItemDatas) {
        if (item.subItems.count) {
            return YES;
        }
    }
    return NO;
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //如果是主菜单
    if ([tableView isEqual:self.rootTableView]) {
        return self.itemDatas.count;
    }
    //如果是子菜单
    if ([tableView isEqual:self.subTableView]) {
        CGFloat height = self.subTableView.rowHeight * self.subItemDatas.count;
        if (height > 250) {
            height = 250;
        }
        self.subTableView.frame = CGRectMake(self.subTableView.frame.origin.x, self.subTableView.frame.origin.y, self.subTableView.frame.size.width, height);
        return self.subItemDatas.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.rootTableView]) {
        
        static NSString *ID = @"root";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.textLabel.font = [UIFont systemFontOfSize:13.0];
            cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[CMButton cm_imageWithColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]]];
        }
        
        //取出模型
        CMDropMenuItem *item = self.itemDatas[indexPath.row];
        
        if (self.subTableView == nil) {
            
            cell.accessoryView = item.isSelected?[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"resource.bundle/ic_bookbuild_right"]]:nil;
            
        }else{
            
            if (item.isSelected) {
                [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }else{
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
            }
            
            
        }
        
        cell.textLabel.text = item.title;
        return cell;
    }
    
    if ([tableView isEqual:self.subTableView]) {
        
        static NSString *ID = @"sub";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.textLabel.font = [UIFont systemFontOfSize:13.0];
            cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"resource.bundle/ic_bookbuild_right"]];
            cell.accessoryView.hidden = YES;
            cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[CMButton cm_imageWithColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]]];
        }
        
        //取出模型
        CMDropMenuItem *item = self.subItemDatas[indexPath.row];
        cell.accessoryView.hidden = !item.isSelected;
    
        cell.textLabel.text = item.title;
        
        return cell;

    }
    
    return nil;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.rootTableView]) {
        
        //取出模型
        CMDropMenuItem *item = self.itemDatas[indexPath.row];
        NSArray *subItems = item.subItems;
        
        //判断是否只有一级菜单
        if (self.subTableView == nil) {
            
            //取消选中
            [self updateSelectedFlag:self.lastSelectedItem flag:NO];
            [self updateSelectedFlag:item flag:NO];
            
            //当前点击的是最终子节点
            if ([self.delegate respondsToSelector:@selector(subMenuCoverView:didChildItemClick:)]) {
                [self.delegate subMenuCoverView:self didChildItemClick:item];
            }
            
            return;
        }
        
        //刷新子菜单
        self.subItemDatas = [NSMutableArray arrayWithArray:subItems];
        [self.subTableView reloadData];

        
        
        
    }else{
        
        //取出当前的模型
        CMDropMenuItem *item = self.subItemDatas[indexPath.row];
        
        //判断是否还有下一级的子菜单
        if (item.subItems.count == 0) {
            
            //取消选中
            [self updateSelectedFlag:self.lastSelectedItem flag:NO];
            [self updateSelectedFlag:item flag:NO];
            
            
            //当前点击的是最终子节点
            if ([self.delegate respondsToSelector:@selector(subMenuCoverView:didChildItemClick:)]) {
                [self.delegate subMenuCoverView:self didChildItemClick:item];
            }
            
        }else{
            
            //如果还有下一级的子菜单------之后在处理
            
            
            
            
            
        }
        
        NSLog(@"");
        
        
    }
    
    
    
}


/**设置当前路径的选中状态*/
- (void)updateSelectedFlag:(CMDropMenuItem *)item flag:(BOOL)isSelected
{
    if (item == nil) {
        return;
    }
    item.isSelected = isSelected;
    [self updateSelectedFlag:item.superItem flag:isSelected];
    
}




@end
