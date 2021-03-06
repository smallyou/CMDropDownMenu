//
//  CMMenuScrollView.m
//  CMDropDownMenu
//
//  Created by 23 on 2017/3/17.
//  Copyright © 2017年 23. All rights reserved.
//

#import "CMMenuScrollView.h"


@interface CMMenuScrollView ()

#pragma mark - 记录变量
/**菜单栏标题文字的宽度*/
@property(nonatomic,strong) NSMutableArray<NSNumber *> *titleWidths;

/**当前选中的菜单按钮*/
@property(nonatomic,strong) CMButton *selectedButton;


@end

@implementation CMMenuScrollView
@synthesize delegate;

#pragma mark - 懒加载
-(NSMutableArray<NSNumber *> *)titleWidths
{
    if (_titleWidths == nil) {
        _titleWidths = [NSMutableArray array];
    }
    return _titleWidths;
}




- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}


- (void)setupUI
{
    //self.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
}

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    
    //移除所有的子控件
    for (UIView *view in self.subviews) {
        if (view && [view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    //清空
    [self.titleWidths removeAllObjects];
    
    
    //根据数据源添加菜单
    NSInteger tag = 2000;
    UIFont *font = (self.menuTitleFont == nil?[UIFont systemFontOfSize:16.0]:self.menuTitleFont);
    UIColor *color = (self.menuTitleColor == nil?[UIColor blackColor]:self.menuTitleColor);
    for (NSString *title in titles) {
        
        //1 计算
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:font}];
        [self.titleWidths addObject:@(titleSize.width)];
        
        //2 创建按钮
        CMButton *button = [[CMButton alloc]init];
        button.titleLabel.font = font;
        [button setTitleColor:color forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        button.menuTitle = title;   //记录，供之后恢复使用
        [button setImage:[UIImage imageNamed:@"resource.bundle/arrow_down"] forState:UIControlStateNormal];
        button.tag = tag;
        [button addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        //3 tag
        tag++;
    }
    

    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    if(self.menuBarScrollable){
        //1 布局titleButton
        NSInteger i = 0;
        CGFloat maxWidth = 0;
        CGFloat margin = 1;
        CGFloat baseWidth = self.bounds.size.width / 4.0;
        if (self.titles.count < 4) {
            baseWidth = self.bounds.size.width / self.titles.count;
        }
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[CMButton class]]) {
                
                CMButton *button = (CMButton *)view;
                CGFloat titleWidth = [self.titleWidths[i] floatValue];
                
                //2.1 定义变量
                CGFloat x = 0;
                CGFloat y = 0;
                CGFloat width = titleWidth + 20;
                if (width < baseWidth) {
                    width = baseWidth;
                }
                CGFloat height = self.bounds.size.height;
                
                //2.2 计算
                x = maxWidth;
                button.frame = CGRectMake(x, y, width, height);
                [button layoutSubviews];
                
                //2.3 flag
                i++;
                maxWidth = maxWidth + width + margin;
            }
        }
        
        //2 内容宽度
        self.contentSize = CGSizeMake(maxWidth, self.bounds.size.height);
        
    }
    //平分按钮
    else{
        NSInteger i = 0;
        CGFloat margin = 1;
        CGFloat width = (self.bounds.size.width  - (self.titles.count - 1) * margin) / self.titles.count;
        for (UIView *view in self.subviews) {
            
            if ([view isKindOfClass:[CMButton class]]) {
             
                CMButton *button = (CMButton *)view;
                button.frame = CGRectMake(i * (width + margin), 0, width, self.bounds.size.height);
                i++;
                [button layoutSubviews];
            }
        }
        
    }

}


#pragma mark - 事件监听
-(void)menuBtnClick:(CMButton *)button
{
    //重复点击
    if ([self.selectedButton isEqual:button] && [self.delegate respondsToSelector:@selector(menuScrollView:didMenuBtnDoubleClick:)]) {
        
        if (!button.isSelected) {
            button.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }else{
            button.imageView.transform = CGAffineTransformIdentity;
        }
        
        [self.delegate menuScrollView:self didMenuBtnDoubleClick:button];
        
        return;
    }
    
    
    
    
    // 标识选中
    self.selectedButton.selected = NO;
    //--设置图片旋转
    self.selectedButton.imageView.transform = CGAffineTransformRotate(self.selectedButton.imageView.transform, -M_PI);
    button.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    self.selectedButton.imageView.transform = CGAffineTransformIdentity;
    button.selected = YES;
    self.selectedButton = button;
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(menuScrollView:didMenuBtnClick:)]) {
        [self.delegate menuScrollView:self didMenuBtnClick:button];
    }
    
}

- (CMButton *)cm_buttonWithIndex:(NSInteger)index
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[CMButton class]] && (view.tag == index + 2000)) {
            return (CMButton *)view;
        }
    }
    return nil;
}


@end
