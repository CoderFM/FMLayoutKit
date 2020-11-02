//
//  FMViewController.m
//  FMLayoutKit
//
//  Created by zhoufaming251@163.com on 06/09/2020.
//  Copyright (c) 2020 zhoufaming251@163.com. All rights reserved.
//

#import "FMViewController.h"
#import <FMLayoutKit/FMLayoutKit.h>
#import <Masonry/Masonry.h>

#import "FMCollectionCustomDecoration.h"
#import "FMCollectionCustomCell.h"
#import "FMCollectionNavTitleView.h"

#import "FMCollViewController.h"
#import "LS_HomeActivityCell.h"

#import "FMFPSLabel.h"

@interface FMViewController ()<FMTeslaLayoutViewDelegate, FMTeslaLayoutViewDataSource>

@property(nonatomic, strong)NSMutableArray<FMLayoutBaseSection *> *shareSections;
@property(nonatomic, strong)NSMutableArray<FMLayoutBaseSection *> *sections;

@property(nonatomic, weak)FMTeslaLayoutView *multiScreen;
@property(nonatomic, weak)FMCollectionNavTitleView *navTitleView;

@property(nonatomic, weak)UILabel *fpsLabel;
@property(nonatomic, assign)BOOL hasAdd;
@end

@implementation FMViewController

- (FMTeslaLayoutView *)multiScreen{
    if (_multiScreen == nil) {
        FMTeslaLayoutView *multi = [[FMTeslaLayoutView alloc] init];
        multi.selectIndex = 2;
        multi.delegate = self;
        multi.dataSource = self;
//        multi.clipsToBounds = YES;
//        multi.allShareStickTop = YES;
        [self.view addSubview:multi];
        _multiScreen = multi;
    }
    return _multiScreen;
}

