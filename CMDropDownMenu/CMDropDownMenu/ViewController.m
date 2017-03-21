//
//  ViewController.m
//  CMDropDownMenu
//
//  Created by 23 on 2017/3/17.
//  Copyright © 2017年 23. All rights reserved.
//

#import "ViewController.h"
#import "CMDropDownMenu.h"
#import "CMDropMenuItem.h"


#import "CMMenuScrollView.h"


@interface ViewController () <CMDropDownMenuDelegate>

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;


@property(nonatomic,weak) CMDropDownMenu *dropDownMenu;

@property(nonatomic,weak) CMMenuScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    //设置UI
    [self setupUI];


}

- (void)setupUI
{
    //设置菜单
    CMDropMenuItem *item1 = [CMDropMenuItem itemWithSuperItem:nil Id:0 title:@"全部居委" subItems:nil];
    CMDropMenuItem *item11 = [CMDropMenuItem itemWithSuperItem:item1 Id:0 title:@"全部居委" subItems:nil];
    item11.isDefaultItem = YES; //设置默认选项，当点击当前选项，菜单栏不会变化
    CMDropMenuItem *item12 = [CMDropMenuItem itemWithSuperItem:item1 Id:0 title:@"枫叶" subItems:nil];
    CMDropMenuItem *item13 = [CMDropMenuItem itemWithSuperItem:item1 Id:0 title:@"广氮社区" subItems:nil];
    CMDropMenuItem *item14 = [CMDropMenuItem itemWithSuperItem:item1 Id:0 title:@"广州景联科技" subItems:nil];
    CMDropMenuItem *item15 = [CMDropMenuItem itemWithSuperItem:item1 Id:0 title:@"荷光东" subItems:nil];
    item1.subItems = @[item11,item12,item13,item14,item15];
    
    CMDropMenuItem *item2 = [CMDropMenuItem itemWithSuperItem:nil Id:0 title:@"家庭医生" subItems:nil];
    CMDropMenuItem *item21 = [CMDropMenuItem itemWithSuperItem:item2 Id:0 title:@"不限" subItems:nil];
    item21.isDefaultItem = YES; //设置默认选项，当点击当前选项，菜单栏不会变化
    CMDropMenuItem *item22 = [CMDropMenuItem itemWithSuperItem:item2 Id:0 title:@"已签约" subItems:nil];
    CMDropMenuItem *item23 = [CMDropMenuItem itemWithSuperItem:item2 Id:0 title:@"未签约" subItems:nil];
    item2.subItems = @[item21,item22,item23];
    
    
    CMDropMenuItem *item3 = [CMDropMenuItem itemWithSuperItem:nil Id:0 title:@"管理类型" subItems:nil];
   
    CMDropMenuItem *item31 = [CMDropMenuItem itemWithSuperItem:item3 Id:0 title:@"管理类型" subItems:nil];
    CMDropMenuItem *item311 = [CMDropMenuItem itemWithSuperItem:item31 Id:0 title:@"管理类型" subItems:nil];
    item31.subItems = @[item311];
    item311.isDefaultItem = YES; //设置默认选项，当点击当前选项，菜单栏不会变化
    
    CMDropMenuItem *item32 = [CMDropMenuItem itemWithSuperItem:item3 Id:0 title:@"正在管理" subItems:nil];
    CMDropMenuItem *item321 = [CMDropMenuItem itemWithSuperItem:item32 Id:0 title:@"居民迁入" subItems:nil];
    CMDropMenuItem *item322 = [CMDropMenuItem itemWithSuperItem:item32 Id:0 title:@"其他" subItems:nil];
    item32.subItems = @[item321,item322];
    
    CMDropMenuItem *item33 = [CMDropMenuItem itemWithSuperItem:item3 Id:0 title:@"暂停管理" subItems:nil];
    CMDropMenuItem *item331 = [CMDropMenuItem itemWithSuperItem:item33 Id:0 title:@"无法联系" subItems:nil];
    CMDropMenuItem *item332 = [CMDropMenuItem itemWithSuperItem:item33 Id:0 title:@"住他处" subItems:nil];
    CMDropMenuItem *item333 = [CMDropMenuItem itemWithSuperItem:item33 Id:0 title:@"拒访" subItems:nil];
    CMDropMenuItem *item334 = [CMDropMenuItem itemWithSuperItem:item33 Id:0 title:@"其他" subItems:nil];
    item33.subItems = @[item331,item332,item333,item334];
    
    
    
    CMDropMenuItem *item34 = [CMDropMenuItem itemWithSuperItem:item3 Id:0 title:@"停止管理" subItems:nil];
    CMDropMenuItem *item341 = [CMDropMenuItem itemWithSuperItem:item34 Id:0 title:@"居民迁出" subItems:nil];
    CMDropMenuItem *item342 = [CMDropMenuItem itemWithSuperItem:item34 Id:0 title:@"死亡" subItems:nil];
    CMDropMenuItem *item343 = [CMDropMenuItem itemWithSuperItem:item34 Id:0 title:@"其他" subItems:nil];
    item34.subItems = @[item341,item342,item343];

    item3.subItems = @[item31,item32,item33,item34];
    
    
    CMDropMenuItem *item4 = [CMDropMenuItem itemWithSuperItem:nil Id:0 title:@"排序" subItems:nil];
    CMDropMenuItem *item41 = [CMDropMenuItem itemWithSuperItem:item4 Id:0 title:@"排序" subItems:nil];
    item41.isDefaultItem  = YES; //设置默认选项，当点击当前选项，菜单栏不会变化
    CMDropMenuItem *item42 = [CMDropMenuItem itemWithSuperItem:item4 Id:0 title:@"按建档日期倒叙排序" subItems:nil];
    CMDropMenuItem *item43 = [CMDropMenuItem itemWithSuperItem:item4 Id:0 title:@"按姓名顺序排序" subItems:nil];
    CMDropMenuItem *item44 = [CMDropMenuItem itemWithSuperItem:item4 Id:0 title:@"按姓名倒叙排序" subItems:nil];
    CMDropMenuItem *item45 = [CMDropMenuItem itemWithSuperItem:item4 Id:0 title:@"按年龄从小到大排序" subItems:nil];
    item4.subItems = @[item41, item42, item43, item44, item45];
    

    
    CMDropDownMenu *dropDownMenu = [[CMDropDownMenu alloc]init];
    self.dropDownMenu = dropDownMenu;
    dropDownMenu.titleDatas = @[item1,item2, item3, item4];
    dropDownMenu.delegate = self;
    [self.view addSubview:dropDownMenu];
    
    
    
    self.title = @"下拉列表菜单";
    
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.dropDownMenu.frame = CGRectMake(0, 100, self.view.bounds.size.width, 44);
}

#pragma mark - CMDropDownMenuDelegate

- (void)dropDownMenu:(CMDropDownMenu *)dropDownMenu didChildItemSelected:(CMDropMenuItem *)item
{
    NSString *path = @"";
    

    path = [@"选中的路径是:" stringByAppendingPathComponent:[self getChoosePath:item]];
    
    self.resultLabel.text = path;
    
    
}


/**反向获取选择路径*/
- (NSString *)getChoosePath:(CMDropMenuItem *)item
{
    NSString *result = item.title;
    
    //获取父节点
    if (item.superItem) {
        
        CMDropMenuItem *superItem = item.superItem;
    
        //拼接
        return [[self getChoosePath:superItem] stringByAppendingPathComponent:result];
        
    }else{
        return result;
    }
    
    
}






@end
