//
//  FMCollectionNavTitleView.m
//  FMCollectionLayout_Example
//
//  Created by 郑桂华 on 2020/4/9.
//  Copyright © 2020 周发明. All rights reserved.
//

#import "FMCollectionNavTitleView.h"
#import <Masonry/Masonry.h>

@interface FMCollectionNavTitleView ()

@property(nonatomic, weak)UIView *contentView;

@property(nonatomic, weak)UIButton *selectBtn;
@property(nonatomic, strong)NSMutableArray *btns;
@end

@implementation FMCollectionNavTitleView

- (void)selectWithIndex:(NSInteger)index{
    self.selectBtn = [self viewWithTag:index + 100];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *contentView = [[UIView alloc] init];
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(100);
        }];
        self.contentView = contentView;
        self.contentView.backgroundColor = [UIColor greenColor];
        self.btns = [NSMutableArray array];
        [self reCreateBtns];
    }
    return self;
}

- (void)setSelectBtn:(UIButton *)selectBtn{
    _selectBtn.selected = NO;
    _selectBtn = selectBtn;
    _selectBtn.selected = YES;
}

- (void)reCreateBtns{
    self.titles = @[@"标签1", @"标签2", @"标签3", @"标签4"];
    
    UIButton *left = nil;
    CGFloat multiplied = 1 / (self.titles.count * 1.0);
    for (int i = 0; i < self.titles.count; i++) {
        NSString *title = self.titles[i];
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = 100+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
       [btn setTitle:title forState:UIControlStateNormal];
       [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
       [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (left) {
                make.left.mas_equalTo(left.mas_right);
            } else {
                make.left.mas_equalTo(0);
            }
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(self.mas_width).multipliedBy(multiplied);
        }];
        [self.btns addObject:btn];
        left = btn;
        if (i == 0) {
            self.selectBtn = btn;
        }
    }
    [self btnClick:self.selectBtn];
}

- (void)btnClick:(UIButton *)sender{
    !self.clickBlock?:self.clickBlock(sender.tag-100);
    self.selectBtn = sender;
}

- (void)teslaSuspensionHeaderShouldShowHeight:(CGFloat)showHeight{
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(showHeight);
    }];
    for (UIButton *btn in self.btns) {
        btn.titleLabel.font = [UIFont systemFontOfSize:16 + (100 - showHeight) / 40.0 * 10];
    }
}

@end