- (void)setNavTitleView:(FMCollectionNavTitleView *)navTitleView{
    if (_navTitleView == nil) {
        [navTitleView selectWithIndex:self.multiScreen.selectIndex];
    }
    _navTitleView = navTitleView;
    __weak typeof(self) weakSelf = self;
    [navTitleView setClickBlock:^(NSInteger tag) {
        [weakSelf.multiScreen scrollToIndex:tag animated:YES];
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.fpsLabel) {
        FMFPSLabel *label = [[FMFPSLabel alloc] initWithFrame:CGRectMake(40, 50, 100, 20)];
        [self.view.window addSubview:label];
        self.fpsLabel = label;
    }
}

- (void)add{
    self.hasAdd = YES;
    [self.multiScreen reLoadSubViews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"特斯拉布局";

    self.automaticallyAdjustsScrollViewInsets = NO;
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"添加刷新" style:UIBarButtonItemStyleDone target:self action:@selector(add)];
    self.navigationItem.rightBarButtonItem = item1;
    self.shareSections = [NSMutableArray array];
    self.sections = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
//    [FMLayoutDebugLog closeLog];
//    FMLayoutOpenLog();
    {
        FMLayoutDynamicSection *section = [FMLayoutDynamicSection sectionWithSectionInset:UIEdgeInsetsMake(5, 15, 5, 15) itemSpace:10 lineSpace:10 column:2];

        section.cellFixedSize = 166;
        section.autoHeightFixedWidth = YES;
        //
        section.itemDatas = [@[@1, @1, @1, @1, @1, @1] mutableCopy];
        section.cellElement = [FMLayoutElement elementWithViewClass:[LS_HomeActivityCell class]];
        [section setConfigureCellData:^(FMLayoutBaseSection * _Nonnull section, UICollectionViewCell * _Nonnull cell, NSInteger item) {
            if (item == 0) {
                ((LS_HomeActivityCell *)cell).introLabel.text = @" 一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少肯德基分离式的";
                return;
            }
            if (item == 1) {
                ((LS_HomeActivityCell *)cell).introLabel.text = @" 一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少肯德基分离式的\n爱神的箭埃里克森基多拉\n离开时尽量少肯德基分离式的";
                return;
            }
            if (item == 2) {
                ((LS_HomeActivityCell *)cell).introLabel.text = @" 一些描述";
                return;
            }
            if (item == 3) {
                ((LS_HomeActivityCell *)cell).introLabel.text = @" 一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少\n离开时尽量少肯德基分离式的一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少\n离开时尽量少肯德基分离式的一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少\n离开时尽量少肯德基分离式的一些描述\n爱神的箭埃里克森基多拉\n离开时尽量少\n离开时尽量少肯德基分离式的";
            } else {
                ((LS_HomeActivityCell *)cell).introLabel.text = @"asdjlakjdlaksjdlakjdlask";
            }
        }];
        [self.shareSections addObject:section];
    }
    
    {
        FMLayoutFixedSection *section = [FMLayoutFixedSection sectionWithSectionInset:UIEdgeInsetsMake(0, 15, 15, 15) itemSpace:10 lineSpace:10 column:2];

        section.header = [FMLayoutHeader elementSize:100 viewClass:[FMCollectionCustomDecoration class]];
        section.header.lastMargin = 10;
//        section.header.type = FMSupplementaryTypeSuspensionAlways;
//        section.header.isStickTop = YES;
        section.header.inset = UIEdgeInsetsMake(0, -15, 0, -15);

//        section.footer = [FMSupplementaryFooter elementSize:50 viewClass:[FMCollectionCustomDecoration class]];
//        section.footer.topMargin = 10;

        section.itemSize = CGSizeMake(100, 100);
        section.itemDatas = [@[@"1", @"2", @"3"] mutableCopy];
        section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];

        [section setConfigureCellData:^(FMLayoutBaseSection * _Nonnull section, UICollectionViewCell * _Nonnull cell, NSInteger item) {
            FMCollectionCustomCell *customCell = (FMCollectionCustomCell *)cell;
            customCell.contentView.backgroundColor = [UIColor yellowColor];
        }];
        
        [section setClickCellBlock:^(FMLayoutBaseSection * _Nonnull section, NSInteger item) {
            FMCollViewController *vc = [[FMCollViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];

        [self.shareSections addObject:section];
    }
//    {
//        FMLayoutFixedSection *section = [FMLayoutFixedSection sectionWithSectionInset:UIEdgeInsetsMake(0, 0, 0, 0) itemSpace:10 lineSpace:10 column:3];
//
//        section.header = [FMSupplementaryHeader elementSize:150 viewClass:[FMCollectionCustomDecoration class]];
//        section.header.zIndex = FMLayoutZIndexFrontOfItem;
//        section.header.type = FMSupplementaryTypeFixed;
//        section.header.lastMargin = 10;
//
//        section.isHorizontalCanScroll = YES;
//        section.itemSize = CGSizeMake(150, 100);
//        section.itemDatas = [@[@"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", ] mutableCopy];
//        section.cellElement = [FMCollectionViewElement elementWithViewClass:[FMCollectionCustomCell class]];
//        [section setConfigureCellData:^(FMLayoutBaseSection * _Nonnull section, UICollectionViewCell * _Nonnull cell, NSInteger item) {
//
//        }];
//        [self.shareSections addObject:section];
//    }
//
    {
        FMLayoutDynamicSection *section = [FMLayoutDynamicSection sectionWithSectionInset:UIEdgeInsetsMake(0, 0, 0, 0) itemSpace:0 lineSpace:10 column:1];
        section.header = [FMLayoutHeader elementSize:100 viewClass:[FMCollectionNavTitleView class]];
        section.header.type = FMLayoutHeaderTypeSuspensionAlways;
        section.header.zIndex = FMLayoutZIndexFrontAlways;
//        section.header.isStickTop = YES;
        [section setConfigureHeaderData:^(FMLayoutBaseSection * _Nonnull section, UICollectionReusableView * _Nonnull header) {
            weakSelf.navTitleView = (FMCollectionNavTitleView *)header;
        }];
        [self.shareSections addObject:section];
    }
//    self.multiScreen.shareSections = self.shareSections;
    
    
    {
        FMLayoutDynamicSection *section = [FMLayoutDynamicSection sectionWithSectionInset:UIEdgeInsetsMake(0, 0, 0, 0) itemSpace:0 lineSpace:10 column:1];

        section.header = [FMLayoutHeader elementSize:100 viewClass:[FMCollectionCustomDecoration class]];
        section.header.lastMargin = 10;
//        section.header.suspensionTopHeight = 70;
//        section.header.type = FMSupplementaryTypeSuspensionAlways;
//        section.header.zIndex = FMLayoutZIndexFrontAlways;
//        section.header.isStickTop = YES;
        section.header.inset = UIEdgeInsetsMake(0, -15, 0, -15);

        section.footer = [FMLayoutFooter elementSize:50 viewClass:[FMCollectionCustomDecoration class]];
        section.footer.topMargin = 10;

        section.itemDatas = [@[@"1", @"2", @"3"] mutableCopy];
        section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];
        section.cellFixedSize = [UIScreen mainScreen].bounds.size.width;
        [section setOtherBlock:^CGFloat(id  _Nonnull section, NSInteger item) {
            return 100 + item * 100;
        }];

        [self.sections addObject:section];
    }
    
    {
        FMLayoutDynamicSection *section = [FMLayoutDynamicSection sectionWithSectionInset:UIEdgeInsetsMake(10, 0, 0, 0) itemSpace:10 lineSpace:10 column:2];

        section.header = [FMLayoutHeader elementSize:100 viewClass:[FMCollectionCustomDecoration class]];
        section.header.lastMargin = 10;

        section.footer = [FMLayoutFooter elementSize:50 viewClass:[FMCollectionCustomDecoration class]];
        section.footer.topMargin = 10;

        section.itemDatas = [@[@"1", @"2", @"3", @"2", @"3", @"2", @"3"] mutableCopy];
        section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];
        section.cellFixedSize = ([UIScreen mainScreen].bounds.size.width - 10) * 0.5;
        [section setOtherBlock:^CGFloat(id  _Nonnull section, NSInteger item) {
            return 100 + item * 30;
        }];
        
        __weak typeof(self) weakSelf = self;
        [section setClickCellBlock:^(FMLayoutBaseSection * _Nonnull section, NSInteger item) {
            FMCollViewController *vc = [[FMCollViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        FMLayoutCrossSection *horSection = [FMLayoutCrossSection sectionAutoWithSection:section];
        [horSection setConfigureCollectionView:^(UICollectionView * _Nonnull collectionView, FMLayoutCrossSection *inSection) {
            collectionView.pagingEnabled = YES;
        }];
        [self.sections addObject:horSection];
    }

    {
        FMLayoutDynamicSection *section = [FMLayoutDynamicSection sectionWithSectionInset:UIEdgeInsetsMake(10, 0, 0, 0) itemSpace:10 lineSpace:10 column:2];

        section.header = [FMLayoutHeader elementSize:100 viewClass:[FMCollectionCustomDecoration class]];
        section.header.lastMargin = 10;

        section.footer = [FMLayoutFooter elementSize:50 viewClass:[FMCollectionCustomDecoration class]];
        section.footer.topMargin = 10;

        section.itemDatas = [@[@"1\n1", @"2\n2\n2", @"3", @"2\n2\n2\n2\n2\n2\n2\n2\n2", @"3\n2\n2\n2\n2", @"2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2", @"3\n2\n2"] mutableCopy];
        section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];
        section.cellFixedSize = ([UIScreen mainScreen].bounds.size.width - 10) * 0.5;

        section.autoHeightFixedWidth = YES;
        __weak typeof(self) weakSelf = self;
        [section setConfigurationCell:^(FMLayoutDynamicSection * _Nonnull section, UICollectionViewCell * _Nonnull cell, NSInteger index) {
            FMCollectionCustomCell *custom = (FMCollectionCustomCell *)cell;
            custom.label.text = section.itemDatas[index];
//            [weakSelf tesla:nil configurationCell:cell indexPath:[NSIndexPath indexPathForItem:index inSection:section.indexPath.section] isShare:NO multiIndex:0 layoutView:nil];
        }];
//        [self.sections addObject:section];
    }
//
    {
        FMLayoutLabelSection *section = [FMLayoutLabelSection sectionWithSectionInset:UIEdgeInsetsMake(0, 0, 0, 0) itemSpace:10 lineSpace:10 column:3];

        section.header = [FMLayoutHeader elementSize:30 viewClass:[FMCollectionCustomDecoration class]];
        section.header.zIndex = FMLayoutZIndexFrontOfItem;
        section.header.type = FMLayoutHeaderTypeFixed;
        section.header.lastMargin = 10;

//        section.isSingleLineCanScroll = YES;
        section.maxLine = 6;
        section.cellFixedHeight = 40;
        [section setWidthBlock:^CGFloat(id  _Nonnull section, NSInteger item) {
            return item * 20 + 100;
        }];
        section.itemDatas = [@[@"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", ] mutableCopy];
        section.cellElement = [FMLayoutElement elementWithViewClass:[FMCollectionCustomCell class]];
        [self.sections addObject:section];
    }
//
    self.view.backgroundColor = [UIColor cyanColor];
    
    [self.multiScreen reLoadSubViews];
    [self.multiScreen reloadData];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.multiScreen.frame = CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height - 100);
}

- (CGFloat)shareSuspensionMinHeightWithTesla:(FMTeslaLayoutView *)tesla{
    return 70;
}

- (void)tesla:(FMTeslaLayoutView *)tesla willCreateScrollViewWithIndex:(NSInteger)index{
    NSLog(@"willCreateLayoutViewWithIndex %ld", (long)index);
}

- (void)tesla:(FMTeslaLayoutView *)tesla didCreatedScrollViewWithIndex:(NSInteger)index scrollView:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[FMLayoutView class]]) {
        ((FMLayoutView *)scrollView).sections = [self.sections mutableCopy];
    }
    NSLog(@"didCreatedLayoutViewWithIndex %ld", (long)index);
}

- (UIScrollView *)tesla:(FMTeslaLayoutView *)tesla customCreateWithIndex:(NSInteger)index shareHeight:(CGFloat)shareHeight{
    if (index == 3) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, shareHeight + 100)];
        header.backgroundColor = [UIColor purpleColor];
        tableView.tableHeaderView = header;
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1000)];
        footer.backgroundColor = [UIColor orangeColor];
        tableView.tableFooterView = footer;
        return tableView;
    }
    return nil;
}

- (void)tesla:(FMTeslaLayoutView *)tesla didScrollEnd:(NSInteger)index currentScrollView:(nonnull FMLayoutView *)layoutView{
    [self.navTitleView selectWithIndex:index];
}

- (NSInteger)numberOfScreenInTesla:(nonnull FMTeslaLayoutView *)tesla {
    return self.hasAdd ? 4 : 0;
}

- (NSArray<FMLayoutBaseSection *> *)shareSectionsInTesla:(FMTeslaLayoutView *)tesla{
    return self.shareSections;
}

@end

