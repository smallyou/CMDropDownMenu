//
//  CMDropDownMenu.m
//  CMDropDownMenu
//
//  Created by 23 on 2017/3/17.
//  Copyright © 2017年 23. All rights reserved.
//

#import "CMDropDownMenu.h"
#import "CMDropMenuItem.h"
#import "CMMenuScrollView.h"
#import "CMSubMenuCoverView.h"

@interface CMDropDownMenu() <CMMenuScrollViewDelegate, CMSubMenuCoverViewDelegate,UIGestureRecognizerDelegate>

#pragma mark - view相关
/**顶部的菜单栏*/
@property(nonatomic,weak) CMMenuScrollView *scrollView;
/**点击菜单栏后展开的子菜单蒙版*/
@property(nonatomic,weak) CMSubMenuCoverView *coverView;

#pragma mark - 记录标签
/**菜单栏选中的序列*/
@property(nonatomic,assign) NSInteger selectedMenuIndex;
/**上一次选中的路径*/
@property(nonatomic,strong) CMDropMenuItem *lastSelectedPath;


@end


@implementation CMDropDownMenu
#pragma mark - 懒加载


- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        /**初始化*/
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    /**初始化*/
    [self setup];
}


#pragma mark - 初始化相关
/**初始化*/
-(void)setup
{
    //初始化UI
    [self setupUI];
}

/**初始化UI*/
- (void)setupUI
{
    //1 scorllView
    CMMenuScrollView *scrollView = [[CMMenuScrollView alloc]init];
    scrollView.delegate = self;
    self.scrollView = scrollView;
    [self addSubview:scrollView];
}

/**布局子控件*/
- (void)layoutSubviews
{
    //1 布局scrollView
    self.scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
}

#pragma mark - 事件监听
/**setter重写*/
-(void)setTitleDatas:(NSArray<CMDropMenuItem *> *)titleDatas
{
    _titleDatas = titleDatas;
    
    //取出菜单栏titles
    NSMutableArray *arrayM = [NSMutableArray array];
    for (CMDropMenuItem *item in titleDatas) {
        [arrayM addObject:item.title];
    }
    
    //赋值
    self.scrollView.titles = arrayM;
    
}

/**点击coverView的手势监听*/
- (void)tapCoverView:(UITapGestureRecognizer *)tap
{
    self.scrollView.selectedButton.selected = NO;
    self.scrollView.selectedButton.imageView.transform = CGAffineTransformIdentity;
    
    
    //移除子菜单
    if (self.coverView) {
        [self.coverView removeFromSuperview];
    }
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[CMSubMenuCoverView class ]]) {
        return YES;
    }
    return NO;
}

#pragma mark - CMMenuScrollViewDelegate
/**菜单栏被点击*/
- (void)menuScrollView:(CMMenuScrollView *)menuView didMenuBtnClick:(UIButton *)button
{
    
    //取出当前菜单栏选中的index
    self.selectedMenuIndex = button.tag - 2000;
    
    //取出对应的模型
    CMDropMenuItem *item = self.titleDatas[self.selectedMenuIndex];
    
    //判断当前是否存在子菜单
    if (item.subItems.count) {
       
        //取出子菜单的数据源
        NSArray *subItemDatas = item.subItems;
        
        //创建子菜单
        [self setupChildMenuWithDatas:subItemDatas];
        
        
    }else{
        
        //更新选中状态
        [self updateSelectedFlag:self.lastSelectedPath flag:NO];
        [self updateSelectedFlag:item flag:YES];
        self.lastSelectedPath = item;
        
        
        //移除子菜单
        if (self.coverView) {
            [self.coverView removeFromSuperview];
        }
        
        
        
        //不存在子菜单，直接通知代理
        if ([self.delegate respondsToSelector:@selector(dropDownMenu:didChildItemSelected:)]) {
            [self.delegate dropDownMenu:self didChildItemSelected:item];
        }
    }
    
}

