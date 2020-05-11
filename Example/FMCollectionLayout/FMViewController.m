//
//  FMViewController.m
//  FMCollectionLayout
//
//  Created by 周发明 on 04/01/2020.
//  Copyright (c) 2020 周发明. All rights reserved.
//

#import "FMViewController.h"
#import <FMCollectionLayout.h>
#import <Masonry/Masonry.h>

#import "FMCollectionCustomDecoration.h"
#import "FMCollectionCustomCell.h"
#import "FMCollectionNavTitleView.h"

#import "FMCollViewController.h"

@interface FMViewController ()<FMTeslaLayoutViewDelegate, FMTeslaLayoutViewDataSource>

@property(nonatomic, strong)NSMutableArray<FMLayoutBaseSection *> *shareSections;
@property(nonatomic, strong)NSMutableArray<FMLayoutBaseSection *> *sections;

@property(nonatomic, weak)FMTeslaLayoutView *multiScreen;
@property(nonatomic, weak)FMCollectionNavTitleView *navTitleView;
@end

@implementation FMViewController

- (FMTeslaLayoutView *)multiScreen{
    if (_multiScreen == nil) {
        FMTeslaLayoutView *multi = [[FMTeslaLayoutView alloc] init];
        multi.delegate = self;
        multi.dataSource = self;
        [self.view addSubview:multi];
        _multiScreen = multi;
    }
    return _multiScreen;
}