/**菜单栏被重复点击*/
- (void)menuScrollView:(CMMenuScrollView *)menuView didMenuBtnDoubleClick:(UIButton *)button
{
    
    if (button.selected) {
        //移除蒙版
        if (self.coverView) {
            [self.coverView removeFromSuperview];
        }
        
    }else{
    
        //取出子菜单的数据源
        CMDropMenuItem *item = self.titleDatas[self.selectedMenuIndex];
        NSArray *subItemDatas = item.subItems;
        
        //创建子菜单
        [self setupChildMenuWithDatas:subItemDatas];
    }
    
    button.selected = !button.isSelected;
    
    
    
}


#pragma mark - 子菜单相关
/**创建子菜单*/
- (void)setupChildMenuWithDatas:(NSArray *)subItemDatas
{
    //1 移除子菜单蒙版
    if (self.coverView) {
        [self.coverView removeFromSuperview];
    }
    
    //2 创建子菜单蒙版
    CMSubMenuCoverView *coverView = [[CMSubMenuCoverView alloc]init];
    coverView.delegate = self;
    coverView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    coverView.lastSelectedItem = self.scrollView.selectedButton.selectedItem;   //传递上次选中的路径给菜单栏
    coverView.itemDatas = subItemDatas; //设置数据源
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCoverView:)];
    [coverView addGestureRecognizer:tap];
    tap.delegate = self;
    CGRect menuFrame = self.frame;
    coverView.frame = CGRectMake(menuFrame.origin.x, CGRectGetMaxY(menuFrame), menuFrame.size.width, self.superview.bounds.size.height);
    [self.superview addSubview:coverView];
    self.coverView = coverView;

}


#pragma mark - CMSubMenuCoverViewDelegate
/**点击了最终的子节点*/
- (void)subMenuCoverView:(CMSubMenuCoverView *)menuView didChildItemClick:(CMDropMenuItem *)item
{
    //更新选中状态
    [self updateSelectedFlag:self.lastSelectedPath flag:NO];
    [self updateSelectedFlag:item flag:YES];
    self.lastSelectedPath = item;
    self.scrollView.selectedButton.imageView.transform = CGAffineTransformIdentity;
    
    //移除子菜单
    if (self.coverView) {
        [self.coverView removeFromSuperview];
    }
    
    //记录当前的最终选择路径
    self.scrollView.selectedButton.selected = NO;
    self.scrollView.selectedButton.selectedItem = item;
    if (item.isDefaultItem) {
        //如果是默认选项，恢复菜单栏标题会最初始化的标题，也即是最根层的标题
        UIButton *button = (UIButton *)self.scrollView.selectedButton;
        [button setTitle:self.scrollView.selectedButton.menuTitle forState:UIControlStateNormal];
    }else{
        //如果不是默认选项，菜单栏标题才会变化
        UIButton *button = (UIButton *)self.scrollView.selectedButton;
        [button setTitle:item.title forState:UIControlStateNormal];
    }
    
    //如果标题栏发生变化，需要滚动菜单栏
    //---1 获取当前选中菜单按钮的最大x轴
    CGFloat maxX = CGRectGetMaxX(self.scrollView.selectedButton.frame);
    if (maxX > self.scrollView.bounds.size.width) {
        //说明已经超出了右边界
        [self.scrollView setContentOffset:CGPointMake(maxX - self.scrollView.bounds.size.width, 0) animated:YES];
    }else if (self.scrollView.selectedButton.frame.origin.x < 0){
        //说明已经超出了左边界
        [self.scrollView setContentOffset:CGPointMake(-self.scrollView.selectedButton.frame.origin.x, 0) animated:YES];
    }
    else{
        [self.scrollView setContentOffset:CGPointZero animated:YES];
    }
    
    
    //不存在子菜单，直接通知代理
    if ([self.delegate respondsToSelector:@selector(dropDownMenu:didChildItemSelected:)]) {
        [self.delegate dropDownMenu:self didChildItemSelected:item];
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




