- (void)setNavTitleView:(FMCollectionNavTitleView *)navTitleView{
    _navTitleView = navTitleView;
    [navTitleView setClickBlock:^(NSInteger tag) {
        [self.multiScreen scrollToIndex:tag animated:YES];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shareSections = [NSMutableArray array];
    self.sections = [NSMutableArray array];
    
    {
        FMLayoutFixedSection *section = [FMLayoutFixedSection sectionWithSectionInset:UIEdgeInsetsMake(0, 15, 15, 15) itemSpace:10 lineSpace:10 column:2];
        
        section.header = [FMSupplementaryHeader supplementaryHeight:100 viewClass:[FMCollectionCustomDecoration class]];
        section.header.bottomMargin = 10;
        section.header.type = FMSupplementaryTypeSuspensionBigger;
        section.header.inset = UIEdgeInsetsMake(0, -15, 0, -15);
        
//        section.footer = [FMSupplementaryFooter supplementaryHeight:50 viewClass:[FMCollectionCustomDecoration class]];
//        section.footer.topMargin = 10;
        
        section.itemSize = CGSizeMake(100, 100);
        section.itemDatas = [@[@"1", @"2", @"3"] mutableCopy];
        section.cellElement = [FMCollectionViewElement elementWithViewClass:[FMCollectionCustomCell class]];
        
        [section setConfigureCellData:^(FMLayoutBaseSection * _Nonnull section, UICollectionViewCell * _Nonnull cell, NSInteger item) {
            FMCollectionCustomCell *customCell = (FMCollectionCustomCell *)cell;
            customCell.contentView.backgroundColor = [UIColor yellowColor];
        }];
        
        [section setClickCellBlock:^(FMLayoutBaseSection * _Nonnull section, NSInteger item) {
            FMCollViewController *vc = [[FMCollViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        [self.shareSections addObject:section];
    }
//    {
//        FMLayoutFixedSection *section = [FMLayoutFixedSection sectionWithSectionInset:UIEdgeInsetsMake(0, 0, 0, 0) itemSpace:10 lineSpace:10 column:3];
//
//        section.header = [FMSupplementaryHeader supplementaryHeight:150 viewClass:[FMCollectionCustomDecoration class]];
//        section.header.zIndex = FMSupplementaryZIndexFrontOfItem;
//        section.header.type = FMSupplementaryTypeFixed;
//        section.header.bottomMargin = 10;
//
//        section.isHorizontalCanScroll = YES;
//        section.itemSize = CGSizeMake(150, 100);
//        section.itemDatas = [@[@"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", ] mutableCopy];
//        section.cellElement = [FMCollectionViewElement elementWithViewClass:[FMCollectionCustomCell class]];
//        [self.shareSections addObject:section];
//    }
//
    {
        FMLayoutDynamicSection *section = [FMLayoutDynamicSection sectionWithSectionInset:UIEdgeInsetsMake(0, 0, 0, 0) itemSpace:0 lineSpace:10 column:1];
        section.header = [FMSupplementaryHeader supplementaryHeight:100 viewClass:[FMCollectionNavTitleView class]];
        section.header.type = FMSupplementaryTypeSuspensionAlways;
        section.header.zIndex = FMSupplementaryZIndexFrontAlways;
        [section setConfigureHeaderData:^(FMLayoutBaseSection * _Nonnull section, UICollectionReusableView * _Nonnull header) {
            self.navTitleView = (FMCollectionNavTitleView *)header;
        }];
        [self.shareSections addObject:section];
    }
//    self.multiScreen.shareSections = self.shareSections;
    
    
    {
        FMLayoutDynamicSection *section = [FMLayoutDynamicSection sectionWithSectionInset:UIEdgeInsetsMake(10, 0, 0, 0) itemSpace:0 lineSpace:10 column:1];
        
        section.header = [FMSupplementaryHeader supplementaryHeight:100 viewClass:[FMCollectionCustomDecoration class]];
        section.header.bottomMargin = 10;
        section.header.suspensionTopHeight = 70;
        section.header.type = FMSupplementaryTypeSuspensionAlways;
        section.header.zIndex = FMSupplementaryZIndexFrontAlways;
        section.header.inset = UIEdgeInsetsMake(0, -15, 0, -15);
        
        section.footer = [FMSupplementaryFooter supplementaryHeight:50 viewClass:[FMCollectionCustomDecoration class]];
        section.footer.topMargin = 10;
        
        section.itemDatas = [@[@"1", @"2", @"3"] mutableCopy];
        section.cellElements = @[[FMCollectionViewElement elementWithViewClass:[FMCollectionCustomCell class]]];
        section.cellFixedWidth = [UIScreen mainScreen].bounds.size.width;
        [section setHeightBlock:^CGFloat(id  _Nonnull section, NSInteger item) {
            return 100 + item * 100;
        }];
        [section setDeqCellReturnReuseId:^NSString * _Nonnull(FMLayoutDynamicSection * _Nonnull section, NSInteger index) {
            return [section.cellElements firstObject].reuseIdentifier;
        }];
        
        [self.sections addObject:section];
    }
    
    {
        FMLayoutDynamicSection *section = [FMLayoutDynamicSection sectionWithSectionInset:UIEdgeInsetsMake(10, 0, 0, 0) itemSpace:10 lineSpace:10 column:2];
        
        section.header = [FMSupplementaryHeader supplementaryHeight:100 viewClass:[FMCollectionCustomDecoration class]];
        section.header.bottomMargin = 10;
        
        section.footer = [FMSupplementaryFooter supplementaryHeight:50 viewClass:[FMCollectionCustomDecoration class]];
        section.footer.topMargin = 10;
        
        section.itemDatas = [@[@"1", @"2", @"3", @"2", @"3", @"2", @"3"] mutableCopy];
        section.cellElements = @[[FMCollectionViewElement elementWithViewClass:[FMCollectionCustomCell class]]];
        section.cellFixedWidth = ([UIScreen mainScreen].bounds.size.width - 10) * 0.5;
        [section setHeightBlock:^CGFloat(id  _Nonnull section, NSInteger item) {
            return 100 + item * 30;
        }];
        [section setDeqCellReturnReuseId:^NSString * _Nonnull(FMLayoutDynamicSection * _Nonnull section, NSInteger index) {
            return [section.cellElements firstObject].reuseIdentifier;
        }];
        [self.sections addObject:section];
    }
    
    {
        FMLayoutDynamicSection *section = [FMLayoutDynamicSection sectionWithSectionInset:UIEdgeInsetsMake(10, 0, 0, 0) itemSpace:10 lineSpace:10 column:2];
        
        section.header = [FMSupplementaryHeader supplementaryHeight:100 viewClass:[FMCollectionCustomDecoration class]];
        section.header.bottomMargin = 10;
        
        section.footer = [FMSupplementaryFooter supplementaryHeight:50 viewClass:[FMCollectionCustomDecoration class]];
        section.footer.topMargin = 10;
        
        section.itemDatas = [@[@"1\n1", @"2\n2\n2", @"3", @"2\n2\n2\n2\n2\n2\n2\n2\n2", @"3\n2\n2\n2\n2", @"2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2\n2", @"3\n2\n2"] mutableCopy];
        section.cellElements = @[[FMCollectionViewElement elementWithViewClass:[FMCollectionCustomCell class]]];
        section.cellFixedWidth = ([UIScreen mainScreen].bounds.size.width - 10) * 0.5;
        [section setDeqCellReturnReuseId:^NSString * _Nonnull(FMLayoutDynamicSection * _Nonnull section, NSInteger index) {
            return [section.cellElements firstObject].reuseIdentifier;
        }];
        
        section.autoHeightFixedWidth = YES;
        __weak typeof(self) weakSelf = self;
        [section setConfigurationCell:^(FMLayoutDynamicSection * _Nonnull section, UICollectionViewCell * _Nonnull cell, NSInteger index) {
            FMCollectionCustomCell *custom = (FMCollectionCustomCell *)cell;
            custom.label.text = section.itemDatas[index];
//            [weakSelf tesla:nil configurationCell:cell indexPath:[NSIndexPath indexPathForItem:index inSection:section.indexPath.section] isShare:NO multiIndex:0 layoutView:nil];
        }];
        [self.sections addObject:section];
    }
    
    {
        FMLayoutLabelSection *section = [FMLayoutLabelSection sectionWithSectionInset:UIEdgeInsetsMake(0, 0, 0, 0) itemSpace:10 lineSpace:10 column:3];
        
        section.header = [FMSupplementaryHeader supplementaryHeight:30 viewClass:[FMCollectionCustomDecoration class]];
        section.header.zIndex = FMSupplementaryZIndexFrontOfItem;
        section.header.type = FMSupplementaryTypeFixed;
        section.header.bottomMargin = 10;
        
        section.isSingleLineCanScroll = YES;
        section.maxLine = 6;
        section.cellFixedHeight = 40;
        [section setWidthBlock:^CGFloat(id  _Nonnull section, NSInteger item) {
            return item * 20 + 100;
        }];
        section.itemDatas = [@[@"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", ] mutableCopy];
        section.cellElement = [FMCollectionViewElement elementWithViewClass:[FMCollectionCustomCell class]];
        [self.sections addObject:section];
    }
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    [self.multiScreen reLoadSubViews];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.multiScreen.frame = CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height - 100);
}

- (CGFloat)shareSuspensionMinHeightWithTesla:(FMTeslaLayoutView *)tesla{
    return 70;
}

- (void)tesla:(FMTeslaLayoutView *)tesla willCreateLayoutViewWithIndex:(NSInteger)index{
    NSLog(@"willCreateLayoutViewWithIndex %ld", (long)index);
}

- (void)tesla:(FMTeslaLayoutView *)tesla didCreatedLayoutViewWithIndex:(NSInteger)index layoutView:(FMCollectionLayoutView *)layoutView{
    NSLog(@"didCreatedLayoutViewWithIndex %ld", (long)index);
}

- (void)tesla:(FMTeslaLayoutView *)tesla didScrollEnd:(NSInteger)index currentLayoutView:(nonnull FMCollectionLayoutView *)layoutView{
    [self.navTitleView selectWithIndex:index];
}

- (void)tesla:(FMTeslaLayoutView *)tesla didSelectIndexPath:(NSIndexPath *)indexPath isShare:(BOOL)isSahre multiIndex:(NSInteger)multiIndex layoutView:(FMCollectionLayoutView *)layoutView{
    FMCollViewController *coll = [[FMCollViewController alloc] init];
    [self.navigationController pushViewController:coll animated:YES];
}

- (NSInteger)numberOfScreenInTesla:(nonnull FMTeslaLayoutView *)tesla {
    return 4;
}

- (nonnull NSMutableArray<FMLayoutBaseSection *> *)tesla:(nonnull FMTeslaLayoutView *)tesla sectionsInScreenIndex:(NSInteger)screenIndex {
    return [self.sections mutableCopy];
}

- (NSArray<FMLayoutBaseSection *> *)shareSectionsInTesla:(FMTeslaLayoutView *)tesla{
    return self.shareSections;
}

@end
